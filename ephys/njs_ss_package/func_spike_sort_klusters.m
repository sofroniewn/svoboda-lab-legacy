function [ch_data] = func_spike_sort_klusters(base_dir, file_list, cluster_name, ch_common_noise, ch_spikes, over_write, over_write_spikes, over_write_cluster)
%%
disp(['--------------------------------------------']);
lite = 1;
ch_data = [];
total_inds = 0;
f_name_cluster = fullfile(base_dir,'ephys','sorted',cluster_name);

if over_write_cluster == 0 && exist([f_name_cluster '.mat']) == 2
    disp(['LOAD KLUSTERS FILE']);
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
        
        disp(['PREPARE KLUSTERS FILE']);
        [ch_data] = func_parse_klusters(ch_data,i_trial,s,p,d.TimeStamps,total_inds);
        total_inds = total_inds + length(d.TimeStamps);
        disp(['--------------------------------------------']);
    end
    
    disp(['SAVE KLUSTERS FILE']);

    %fid = fopen([f_name_cluster '.spk' '.1'],'w');
    %fwrite(fid,ch_data.spk,'int16');
    %fclose(fid);
    
    fid = fopen([f_name_cluster '.fet' '.1'],'w');
    fprintf(fid,['%i\n'],size(ch_data.fet,2));
    fmt = repmat('%i ',1,size(ch_data.fet,2)-1);
    fprintf(fid,[fmt '%i\n'],ch_data.fet);
    fclose(fid);

    %fid = fopen([f_name_cluster '.res' '.1'],'w');
    %fprintf(fid,'%i\n',ch_data.res);
    %fclose(fid);
    
    %ch_data = ch_data.sync;
    %save([f_name_cluster '.mat'],'ch_data');

end
disp(['--------------------------------------------']);





