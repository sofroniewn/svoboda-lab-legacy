function failed = func_spike_sort_klusters(batch_mode, over_write, over_write_spikes,xml_path)
%%

disp(['--------------------------------------------']);
failed = [];
i_batch = 1;
while i_batch <= numel(batch_mode)
    disp(['START BATCH ' num2str(i_batch)]);
    
   % try
    all_base_dir = batch_mode{i_batch}.base_dir;
    file_nums_all = batch_mode{i_batch}.file_nums;
    base_cluster_name = batch_mode{i_batch}.cluster_name;
    
    ch_common_noise = [1:32];
    ch_spikes = [1:32];
    
    total_inds = 0;
    
    f_name_flag = '*_trial*.bin';
    
    for i_dir = 1:numel(file_nums_all)
        
        if numel(all_base_dir) > 1
            base_dir = all_base_dir{i_dir};
            cluster_name = base_cluster_name;
            new_files = 0;
            dir_num = i_dir;
        else
            dir_num = 1;
            base_dir = all_base_dir{1};
            if numel(file_nums_all) > 1
                cluster_name = [base_cluster_name '_' num2str(i_dir)];
            else
                cluster_name = base_cluster_name;
            end
            new_files = 1;
        end
        
        if new_files && i_dir == 1 && numel(file_nums_all) > 1
             batch_mode{numel(batch_mode)+1} = batch_mode{i_batch};
             batch_mode{numel(batch_mode)}.cluster_name = [batch_mode{i_batch}.cluster_name '_concat'];
             batch_mode{numel(batch_mode)}.file_nums = cell(1,1);
             for ih = 1:numel(file_nums_all)
             %    batch_mode{numel(batch_mode)}.base_dir{ih} = batch_mode{i_batch}.base_dir{1};
                  batch_mode{numel(batch_mode)}.file_nums{1} = [batch_mode{numel(batch_mode)}.file_nums{1}, batch_mode{i_batch}.file_nums{ih}];
             end
         end

        f_name_cluster = fullfile(base_dir,'ephys','sorted',cluster_name,cluster_name);
        
        if exist(fullfile(base_dir,'ephys','processed'))~=7
            mkdir(fullfile(base_dir,'ephys','processed'));
        end
        if exist(fullfile(base_dir,'ephys','sorted',cluster_name))~=7
            mkdir(fullfile(base_dir,'ephys','sorted',cluster_name));
        end

        
        if new_files || i_dir == 1
            if ~isempty(xml_path)
                copyfile(xml_path,[f_name_cluster '.xml']);
            end
            fid_spk = fopen([f_name_cluster '.spk' '.1'],'w');
            fid_fet = fopen([f_name_cluster '.fet' '.1'],'w');
            fid_res = fopen([f_name_cluster '.res' '.1'],'w');
            fid_synch = fopen([f_name_cluster '.sync' '.1'],'w');
            fid_clu = fopen([f_name_cluster '.clu' '.1'],'w');
            
            fid_dat = fopen([f_name_cluster '.dat'],'w');
            fid_fil = fopen([f_name_cluster '.fil'],'w');
        end
        
        
        file_nums = file_nums_all{i_dir};
        file_list = func_list_files(base_dir,f_name_flag,file_nums);
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
            
            if i_trial == 1 && (new_files || i_dir == 1)
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
                [ch_data] = func_parse_klusters(dir_num,file_nums(i_trial),s,p,d.TimeStamps,total_inds);
                
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
        
        if new_files || i_dir == numel(file_nums_all)
            
            fclose(fid_spk);
            fclose(fid_fet);
            fclose(fid_res);
            fclose(fid_synch);
            fclose(fid_fil);
            fclose(fid_dat);
            fclose(fid_clu);
            
            num_pca_features = 6;
            if num_pca_features > 0
                add_pca_features(all_base_dir{1},cluster_name,num_pca_features)
            end
            
        end
        disp(['FILES ' num2str(i_dir) ' SUCCEEDED']);
        disp(['--------------------------------------------']);
        
    end
    disp(['BATCH ' num2str(i_batch) ' SUCCEEDED']);
    disp(['--------------------------------------------']);
   %  catch
   %      disp(['BATCH ' num2str(i_batch) ' FAILED']);
   %      failed = [failed;i_batch]
    %end
    i_batch = i_batch+1;
end

if ~isempty(failed)
    disp(['BATCH ' num2str(failed) ' FAILED']);
else
    disp(['BATCH ' num2str(1:numel(batch_mode)) ' SUCCEEDED']);
end


disp(['--------------------------------------------']);
disp(['--------------------------------------------']);



