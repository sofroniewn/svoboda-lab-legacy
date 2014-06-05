function [extracted_times max_time] = extract_time_windows(session,x_vars,t_window_inds,trial_range)

extracted_times = []; % first column trial id, then start ind then stop ind relative to first ind.
for group_num = 1:size(x_vars,2)
    for trial_id = 1:numel(session.data)
        data_mat = false(size(x_vars,1),session.trial_info.length(trial_id));
        start_ind = 1;
        for ij = 1:size(x_vars,1)
            x_var = eval(x_vars{ij,group_num}.str);
            data_mat(ij,:) = x_vars{ij,group_num}.range(1) <= x_var & x_var < x_vars{ij,group_num}.range(2);
        end
        data_mat = all(data_mat,1);
        while start_ind <= length(data_mat)
            next_non_zero_ind = find(data_mat(start_ind:end),1,'first');
            if isempty(next_non_zero_ind) ~= 1
                start_ind = start_ind+next_non_zero_ind-1;
                next_zero_ind = find(~data_mat(start_ind:end),1,'first');
                if isempty(next_zero_ind)
                    next_zero_ind = length(data_mat);
                end
                stop_ind = start_ind+next_zero_ind-1;
                if  start_ind + t_window_inds <= stop_ind
                    stop_ind = start_ind + t_window_inds;
                    ephys_start_time = session.data{trial_id}.processed_matrix(7,start_ind);
                    ephys_stop_time = session.data{trial_id}.processed_matrix(7,stop_ind);
                    extracted_times = [extracted_times;trial_id start_ind stop_ind ephys_start_time ephys_stop_time group_num];      
                end
                start_ind = stop_ind + 1;
            else
                start_ind = length(data_mat) + 1;
            end
        end
    end
end
% remove any intervals where lack complete spiking data
extracted_times(isnan(extracted_times(:,4)),:) = [];
extracted_times(isnan(extracted_times(:,5)),:) = [];


extracted_times(~ismember(extracted_times(:,1),trial_range),:) = [];



% Set max time
max_time = t_window_inds/session.rig_config.sample_freq;
