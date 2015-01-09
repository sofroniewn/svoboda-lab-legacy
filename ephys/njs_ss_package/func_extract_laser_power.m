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
    laser_data.max_power = NaN(numel(file_list)-1,1);
    laser_data.powers = cell(numel(file_list)-1,1);
    laser_data.onset_inds = cell(numel(file_list)-1,1);
    laser_data.offset_inds = cell(numel(file_list)-1,1);
    laser_data.onset_times = cell(numel(file_list)-1,1);
    laser_data.offset_times = cell(numel(file_list)-1,1);
    laser_data.raw_vlt = [];
    
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
            %error('onsets and offsets not same length')
            if length(laser_data.offset_inds{i_trial}) > length(laser_data.onset_inds{i_trial})
                laser_data.offset_inds{i_trial}(end) = [];
            else
                laser_data.onset_inds{i_trial}(end) = [];
            end
        end

        laser_data.onset_times{i_trial} = d.TimeStamps(laser_data.onset_inds{i_trial});
        laser_data.offset_times{i_trial} = d.TimeStamps(laser_data.offset_inds{i_trial});

        if i_trial == 1
            num_chan = size(d.vlt_chan,2);
            num_samps_pre = round(p.freqSampling*.025);
            num_samps_post = round(p.freqSampling*.095);
            window_range = -num_samps_pre:num_samps_post;
            num_samples = num_samps_pre+num_samps_post+1;
            laser_data.raw_vlt = zeros(numel(file_list)-1,num_chan,num_samples);
            laser_data.time_window = window_range/p.freqSampling;
        end

    ch_LFP = NaN(size(d.vlt_chan));
    for i_ch = 1:size(d.vlt_chan,2)
        ch_tmp = timeseries(d.vlt_chan(:,i_ch),d.TimeStamps);  
        ch_tmp = idealfilter(ch_tmp,[0 2000],'pass');
        ch_LFP(:,i_ch) = ch_tmp.data;
    end



        laser_data.powers{i_trial} = NaN(length(laser_data.onset_inds{i_trial}),1);
        for ij = 1:length(laser_data.onset_inds{i_trial})
            laser_data.powers{i_trial}(ij) = mean(d.aux_chan(laser_data.onset_inds{i_trial}(ij):laser_data.offset_inds{i_trial}(ij),laser_chan));
            if laser_data.offset_inds{i_trial}(ij) <= laser_data.onset_inds{i_trial}(ij)
                error('offset does not follow onset')
            end
            window = laser_data.onset_inds{i_trial}(ij) + window_range;
            if min(window) > 0 && max(window) < size(ch_LFP,1)
                tmp_vlt = ch_LFP(window,:)';
                cur_vlt = squeeze(laser_data.raw_vlt(i_trial,:,:));
                laser_data.raw_vlt(i_trial,:,:) = cur_vlt + tmp_vlt/length(laser_data.onset_inds{i_trial});
            end
        end
        if ~isempty(laser_data.powers{i_trial})
            laser_data.max_power(i_trial) = max(laser_data.powers{i_trial});
        end
        
        disp(['--------------------------------------------']);
    end

    save(f_name_laser_power,'laser_data');
end
disp(['--------------------------------------------']);



