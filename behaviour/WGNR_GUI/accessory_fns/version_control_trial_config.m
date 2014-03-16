function version_control_trial_config(fname)

load(fname);

if isempty(trial_config.version) == 1 && isempty(trial_config.dat) ~= 1
    %save([fname(1:end-4) '_OLD.mat'],'trial_config');
    % CURRENT UPDATE - add water drop size column, split max and min pos of corridor, and make water
    % delievery at one fraction position.
    column_names = cell(36,1);
    column_names(1:20) = trial_config.column_names(1:20);
    column_names(23:36) = trial_config.column_names(21:34);
    column_names{19} = 'Water trial position';
    column_names{20} = 'Water corridor min (mm)';
    column_names{21} = 'Water corridor max (mm)';
    column_names{22} = 'Water drop size (ms)';
    
    dat = cell(size(trial_config.dat,1),36);
    dat(:,1:20) = trial_config.dat(:,1:20);
    dat(:,23:36) = trial_config.dat(:,21:34);
    for ij = 1:size(dat,1)
        dat{ij,22} = '{100}';
        water_onset = trial_config.processed_dat.vals.trial_water_pos(ij,1);
        dat{ij,19} = ['{' num2str(water_onset) '}'];
        min_pos = trial_config.processed_dat.vals.trial_water_range(ij,1);
        dat{ij,20} = ['{' num2str(min_pos) '}'];
        max_pos = trial_config.processed_dat.vals.trial_water_range(ij,2);
        dat{ij,21} = ['{' num2str(max_pos) '}'];
    end
    trial_config.column_names = column_names;
    trial_config.dat = dat;
    
    trial_config.processed_dat = [];
    trial_config.version = 0;
else
    trial_config = trial_config;
end

if trial_config.version == 0 && isempty(trial_config.dat) ~= 1
    %save([fname(1:end-4) '_OLD.mat'],'trial_config');
    % CURRENT UPDATE - add water drop size column, split max and min pos of corridor, and make water
    % delievery at one fraction position.
    column_names = cell(37,1);
    column_names(1:21) = trial_config.column_names(1:21);
    column_names(23:37) = trial_config.column_names(22:36);
    column_names{20} = 'Water corridor min';
    column_names{21} = 'Water corridor max';
    column_names{22} = 'Water range';
    
    dat = cell(size(trial_config.dat,1),37);
    dat(:,1:21) = trial_config.dat(:,1:21);
    dat(:,23:37) = trial_config.dat(:,22:36);
    for ij = 1:size(dat,1)
        dat{ij,22} = 'Wall distance (mm)';
    end
    trial_config.column_names = column_names;
    trial_config.dat = dat;
    
    trial_config.processed_dat = [];
    trial_config.version = 1;
else
    trial_config = trial_config;
end

if trial_config.version == 1 && isempty(trial_config.dat) ~= 1
    %save([fname(1:end-4) '_OLD.mat'],'trial_config');
    % CURRENT UPDATE - add handles.trial_config.repeating_numbers (should be same as handles.trial_config.repeating_order).
    if isempty(trial_config.repeating_order) == 1
        trial_config.repeating_numbers = '';
    else
         tmp_str = '{';
         for ij = 1:trial_config.processed_dat.vals.trial_num_sequence
            tmp_str = [tmp_str ' 1,'];
         end
         tmp_str(end) = [];
         tmp_str = [tmp_str '}'];
         trial_config.repeating_numbers = tmp_str;
    end
    trial_config.version = 2;
else
    trial_config = trial_config;
end

if trial_config.version == 2 && isempty(trial_config.dat) ~= 1
    %save([fname(1:end-4) '_OLD.mat'],'trial_config');
    % CURRENT UPDATE - make all ps_dur = 2ms.    
    for ij = 1:size(trial_config.dat,1)
        trial_config.dat{ij,32} = 2;
    end
    trial_config = trial_dat_parser(trial_config);
    trial_config.version = 3;
    save(fname,'trial_config');
else
    trial_config = trial_config;
end

end