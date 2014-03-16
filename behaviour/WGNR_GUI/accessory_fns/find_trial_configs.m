function current_name = find_trial_configs(base_dir,current_name,flag_str)

base_names = dir(fullfile(base_dir,['*' flag_str '.mat']));
current_name = [];
for ij = 1:numel(base_names)
    current_name = [current_name;{fullfile(base_dir,base_names(ij).name)}];
end
    
dir_current_folder = dir(base_dir);
folder_in_folder = dir_current_folder(find(vertcat(dir_current_folder.isdir)));
folder_in_folder = folder_in_folder(3:end);

for ij = 1:numel(folder_in_folder)
    current_name = [current_name;find_trial_configs(fullfile(base_dir,folder_in_folder(ij).name),current_name,flag_str)];
end

%version_control_trial_config(fname,ver_num)