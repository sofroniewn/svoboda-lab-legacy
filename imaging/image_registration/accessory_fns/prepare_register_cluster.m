function evalScript = prepare_register_cluster

global im_session;

start_ind = strfind(im_session.basic_info.data_dir,'imreg');

if isempty(start_ind)
	error('DATA NOT ON CLUSTER')
else	
	% set variables
	startTime = 1;
	endTime = numel(im_session.basic_info.cur_files);
	end_path = im_session.basic_info.data_dir(start_ind:end);
	end_path(strfind(end_path,'\')) = '/';
	directory = ['/groups/svoboda/wdbp/',end_path];

	% set paths for the function
	functionPath = '/groups/freeman/home/freemanj11/code/wgnr/imaging/image_registration/accessory_fns/compiled/register_cluster_directory';
	logPath = [directory '/logs/log_'];
	logPath_local = fullfile(im_session.basic_info.data_dir,'logs');
	if ~exist(logPath_local)
		mkdir(logPath_local)
	end

	% create and evaluate the script
	evalScript = sprintf('qsub -t %g-%g -pe batch 1 -N ''register'' -j y -o /dev/null -b y -cwd -V ''%s %s ${SGE_TASK_ID} > %s${SGE_TASK_ID}.log''',startTime, endTime, functionPath, directory, logPath);
	display(evalScript)

	%fullStringQSUB = sprintf('ssh login.int.janelia.org -f "source /sge/current/default/common/settings.sh; %s"', evalScript);
	%system(fullStringQSUB);
	%system('');

	%fullStringQSTAT = sprintf('ssh login.int.janelia.org -f "source /sge/current/default/common/settings.sh; %s"', 'qstat');
	%system(fullStringQSTAT);
	%system('');

end

