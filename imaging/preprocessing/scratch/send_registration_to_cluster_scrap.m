HOSTNAME = 'login.int.janelia.org';
USERNAME = 'sofroniewn';
PASSWORD = '22As22As';

ssh2_conn = ssh2_config(HOSTNAME,USERNAME,PASSWORD);


ssh2_conn = ssh2_command(ssh2_conn, 'pwd');

ssh2_conn = ssh2_command(ssh2_conn, 'qstat');


ssh2_conn = ssh2_command(ssh2_conn, 'bash /sge/current/default/common/settings.sh');

'/sge/current/default/common/settings.sh'


anm_name = 'an234870';
date = '2014_03_23';
run = 'run_02';

base_path = '/Volumes/wdbp/imreg/sofroniewn/'
base_path_on_cluster = '/groups/svoboda/wdbp/imreg/sofroniewn/';


data_dir = fullfile(base_path,anm_name,date,run,'scanimage');

cur_files = dir(fullfile(data_dir,'*_main_*.tif'));

% set variables
startTime = 1;
endTime = numel(cur_files);
directory = fullfile(base_path_on_cluster,anm_name,date,run,'scanimage');

% set paths for the function
functionPath = '/groups/freeman/home/freemanj11/code/wgnr/imaging/image_registration/accessory_fns/compiled/register_cluster_directory';
logPath = [directory '/logs/log_'];
%if ~exist(logPath)
%	mkdir(logPath)
%end

% create and evaluate the script
evalScript = sprintf('qsub -t %g-%g -pe batch 1 -N ''register'' -j y -o /dev/null -b y -cwd -V ''%s %s ${SGE_TASK_ID} > %s${SGE_TASK_ID}.log''',startTime, endTime, functionPath, directory, logPath);
display(evalScript)

fullStringQSUB = sprintf('ssh login.int.janelia.org -f "source /sge/current/default/common/settings.sh; %s"', evalScript);
fullStringQSTAT = sprintf('ssh login.int.janelia.org -f "source /sge/current/default/common/settings.sh; %s"', 'qstat');


unix(fullStringQSUB)



ssh2_conn = ssh2_command(ssh2_conn, evalScript);

%eval(evalScript);

