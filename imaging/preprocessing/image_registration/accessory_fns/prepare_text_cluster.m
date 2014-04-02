function evalScript = prepare_text_cluster(num_files,analyze_chan)

global im_session;

start_ind = strfind(im_session.basic_info.data_dir,'imreg');

if isempty(start_ind)
	evalScript = 'DATA NOT ON CLUSTER';
	display(evalScript);
	return;
else	
	% set variables
	startTime = 1;
	endTime = im_session.ref.im_props.numPlanes;
	end_path = im_session.basic_info.data_dir(start_ind:end);
	end_path(strfind(end_path,'\')) = '/';
	directory = ['/groups/svoboda/wdbp/',end_path];

	ref_file_name = im_session.ref.file_name;

	if ~isempty(im_session.reg.nFrames)
		num_frames = sum(im_session.reg.nFrames(1:num_files));
		num_frames = num2str(num_frames);
		num_files = num2str(num_files);
		num_pixels = im_session.ref.im_props.height*im_session.ref.im_props.width;
		num_pixels = num2str(num_pixels);
		analyze_chan = num2str(analyze_chan);

		% set paths for the function
		% save_text_cluster(data_dir,'1',analyze_chan,ref_file_name,num_files,num_frames,num_pixels)
		functionPath = '/groups/freeman/home/freemanj11/code/wgnr/imaging/preprocessing/image_registration/accessory_fns/compiled/save_text_cluster';
		logPath = [directory '/logs_text/log_'];
		logPath_local = fullfile(im_session.basic_info.data_dir,'logs_text');
		if ~exist(logPath_local)
			mkdir(logPath_local)
		end

		% create and evaluate the script
		evalScript = sprintf('qsub -t %g-%g -pe batch 1 -N ''register'' -j y -o /dev/null -b y -cwd -V ''%s %s ${SGE_TASK_ID} > %s${SGE_TASK_ID}.log %s %s %s %s %s''',startTime, endTime, functionPath, directory, logPath, analyze_chan, ref_file_name, num_files, num_frames, num_pixels);
		display(evalScript)

	else
		evalScript = 'No frame count';
		display(evalScript)
	end

	%fullStringQSUB = sprintf('ssh login.int.janelia.org -f "source /sge/current/default/common/settings.sh; %s"', evalScript);
	%system(fullStringQSUB);
	%system('');

	%fullStringQSTAT = sprintf('ssh login.int.janelia.org -f "source /sge/current/default/common/settings.sh; %s"', 'qstat');
	%system(fullStringQSTAT);
	%system('');

end
