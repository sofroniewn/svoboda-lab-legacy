function [bv_sync] = func_extract_bv_sync(base_dir, file_nums, bv_sync_name, over_write)
%%
disp(['--------------------------------------------']);
lite = 1;
f_name_save = fullfile(base_dir,'ephys','sorted',[bv_sync_name '.mat']);


if over_write == 0 && exist(f_name_save) == 2
    disp(['LOAD bv_sync ']);
    load(f_name_save);
else

    f_name_flag = '*_trial*.bin';
    file_list = func_list_files(base_dir,f_name_flag,file_nums);

    bv_sync.trial = NaN(numel(file_list),1);
    bv_sync.start_ind = NaN(numel(file_list),1);
    bv_sync.start_time = NaN(numel(file_list),1);
    bv_sync.ephys2bv = cell(numel(file_list),1);
    
    for i_trial = 1:numel(file_list)
        disp(file_list{i_trial});
        
        f_name = fullfile(base_dir,file_list{i_trial});
        f_name_processed_vlt = fullfile(base_dir,'ephys','processed',[file_list{i_trial}(1:end-4) '_processed_vlt.mat']);
        f_name_spikes = fullfile(base_dir,'ephys','processed',[file_list{i_trial}(1:end-4) '_spikes.mat']);
        
        disp(['EXTRACT BV SYNC']);
        if exist(f_name_processed_vlt) == 2
            load(f_name_processed_vlt);
        else
            ch_noise = [1:32];
            [p d] = func_process_voltage(f_name,ch_noise);
            save(f_name_processed_vlt,'p','d');
        end
        aux_chan = d.aux_chan(:,1:3);
        ch_ids = p.ch_ids;
        ch_ids.file_trigger = 2;
        ch_ids.frame_trigger = 3;

        [aux_chan ch_ids start_ind] = extract_behaviour_triggers(aux_chan,ch_ids);

        if ~isempty(file_nums)
            bv_sync.trial(i_trial) = file_nums(i_trial);
        else
            bv_sync.trial(i_trial) = i_trial;        
        end
        
        bv_sync.start_ind(i_trial) = start_ind;
        bv_sync.start_time(i_trial) = d.TimeStamps(start_ind);
        bv_sync.ephys2bv{i_trial} = aux_chan(:,end);

        disp(['--------------------------------------------']);
    end

    save(f_name_save,'bv_sync');
end
disp(['--------------------------------------------']);



