function evalScript = prepare_roi_extract_cluster

global im_session;

start_ind = strfind(im_session.basic_info.data_dir,'imreg');

if isempty(start_ind)
	evalScript = 'DATA NOT ON CLUSTER';
	display(evalScript);
	return;
else	
	
	data_dir = im_session.basic_info.data_dir;
	roi_array_fname = im_session.ref.roi_array_fname;
	[pathstr,roi_name,ext] = fileparts(roi_array_fname);

	overwrite = '1';
	signalChannels = '1';

	% set variables
	startTime = 1;
	endTime = numel(im_session.basic_info.cur_files);
	end_path = im_session.basic_info.data_dir(start_ind:end);
	end_path(strfind(end_path,'\')) = '/';
	if ~isempty(strfind(im_session.basic_info.data_dir,'wdbp'))
		directory = ['/groups/svoboda/wdbp/',end_path];
	else
		directory = ['/nobackup/svoboda/sofroniewn/',end_path];	
	end

	end_path = roi_array_fname(start_ind:end);
	end_path(strfind(end_path,'\')) = '/';
	if ~isempty(strfind(im_session.basic_info.data_dir,'wdbp'))
		roi_array_fname = ['/groups/svoboda/wdbp/',end_path];
	else
		roi_array_fname = ['/nobackup/svoboda/sofroniewn/',end_path];	
	end

	% set paths for the function
	functionPath = '/groups/freeman/home/freemanj11/code/wgnr/compiled/roiF_extract_cluster';
	logPath = [directory '/logs_roi/log_'];
	logPath_local = fullfile(im_session.basic_info.data_dir,'logs_roi');
	if ~exist(logPath_local)
		mkdir(logPath_local)
	end

	% create and evaluate the script
	evalScript = sprintf('qsub -t %g-%g -pe batch 1 -N ''roi_extract'' -j y -o /dev/null -b y -cwd -V ''%s %s ${SGE_TASK_ID} > %s${SGE_TASK_ID}.log %s %s %s %s''',startTime, endTime, functionPath, directory, logPath,roi_array_fname,roi_name,signalChannels,overwrite);
	display(evalScript)

	%fullStringQSUB = sprintf('ssh login.int.janelia.org -f "source /sge/current/default/common/settings.sh; %s"', evalScript);
	%system(fullStringQSUB);
	%system('');

	%fullStringQSTAT = sprintf('ssh login.int.janelia.org -f "source /sge/current/default/common/settings.sh; %s"', 'qstat');
	%system(fullStringQSTAT);
	%system('');

end

