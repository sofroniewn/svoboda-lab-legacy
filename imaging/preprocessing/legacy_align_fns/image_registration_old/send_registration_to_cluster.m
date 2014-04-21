%system('ssh login.int.janelia.org')

% set variables
startTime = 1;
endTime = 8;
directory = '/groups/svoboda/wdbp/imreg/sofroniewn/demo';

% set paths for the function
functionPath = '/groups/freeman/home/freemanj11/code/wgnr/imaging/image_registration/accessory_fns/compiled/register_cluster_directory';
logPath = '/groups/svoboda/wdbp/imreg/sofroniewn/logs/log_';
%if ~exist(logPath)
%	mkdir(logPath)
%end

% create and evaluate the script
evalScript = sprintf('!qsub -t %g-%g -pe batch 1 -N ''register'' -j y -o /dev/null -b y -cwd -V ''%s %s ${SGE_TASK_ID} > %s${SGE_TASK_ID}.log''',startTime, endTime, functionPath, directory, logPath);
eval(evalScript);

