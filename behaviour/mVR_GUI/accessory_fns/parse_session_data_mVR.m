function session = parse_session_data_mVR(start_trial,opt_session)

if isempty(opt_session) == 1
    global session
else
    session = opt_session;
end
processed_matrix_names = {'Time','X_position','Y_position','Frac','Speed','Scim_trigs','Scim_frames','Trial_number','Wall_velocity'};

num_trials = numel(session.data);
if start_trial == 1
    session.trial_info.maze_id = zeros(num_trials,1);
    session.trial_info.correct = zeros(num_trials,1);
    session.trial_info.timeout = zeros(num_trials,1);
    session.trial_info.rewarded = zeros(num_trials,1);
    session.trial_info.dead_end_left = zeros(num_trials,1);
    session.trial_info.dead_end_right = zeros(num_trials,1);



    % session.trial_info.trial_num = zeros(num_trials,1);
    % session.trial_info.inds = zeros(num_trials,1);
    % session.trial_info.time = zeros(num_trials,1);
    % session.trial_info.length = zeros(num_trials,1);
 
    % session.trial_info.forward_distance = zeros(num_trials,1);
    % session.trial_info.lateral_distance = zeros(num_trials,1);
    % session.trial_info.frac = zeros(num_trials,1);
    % session.trial_info.completed = zeros(num_trials,1);
    % session.trial_info.rewarded = zeros(num_trials,1);
    % session.trial_info.trial_start = zeros(num_trials,1);
    % session.trial_info.scim_num_trigs = zeros(num_trials,1);
    % session.trial_info.scim_cum_trigs = zeros(num_trials,1);
    % session.trial_info.scim_logging = zeros(num_trials,1);
    % session.trial_info.scim_num_frames = zeros(num_trials,1);
    % session.trial_info.firstFrameNumberRelTrigger = zeros(num_trials,1);
    % session.trial_info.max_laser_power = zeros(num_trials,1);
    % session.trial_info.mean_speed = zeros(num_trials,1);

end

