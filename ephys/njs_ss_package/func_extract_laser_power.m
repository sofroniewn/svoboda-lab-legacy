function [laser_data] = func_extract_laser_power(base_dir, file_nums, laser_power_name, over_write)
%%
disp(['--------------------------------------------']);
lite = 1;
f_name_laser_power = fullfile(base_dir,'ephys','sorted',laser_power_name);

       

if over_write == 0 && exist(f_name_laser_power) == 2
    disp(['LOAD LASER POWER']);
    load(f_name_laser_power);
else

    laser_chan = 1;
    
    f_name_flag = '*_trial*.bin';
    file_list = func_list_files(base_dir,f_name_flag,file_nums);

    laser_data.trial = NaN(numel(file_list)-1,1);
    laser_data.powers = cell(numel(file_list)-1,1);
    laser_data.onset_inds = cell(numel(file_list)-1,1);
    laser_data.offset_inds = cell(numel(file_list)-1,1);
    laser_data.onset_times = cell(numel(file_list)-1,1);
    laser_data.offset_times = cell(numel(file_list)-1,1);
    
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

        laser_data.trial(i_trial) = file_nums(i_trial);

        tmp_inds = find(diff(d.aux_chan(:,laser_chan))>.1);
        if length(tmp_inds) > 1
            rmv_ind = diff(tmp_inds) <= 1;
            rmv_ind =[false;rmv_ind];
            tmp_inds(rmv_ind) = [];
        end
        laser_data.onset_inds{i_trial} = tmp_inds;

        tmp_inds = find(diff(d.aux_chan(:,laser_chan))<-.1);
        if length(tmp_inds) > 1
            rmv_ind = diff(tmp_inds) <= 1;
            rmv_ind =[false;rmv_ind];
            tmp_inds(rmv_ind) = [];
        end
        laser_data.offset_inds{i_trial} = tmp_inds;
    
        if length(laser_data.offset_inds{i_trial}) ~= length(laser_data.onset_inds{i_trial})
            error('onsets and offsets not same length')
        end

        laser_data.onset_times{i_trial} = d.TimeStamps(laser_data.onset_inds{i_trial});
        laser_data.offset_times{i_trial} = d.TimeStamps(laser_data.offset_inds{i_trial});
    
        laser_data.powers{i_trial} = NaN(length(laser_data.onset_inds{i_trial}),1);
        for ij = 1:length(laser_data.onset_inds{i_trial})
            laser_data.powers{i_trial}(ij) = mean(d.aux_chan(laser_data.onset_inds{i_trial}(ij):laser_data.offset_inds{i_trial}(ij),laser_chan));
            if laser_data.offset_inds{i_trial}(ij) <= laser_data.onset_inds{i_trial}(ij)
                error('offset does not follow onset')
            end
        end
    
        disp(['--------------------------------------------']);
    end

    save(f_name_laser_power,'laser_data');
end
disp(['--------------------------------------------']);



