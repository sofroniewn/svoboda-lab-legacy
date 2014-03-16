function [ch_data] = func_spike_sort(base_dir, file_list, cluster_name, ch_common_noise, ch_spikes, over_write, over_write_spikes, over_write_cluster)
%%
disp(['--------------------------------------------']);
lite = 1;
ch_data = [];
f_name_cluster = fullfile(base_dir,'ephys','sorted',cluster_name);

if over_write_cluster == 0 && exist(f_name_cluster) == 2
    disp(['LOAD MATCLUST FILE']);
    load(f_name_cluster);
else
    if exist(fullfile(base_dir,'ephys','processed'))~=7
        mkdir(fullfile(base_dir,'ephys','processed'));
    end
    if exist(fullfile(base_dir,'ephys','sorted'))~=7
        mkdir(fullfile(base_dir,'ephys','sorted'));
    end
    
    for i_trial = 1:numel(file_list)
        disp(file_list{i_trial}); 
        f_name = fullfile(base_dir,'ephys','raw',file_list{i_trial});
        f_name_processed_vlt = fullfile(base_dir,'ephys','processed',[file_list{i_trial}(1:end-4) '_processed_vlt.mat']);
        f_name_spikes = fullfile(base_dir,'ephys','processed',[file_list{i_trial}(1:end-4) '_spikes.mat']);
        
        disp(['PROCESS RAW VOLTAGES']);
        if over_write == 0 && exist(f_name_processed_vlt) == 2
            load(f_name_processed_vlt);
        else
            [p d] = func_process_voltage(f_name,ch_common_noise);
            save(f_name_processed_vlt,'p','d');
        end
        
        disp(['EXTRACT SPIKES']);
        if over_write_spikes == 0 && exist(f_name_spikes) == 2
            load(f_name_spikes);
        else
            [s] = func_extract_spikes(p,d,ch_spikes);
            save(f_name_spikes,'s');
        end
        
        disp(['PREPARE MATCLUST FILE']);
        [ch_data] = func_parse_matclust(ch_data,i_trial,s,d.TimeStamps);
        
        disp(['--------------------------------------------']);
    end
    
    [COEFF,SCORE]   = princomp(ch_data.customvar.waveform(:,20-10:20+20));
    spike_PCA = SCORE(:,1:6);
    ch_data.params = cat(2, ch_data.params, spike_PCA); 
    disp(['SAVE MATCLUST FILE']);
    % add labels
    for i_tmp = 1:size(s.spike_amp,2)
        ch_data.paramnames = cat(1, ch_data.paramnames, ['Amp#',num2str(i_tmp)]);
    end
%     for i_tmp = 1:size(s.spike_width,2)
%         ch_data.paramnames = cat(1, ch_data.paramnames, ['Width#',num2str(i_tmp)]);
%     end
    for i_tmp = 1:size(spike_PCA,2)
        ch_data.paramnames = cat(1, ch_data.paramnames, ['PCA#',num2str(i_tmp)]);
    end
    save(f_name_cluster,'ch_data','file_list');
end
disp(['--------------------------------------------']);