for ij = start_trial:num_trials
    session.trial_info.maze_id(ij) = session.data{ij}.trial_matrix(13,1); 
    session.trial_info.rewarded(ij) = any(session.data{ij}.trial_matrix(11,:));
    session.trial_info.dead_end_left(ij) = any(session.data{ij}.trial_matrix(9,:));
    session.trial_info.dead_end_right(ij) = any(session.data{ij}.trial_matrix(8,:));    
    session.trial_info.timeout(ij) = ~session.trial_info.rewarded(ij) && ~(session.trial_info.dead_end_left(ij) || session.trial_info.dead_end_right(ij));
    if  session.trial_info.rewarded(ij)
        ind_c = find(session.data{ij}.trial_matrix(11,:),1,'first');
        session.trial_info.correct(ij) = ~any(session.data{ij}.trial_matrix(8,1:ind_c)) && ~any(session.data{ij}.trial_matrix(9,1:ind_c));
    else
        session.trial_info.correct(ij) = 0;
    end


    % session.trial_info.inds(ij) = mode(session.data{ij}.trial_matrix(8,:));  % trial index number
    % session.trial_info.trial_start(ij) = find(session.data{ij}.trial_matrix(9,:)==0,1,'first'); % fraction of trial completed
    % session.trial_info.rewarded(ij) = any(session.data{ij}.trial_matrix(11,:)); % if any water reward earned that trial 
    % session.trial_info.max_laser_power(ij) = round(10*max(session.data{ij}.trial_matrix(5,:)))/10;
    % session.trial_info.length(ij) = size(session.data{ij}.trial_matrix,2);

    % session.data{ij}.processed_matrix = zeros(numel(processed_matrix_names),size(session.data{ij}.trial_matrix,2));
    % session.data{ij}.processed_matrix(1,:) = [1:size(session.data{ij}.trial_matrix,2)]/session.rig_config.sample_freq;
    % session.data{ij}.processed_matrix(2,:) = cumsum(session.data{ij}.trial_matrix(1,:));
    % session.data{ij}.processed_matrix(3,:) = cumsum(session.data{ij}.trial_matrix(2,:));
    % session.data{ij}.processed_matrix(1,:) = session.data{ij}.processed_matrix(1,:) - session.data{ij}.processed_matrix(1,session.trial_info.trial_start(ij));
    % session.data{ij}.processed_matrix(2,:) = session.data{ij}.processed_matrix(2,:) - session.data{ij}.processed_matrix(2,session.trial_info.trial_start(ij));
    % session.data{ij}.processed_matrix(3,:) = session.data{ij}.processed_matrix(3,:) - session.data{ij}.processed_matrix(3,session.trial_info.trial_start(ij));

    % session.data{ij}.processed_matrix(9,:) = smooth(session.data{ij}.trial_matrix(3,:),25,'sgolay',1);
    % session.data{ij}.processed_matrix(9,:) = session.rig_config.sample_freq*[0 diff(session.data{ij}.processed_matrix(9,:))];

    % if session.trial_config.processed_dat.vals.trial_type(session.trial_info.inds(ij)) == 1 % Distance trial
    %     session.data{ij}.processed_matrix(4,:) = session.data{ij}.processed_matrix(2,:)/session.trial_config.processed_dat.vals.trial_dur(session.trial_info.inds(ij));
    % else % Time trial
    %     session.data{ij}.processed_matrix(4,:) = session.data{ij}.processed_matrix(1,:)/session.trial_config.processed_dat.vals.trial_timeout(session.trial_info.inds(ij));
    % end
    % session.data{ij}.processed_matrix(5,:) = session.rig_config.sample_freq*sqrt(session.data{ij}.trial_matrix(1,:).^2 + session.data{ij}.trial_matrix(2,:).^2);
    % session.data{ij}.processed_matrix(5,:) = conv(session.data{ij}.processed_matrix(5,:),ones(1,250)/250,'same');
    % session.trial_info.mean_speed(ij) = mean(session.data{ij}.processed_matrix(5,:));


    % scim_trig_inds = find(diff(session.data{ij}.trial_matrix(14,:))==1)+1;
    % session.data{ij}.processed_matrix(6,scim_trig_inds) = 1;
    % if ij > 1
    %     if session.data{ij}.trial_matrix(14,1)== 1 && session.data{ij-1}.trial_matrix(14,end)== 0
    %         session.data{ij}.processed_matrix(6,1) = 1;
    %     end
    % end
    % %session.data{ij}.processed_matrix(7,:) = session.data{ij}.processed_matrix(6,:);
    % session.data{ij}.processed_matrix(8,:) = ij;
    
    % session.trial_info.scim_num_trigs(ij) = length(find(session.data{ij}.processed_matrix(6,:)));
    % session.trial_info.scim_logging(ij) = min(session.data{ij}.trial_matrix(16,:));
    
    % if ij > 1 && session.trial_info.scim_logging(ij-1) == 1;
    %     session.trial_info.scim_cum_trigs(ij) = session.trial_info.scim_cum_trigs(ij-1) + session.trial_info.scim_num_trigs(ij-1);
    % else
    %     session.trial_info.scim_cum_trigs(ij) = 0;
    % end
    
    
    % session.trial_info.trial_num(ij) = ij;
    % session.trial_info.time(ij) = session.data{ij}.processed_matrix(1,end); % trial time
    % session.trial_info.forward_distance(ij) = session.data{ij}.processed_matrix(2,end); % forward distance
    % session.trial_info.lateral_distance(ij) = session.data{ij}.processed_matrix(3,end); % forward distance
    % session.trial_info.frac(ij) = session.data{ij}.processed_matrix(4,end); % fraction of trial completed
    
    % session.trial_info.completed(ij) = session.trial_info.frac(ij)>.95; % if more than 95% of trial completed
    
    % session.data{ij}.processed_matrix_names = processed_matrix_names;
end