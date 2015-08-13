function merge_ephys_behaviour_python(all_anm_id,local_save_path)

if exist(local_save_path) ~= 7
    mkdir(local_save_path);
end

for ih =  1:numel(all_anm_id)
    anm_id = all_anm_id{ih}
    
    [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
    run_thresh = anm_params.run_thresh;
    trial_range_start = anm_params.trial_range_start;
    trial_range_end = anm_params.trial_range_end;
    cell_reject = anm_params.cell_reject;
    exp_type = anm_params.exp_type;
    layer_4 = anm_params.layer_4;
    boundaries = anm_params.boundaries;
    boundary_labels = anm_params.boundary_labels;
    
    % Load in behaviour data
    base_path_behaviour = fullfile(base_dir, 'behaviour');
    
    session = load_session_data(base_path_behaviour);
    session = parse_session_data(1,session);
    
    d_all = concat_behaviour_params(session);
    
    d_all.anm_params = anm_params;
    
    s = [];
    s.corPos = d_all.cor_pos;
    s.corVel = d_all.Wall_velocity;
    s.corWidth = d_all.cor_width;
    s.laserPower = d_all.laser_power;
    s.trialNum = d_all.Trial_number-1;
    s.itiPeriod = d_all.inter_trial_trig;
    s.trialWater = (d_all.external_water | d_all.water_earned);
    s.samplePeriod = d_all.test_val;
    s.trialTime = d_all.Time;
    s.trialFrac = d_all.Frac;
    s.speed = d_all.Speed;
    s.xSpeed = d_all.x_vel*500;
    s.ySpeed = d_all.y_vel*500;
    s.trialId = d_all.trial_num-1;
    trialStr = session.trial_config.dat(:,1);
   % s.trialId = trial_str(s.trialId);
    if ~exist(fullfile(local_save_path,['Anm_0' anm_id]))
        mkdir(fullfile(local_save_path,['Anm_0' anm_id]))
    end
    
    namesData = fieldnames(s);
    dataMat = zeros(length(s.corPos),numel(namesData));
    for ij = 1:numel(namesData)
        dataMat(:,ij) = s.(namesData{ij});
    end
    save(fullfile(local_save_path,['Anm_0' anm_id],'covariates.mat'),'dataMat','trialStr','namesData');
    %save(fullfile(local_save_path,anm_id,'covariates.mat'),'s');
end
