function [trial_data scim_data_names] = parse_behaviour2im(trial_data_raw,cur_trial_num,scim_frame_trig)


scim_data_names = {'trialNumber','trialId','ITItrig','testPeriod', ...
    'xVelocity','yVelocity','ballSpeed','time','xPosition','yPosition', 'fraction', ...
    'corridorPosition','corridorWidth','lickState','waterOn', ...
    'scimFileNum','scimFrameNum'};

    scim_frames = find(scim_frame_trig);
    tmp_mat = zeros(numel(scim_data_names),length(scim_frames),'single');
    tmp_mat(1,:) = trial_data_raw.processed_matrix(8,scim_frames); % trial_number
    tmp_mat(2,:) = trial_data_raw.trial_matrix(8,scim_frames); % trial_id
    tmp_mat(3,:) = trial_data_raw.trial_matrix(9,scim_frames); % inter_trial_trig
    tmp_mat(4,:) = trial_data_raw.trial_matrix(17,scim_frames); % test_period
    tmp = 500*smooth(trial_data_raw.trial_matrix(1,:),50); % x_velocity
    tmp_mat(5,:) = tmp(scim_frames);
    tmp = 500*smooth(trial_data_raw.trial_matrix(2,:),50); % y_velocity
    tmp_mat(6,:) = tmp(scim_frames);
    tmp_mat(7,:) = sqrt(tmp_mat(5,:).^2+tmp_mat(6,:).^2); % speed
    tmp_mat(8,:) = trial_data_raw.trial_matrix(10,scim_frames); % time
    tmp_mat(9,:) = trial_data_raw.processed_matrix(1,scim_frames); % x_position
    tmp_mat(10,:) = trial_data_raw.processed_matrix(2,scim_frames); % y_position
    tmp_mat(11,:) = trial_data_raw.processed_matrix(4,scim_frames); % fraction
    tmp = medfilt1(trial_data_raw.trial_matrix(3,:),50); % cor_pos
    tmp_mat(12,:) = tmp(scim_frames);
    tmp = smooth(trial_data_raw.trial_matrix(4,:),50); % cor_width
    tmp_mat(13,:) = tmp(scim_frames);
    tmp = smooth(trial_data_raw.trial_matrix(10,:),50); % lick_state
    tmp_mat(14,:) = tmp(scim_frames);
    tmp = smooth(trial_data_raw.trial_matrix(11,:),50); % valve_open
    tmp_mat(15,:) = tmp(scim_frames);
    tmp_mat(16,:) = repmat(cur_trial_num,1,length(scim_frames)); % scim_file_num
    tmp_mat(17,:) = 1:length(scim_frames); % scim_frame_num
    
	trial_data = tmp_mat';

end