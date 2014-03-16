function update_trial_configs(base_dir)

base_trial_config_dir = fullfile(base_dir,'Trial_configs');
current_name = find_trial_configs(base_trial_config_dir,[],'');


base_data_dir = fullfile(base_dir,'WGNR_DATA');
current_name_data = find_trial_configs(base_data_dir,[],'_trial_config');

current_name = [current_name;current_name_data];

for ij = 1:numel(current_name)
            fname = current_name{ij};
    try
        version_control_trial_config(fname);
    catch
       display(fname);
       display('Failed');
    end
end
