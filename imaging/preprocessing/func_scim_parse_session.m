function [d] = func_scim_parse_session(session,p)
%%
disp(['--------------------------------------------']);
disp(['GENERATE SCIM PARSED SESSION']);

num_files = numel(session.data);

scim_data_names = {'trial_number','trial_id','inter_trial_trig','test_period', ...
    'x_velocity','y_velocity','speed','time','x_position','y_position', 'fraction', ...
    'cor_pos','cor_width','lick_state','valve_open', ...
    'scim_file_num','scim_frame_num'};

scim_data = [];
for ij = 1:num_files-1;
    fprintf('(scim_parse_session) loading file %g/%g \n',ij,num_files-1);
    scim_frames = find(session.data{ij}.processed_matrix(7,:));
    tmp_mat = zeros(numel(scim_data_names),length(scim_frames));
    tmp_mat(1,:) = session.data{ij}.processed_matrix(8,scim_frames); % trial_number
    tmp_mat(2,:) = session.data{ij}.trial_matrix(8,scim_frames); % trial_id
    tmp_mat(3,:) = session.data{ij}.trial_matrix(9,scim_frames); % inter_trial_trig
    tmp_mat(4,:) = session.data{ij}.trial_matrix(17,scim_frames); % test_period
    tmp = 500*smooth(session.data{ij}.trial_matrix(1,:),50); % x_velocity
    tmp_mat(5,:) = tmp(scim_frames);
    tmp = 500*smooth(session.data{ij}.trial_matrix(2,:),50); % y_velocity
    tmp_mat(6,:) = tmp(scim_frames);
    tmp_mat(7,:) = sqrt(tmp_mat(5,:).^2+tmp_mat(6,:).^2); % speed
    tmp_mat(8,:) = session.data{ij}.trial_matrix(10,scim_frames); % time
    tmp_mat(9,:) = session.data{ij}.processed_matrix(1,scim_frames); % x_position
    tmp_mat(10,:) = session.data{ij}.processed_matrix(2,scim_frames); % y_position
    tmp_mat(11,:) = session.data{ij}.processed_matrix(4,scim_frames); % fraction
    tmp = medfilt1(session.data{ij}.trial_matrix(3,:),50); % cor_pos
    tmp_mat(12,:) = tmp(scim_frames);
    tmp = smooth(session.data{ij}.trial_matrix(4,:),50); % cor_width
    tmp_mat(13,:) = tmp(scim_frames);
    tmp = smooth(session.data{ij}.trial_matrix(10,:),50); % lick_state
    tmp_mat(14,:) = tmp(scim_frames);
    tmp = smooth(session.data{ij}.trial_matrix(11,:),50); % valve_open
    tmp_mat(15,:) = tmp(scim_frames);
    tmp_mat(16,:) = repmat(ij,1,length(scim_frames)); % scim_file_num
    tmp_mat(17,:) = 1:length(scim_frames); % scim_frame_num
    scim_data = [scim_data tmp_mat];
    trial_data.forward_distance(ij) = session.trial_info.forward_distance(ij);
    trial_data.frac(ij) = session.trial_info.frac(ij);
    trial_data.completed(ij) = session.trial_info.completed(ij);
end

d.scim_files = p.scim_files;
d.scim_info = p.im_props;
d.scim_data_names = scim_data_names;
d.scim_data = scim_data;
d.trial_data = trial_data;

disp(['--------------------------------------------']);

