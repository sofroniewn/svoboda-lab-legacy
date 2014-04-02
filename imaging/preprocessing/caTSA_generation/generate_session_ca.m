function session_ca = generate_session_ca(im_session,num_files,signalChannels,neuropilDilationRange)
 	%% -- Setup
	numFOVs = im_session.ref.im_props.numPlanes;
	roiArray = im_session.ref.roi_array;
	
  	roiIds = [];
  	roiFOVidx = [];
	for ik=1:numFOVs
		roiIds = [roiIds roiArray{ik}.roiIds];
		roiFOVidx = [roiFOVidx repmat(ik,1,length(roiArray{ik}))];
		% neuropil
		neuropilRoiArray{ik} = roiArray{ik}.getNeuropilRoiArray (neuropilDilationRange(1), neuropilDilationRange(2));
	end

	if (length(unique(roiIds)) ~= length(roiIds))
	    error('generateCalciumTimeSeriesArray::some roiIDs get repeated among roiArray objects passed; this is not allowed.  Aborting.');
	end
	
	num_frames = sum(im_session.reg.nFrames(1:num_files));
	rawRoiData = zeros(length(roiIds),num_frames);
	antiRoiFluoVec = zeros(numFOVs,num_frames);;
	neuropilData = zeros(length(roiIds),num_frames);;
	file_num = zeros(1,num_frames);
	frame_num = zeros(1,num_frames);
	start_ind = 1;
	% --- extract data
	for ij = 1:num_files
		
		fprintf('(caTSA)  file %g/%g \n',ij,num_files);
		% get file name of registered data
		cur_file = fullfile(im_session.basic_info.data_dir,im_session.basic_info.cur_files(ij).name);
		trial_name = cur_file(end-6:end-4);
		[pathstr, base_name, ext] = fileparts(cur_file);
		% define file name
		replace_start = strfind(base_name,'main');
		replace_end = replace_start+4;
		type_name = 'registered';
		file_name = [base_name(1:replace_start-1) type_name  base_name(replace_end:end)];
		full_file_name = fullfile(im_session.basic_info.data_dir,type_name,[file_name '.mat']);	

		% load in raw registered data
		load(full_file_name);
		num_frame_file = size(im_aligned{1,1},3);
		file_num(start_ind:start_ind+num_frame_file-1) = repmat(ij,1,num_frame_file);
		frame_num(start_ind:start_ind+num_frame_file-1) = [1:num_frame_file];

		% extract Roi, antiRoi, and neuropil data from aligned images
		[rawRoiData_tmp antiRoiFluoVec_tmp neuropilData_tmp] = processRoiArray(roiArray, neuropilRoiArray, im_aligned, signalChannels);
		 % concatenate caTSA variables
		 rawRoiData_tmp_mat = [];
		 antiRoiFluoVec_tmp_mat = [];
		 neuropilData_tmp_mat = [];
		 for ik = 1:numFOVs
		 	rawRoiData_tmp_mat = cat(1,rawRoiData_tmp_mat,rawRoiData_tmp{ik});
		 	antiRoiFluoVec_tmp_mat = cat(1,antiRoiFluoVec_tmp_mat,antiRoiFluoVec_tmp{ik});
		 	neuropilData_tmp_mat = cat(1,neuropilData_tmp_mat,neuropilData_tmp{ik});
		 end

	 	rawRoiData(:,start_ind:start_ind+num_frame_file-1) = rawRoiData_tmp_mat;
	 	antiRoiFluoVec(:,start_ind:start_ind+num_frame_file-1) = antiRoiFluoVec_tmp_mat;
	 	neuropilData (:,start_ind:start_ind+num_frame_file-1)= neuropilData_tmp_mat;
		start_ind = start_ind+num_frame_file;
	end

	if start_ind ~= num_frames+1
		error('Wrong number of frames');
	end
	session_ca.im_session = im_session;	
	session_ca.file_nums = file_num;
	session_ca.frame_nums = frame_num;
	session_ca.roiIds = roiIds';
	session_ca.roiFOVidx = roiFOVidx';
	session_ca.rawRoiData = rawRoiData;
	session_ca.neuropilData = neuropilData;
	session_ca.antiRoiFluoVec = antiRoiFluoVec;
	session_ca.signalChannels = signalChannels;
	session_ca.neuropilDilationRange = neuropilDilationRange;
	
end