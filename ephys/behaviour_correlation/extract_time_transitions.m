function extracted_times = extract_time_transitions(session,x_vars,transition_vars,t_window_inds)

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
        x_var = eval(transition_vars.str);
        transition_mat = zeros(1,length(data_mat));
        transition_mat(transition_vars.range(1) <= x_var & x_var < transition_vars.range(2)) = 10;
        transition_mat(transition_vars.range(3) <= x_var & x_var < transition_vars.range(4)) = 11;
        d_transition_mat = diff(transition_mat);
        d_transition_mat = data_mat.*[d_transition_mat 0];
        transition_mat = data_mat.*transition_mat;

        while start_ind <= length(data_mat)
            next_non_zero_ind = find(d_transition_mat(start_ind:end) == 1,1,'first');
            if isempty(next_non_zero_ind) ~= 1
                start_ind = start_ind+next_non_zero_ind-1;
                next_transition_ind = find(~transition_mat(start_ind:end) == 11,1,'first');
                if isempty(next_transition_ind)
                    next_transition_ind = length(data_mat);
                end
                prev_transition_ind = find(~transition_mat(1:start_ind) == 10,1,'last');
                if isempty(prev_transition_ind)
                    prev_transition_ind = 1;
                end
                stop_ind = start_ind+next_transition_ind-1;
                if start_ind + t_window_inds(2) <= stop_ind && start_ind + t_window_inds(1) >= prev_transition_ind
                    stop_ind = start_ind + t_window_inds(2);
                    extracted_times = [extracted_times;trial_id (start_ind+t_window_inds(1)) stop_ind 0 0 group_num];      
                end
                start_ind = stop_ind + 1;
            else
                start_ind = length(data_mat) + 1;
            end
        end
    end
end

