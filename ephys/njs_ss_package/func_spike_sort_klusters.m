function file_list = func_spike_sort_klusters(base_dir, f_name_flag,file_nums, cluster_name, over_write, over_write_spikes, over_write_cluster)
%%
disp(['--------------------------------------------']);
file_list = func_list_files(base_dir,f_name_flag,file_nums);

ch_common_noise = [1:32];
ch_spikes = [1:32];
lite = 1;
total_inds = 0;
f_name_cluster = fullfile(base_dir,'ephys','sorted',cluster_name,cluster_name);

if over_write_cluster == 0 && exist([f_name_cluster '.mat']) == 2
    disp(['LOAD KLUSTERS FILE']);
    load(f_name_cluster);
else
    if exist(fullfile(base_dir,'ephys','processed'))~=7
        mkdir(fullfile(base_dir,'ephys','processed'));
    end
    if exist(fullfile(base_dir,'ephys','sorted',cluster_name))~=7
        mkdir(fullfile(base_dir,'ephys','sorted',cluster_name));
    end
    
    fid_spk = fopen([f_name_cluster '.spk' '.1'],'w');
    fid_fet = fopen([f_name_cluster '.fet' '.1'],'w');
    fid_res = fopen([f_name_cluster '.res' '.1'],'w');
    fid_synch = fopen([f_name_cluster '.sync' '.1'],'w');
    fid_clu = fopen([f_name_cluster '.clu' '.1'],'w');
    
    fid_dat = fopen([f_name_cluster '.dat'],'w');
    fid_fil = fopen([f_name_cluster '.fil'],'w');

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
        
        if i_trial == 1
            num_fet = p.ch_ids.num_spike + 1;
            fprintf(fid_fet,['%i\n'],num_fet);
            %dlmwrite([f_name_cluster '.fet' '.1'],num_fet);
            fprintf(fid_clu,['%i\n'],1);
        end
 
    matrixVol = cat(2,d.vlt_chan*p.gain,d.aux_chan(:,1:3));
    matrixFil = cat(2,d.ch_MUA*p.gain,d.aux_chan(:,1:3));

    matrixVol = uint16(2^16*(matrixVol/10 + (matrixVol<0)));
    matrixFil = uint16(2^16*(matrixFil/10 + (matrixFil<0)));

    matrixVol = cat(2,matrixVol,file_nums(i_trial)+ones(length(d.TimeStamps),1),d.aux_chan(:,4:5))';
    matrixFil = cat(2,matrixFil,file_nums(i_trial)+ones(length(d.TimeStamps),1),d.aux_chan(:,4:5))';

    matrixVol = matrixVol(:);
    matrixFil = matrixFil(:);

    fwrite(fid_dat,matrixVol,'uint16');
    fwrite(fid_fil,matrixFil,'uint16');

        n_spk = length(s.index);
        if n_spk > 1
            disp(['PREPARE KLUSTERS FILE']);
            [ch_data] = func_parse_klusters(file_nums(i_trial),s,p,d.TimeStamps,total_inds);

            disp(['SAVE KLUSTERS FILE']);
            fwrite(fid_spk,ch_data.spk,'int16');

            fmt = repmat('%i ',1,size(ch_data.fet,2)-1);
            fprintf(fid_fet,[fmt ' %i\n'],ch_data.fet');
            %dlmwrite([f_name_cluster '.fet' '.1'],ch_data.fet','-append');

            fprintf(fid_clu,'%i\n',zeros(length(ch_data.res),1));

            fprintf(fid_res,'%i\n',ch_data.res);

            fmt = repmat('%i ',1,size(ch_data.sync,2)-1);
            fprintf(fid_synch,[fmt '%i\n'],ch_data.sync');
        end
        total_inds = total_inds + length(d.TimeStamps);
        disp(['--------------------------------------------']);
    end
    
    fclose(fid_spk);
    fclose(fid_fet);
    fclose(fid_res);
    fclose(fid_synch);
    fclose(fid_fil);
    fclose(fid_dat);
    fclose(fid_clu);
end
disp(['--------------------------------------------']);




