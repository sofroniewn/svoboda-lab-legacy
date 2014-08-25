function wl = func_ff_extract_whiskers(base_dir,WTLA_name,p,overwrite)

%%
disp(['--------------------------------------------']);
disp(['GENERATE WV ARRAYS']);

save_path = fullfile(base_dir, WTLA_name);

if overwrite ~= 1 && exist(save_path) == 2
    disp(['LOAD WV ARRAYS']);
    load(save_path)
else
    
    files = dir(fullfile(base_dir,'*.measurements'));
    num_files = numel(files);
    
    wl.trials = cell(num_files,1);
    for ij = 1:num_files
        fprintf('(whiskers) %d of %d \n',ij,num_files);
        fname = fullfile(base_dir,files(ij).name);
        M = Whisker.read_whisker_measurements(fname);
        wl_trial = func_ff_whisker_process(M,p);
        wl.trials{ij} = wl_trial;
    end
    
    save(save_path,'wl');
    
    fprintf('ARRAYS GENERATED\n');
end