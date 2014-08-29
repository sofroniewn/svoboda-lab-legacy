function wl = func_ff_extract_whiskers(base_dir,WTLA_name,p,overwrite)

%%
disp(['--------------------------------------------']);
disp(['GENERATE WV ARRAYS']);

save_path = fullfile(base_dir, WTLA_name);

if ~overwrite && exist(save_path) == 2
    disp(['LOAD WV ARRAYS']);
    load(save_path)
else
    
    files = dir(fullfile(base_dir,'*.mp4'));
    num_files = numel(files);
    
    wl.trials = cell(num_files,1);
    for ij = 1:num_files
        fprintf('(whiskers) %d of %d \n',ij,num_files);

        [PATHSTR,NAME,EXT] = fileparts(files(ij).name);
        fname_wl = fullfile(base_dir,[NAME '_ff_wl.mat']);
        if exist(fname_wl) == 2 && ~overwrite
            load(fname_wl);
        else
            fname_measurements = fullfile(base_dir,[NAME '.measurements']);
            if exist(fname_wl) == 2
                M = Whisker.read_whisker_measurements(fname_measurements);
            else
                M = [];
            end        
            wl_trial = func_ff_whisker_process(M,p);
            save(fname_wl,'wl_trial');
        end
        wl.trials{ij} = wl_trial;
    end
    save(save_path,'wl');
    fprintf('ARRAYS GENERATED\n');
end