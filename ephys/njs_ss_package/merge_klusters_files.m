function merge_klusters_files(batch_mode,i_batch)


disp(['--------------------------------------------']);
disp(['START BATCH ' num2str(i_batch)]);

base_dir = batch_mode{i_batch}.base_dir{1};
file_nums_all = batch_mode{i_batch}.file_nums;
base_cluster_name = batch_mode{i_batch}.cluster_name;

for i_dir = 1:numel(file_nums_all)
    disp(['--------------------------------------------']);
    disp(['MERGE SPLIT ' num2str(i_dir)]);

        cluster_name = [base_cluster_name '_' num2str(i_dir)];
    
    if i_dir == 1
        cluster_name_concat = [base_cluster_name '_concat'];
        f_name_cluster_concat = fullfile(base_dir,'ephys','sorted',cluster_name_concat,cluster_name_concat);
        fid_clu_concat = fopen([f_name_cluster_concat '.clu' '.1'],'w');
    end
    
    
    f_name_clu = fullfile(base_dir,'ephys','sorted',cluster_name,[cluster_name '.clu.1']);
    cluster_ids = dlmread(f_name_clu);
    if i_dir > 1
        cluster_ids(1) = [];
    end
    fprintf(fid_clu_concat,'%i\n',cluster_ids);
end

fclose(fid_clu_concat);
disp(['--------------------------------------------']);
disp(['DONE BATCH ' num2str(i_batch)]);
disp(['--------------------------------------------']);
