function session_ca = generate_session_ca(im_session,num_files,signalChannels,neuropilDilationRange,handles,overwrite)
 	%% -- Setup
	numFOVs = im_session.ref.im_props.numPlanes;
	num_chan = im_session.ref.im_props.nchans;
	roiArray = im_session.ref.roi_array;
	num_x_pixels = im_session.ref.im_props.width;
	num_y_pixels = im_session.ref.im_props.height;

	data_dir = im_session.basic_info.data_dir;
	roi_array_fname = im_session.ref.roi_array_fname;
	[pathstr,roi_name,ext] = fileparts(roi_array_fname);

	signalChannels = num2str(signalChannels);		
		
  	roiIds = [];
  	roiFOVidx = [];
	for ik=1:numel(roiArray)
		roiIds = [roiIds roiArray{ik}.roiIds];
		roiFOVidx = [roiFOVidx repmat(ik,1,length(roiArray{ik}))];
	end

	if (length(unique(roiIds)) ~= length(roiIds))
	    error('generateCalciumTimeSeriesArray::some roiIDs get repeated among roiArray objects passed; this is not allowed.  Aborting.');
	end

	processedRoi = generate_roi_indices(roiArray,neuropilDilationRange,roi_array_fname,overwrite);

	num_frames = sum(im_session.reg.nFrames(1:num_files));
	rawRoiData = zeros(length(roiIds),num_frames);
	antiRoiFluoVec = zeros(numFOVs,num_frames);;
	neuropilData = zeros(length(roiIds),num_frames);;
	file_num = zeros(1,num_frames);
	frame_num = zeros(1,num_frames);
	start_ind = 1;
	% --- extract data
	for ij = 1:num_files
		if ~isempty(handles)
			drawnow
			if ~get(handles.togglebutton_gen_catsa,'Value');
				error('Break')
			end
		end
		fprintf('(caTSA)  file %g/%g \n',ij,num_files);
		[rawRoiData_tmp_mat antiRoiFluoVec_tmp_mat neuropilData_tmp_mat] = roiF_extract_cluster(data_dir,num2str(ij),roi_array_fname,roi_name,signalChannels,num2str(overwrite));
	 	num_frame_file = size(rawRoiData_tmp_mat,2);
        rawRoiData(:,start_ind:start_ind+num_frame_file-1) = rawRoiData_tmp_mat;
	 	antiRoiFluoVec(:,start_ind:start_ind+num_frame_file-1) = antiRoiFluoVec_tmp_mat;
	 	neuropilData (:,start_ind:start_ind+num_frame_file-1)= neuropilData_tmp_mat;
		start_ind = start_ind+num_frame_file;
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
