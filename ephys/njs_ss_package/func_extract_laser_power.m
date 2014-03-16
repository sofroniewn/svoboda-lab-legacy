function [laser_data] = func_extract_laser_power(base_dir, file_list, laser_power_name, over_write)
%%
disp(['--------------------------------------------']);
lite = 1;
f_name_laser_power = fullfile(base_dir,'ephys','sorted',laser_power_name);

if over_write == 0 && exist(f_name_laser_power) == 2
    disp(['LOAD LASER POWER']);
    load(f_name_laser_power);
else
    laser_power_ind_range = 50000:60000;
    laser_power = zeros(numel(file_list),1);
    laser_power_onset_ind = zeros(numel(file_list),1);
    laser_power_offset_ind = zeros(numel(file_list),1);
    laser_power_onset = zeros(numel(file_list),1);
    laser_power_offset = zeros(numel(file_list),1);
    
    for i_trial = 1:numel(file_list)-1
        disp(file_list{i_trial});
        
        f_name = fullfile(base_dir,file_list{i_trial});
        f_name_processed_vlt = fullfile(base_dir,'ephys','processed',[file_list{i_trial}(1:end-4) '_processed_vlt.mat']);
        f_name_spikes = fullfile(base_dir,'ephys','processed',[file_list{i_trial}(1:end-4) '_spikes.mat']);
        
        disp(['EXTRACT LASER POWER']);
        if exist(f_name_processed_vlt) == 2
            load(f_name_processed_vlt);
        else
            [p d] = func_process_voltage(f_name,ch_noise,lite);
            save(f_name_processed_vlt,'p','d');
        end
        laser_power(i_trial) = mean(d.allOther_allCh(laser_power_ind_range,1));
        if laser_power(i_trial) > 0.05
            laser_power_onset_ind(i_trial) = find(d.allOther_allCh(:,1) > .05,1,'first');
            laser_power_offset_ind(i_trial) = find(d.allOther_allCh(:,1) < .05,1,'last');
            laser_power_onset(i_trial) = d.TimeStamps(laser_power_onset_ind(i_trial));
            laser_power_offset(i_trial) = d.TimeStamps(laser_power_offset_ind(i_trial));
        end
        
        disp(['--------------------------------------------']);
    end
    laser_data.laser_power = laser_power;
    laser_data.laser_power_onset_ind = laser_power_onset_ind;
    laser_data.laser_power_offset_ind = laser_power_offset_ind;
    laser_data.laser_power_onset = laser_power_onset;
    laser_data.laser_power_offset = laser_power_offset;
    save(f_name_laser_power,'laser_data');
end
disp(['--------------------------------------------']);



