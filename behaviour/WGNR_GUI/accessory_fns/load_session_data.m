function session = load_session_data(data_dir)

session.basic_info.data_dir = data_dir;
[pathstr, name, ext] = fileparts(data_dir); 
[pathstr, name, ext] = fileparts(pathstr); 
session.basic_info.run_str = name;
[pathstr, name, ext] = fileparts(pathstr); 
session.basic_info.date_str = name;
[pathstr, name, ext] = fileparts(pathstr); 
session.basic_info.anm_str = name;

cur_files = dir(fullfile(data_dir,'*_trial_*.mat'));
session.data = cell(numel(cur_files)-1,1);

for ij = 1:numel(cur_files)-1
    f_name = fullfile(data_dir,cur_files(ij).name);
    session.data{ij} = load(f_name);
    session.data{ij}.f_name = f_name;
end

cur_file = dir(fullfile(data_dir,'*_rig_config.mat'));
f_name = fullfile(data_dir,cur_file(1).name);
load(f_name);
session.rig_config = rig_config;
session.rig_config.f_name = f_name;

cur_file = dir(fullfile(data_dir,'*_trial_config.mat'));
f_name = fullfile(data_dir,cur_file(1).name);
load(f_name);

session.trial_config = trial_config;
end