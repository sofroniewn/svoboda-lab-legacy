function extracted_times = extract_time_windows_session(session_bv,trigs,trial_ind,x_vars,t_window_inds,trial_range)

extracted_times = []; %trial_id start ind then stop ind relative to first ind in behaviour, start time stop time in Ca imaging, then group number.
total_num_inds = size(session_bv.data_mat,2);
for group_num = 1:size(x_vars,2)
        data_mat = false(size(x_vars,1),total_num_inds);
        start_ind = 1;
        for ij = 1:size(x_vars,1)
            x_var = eval(x_vars{ij,group_num}.str);
            data_mat(ij,:) = x_vars{ij,group_num}.range(1) <= x_var & x_var < x_vars{ij,group_num}.range(2);
        end
        data_mat = all(data_mat,1);
        while start_ind <= total_num_inds
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
                    if stop_ind <= total_num_inds
                        phys_start_time = find(trigs(start_ind:end),1,'first');
                        if ~isempty(phys_start_time)
                            phys_start_time = trigs(start_ind+phys_start_time-1);
                        else
                            phys_start_time = NaN;
                        end
                        phys_stop_time = find(trigs(1:stop_ind),1,'last');
                        if ~isempty(phys_stop_time)
                            phys_stop_time = trigs(phys_stop_time);
                        else
                            phys_stop_time = NaN;
                        end
                        trial_id = mode(session_bv.data_mat(trial_ind,start_ind:stop_ind));
                        extracted_times = [extracted_times;trial_id start_ind stop_ind phys_start_time phys_stop_time group_num];      
                    end
                end
                start_ind = stop_ind + 1;
            else
                start_ind = total_num_inds + 1;
            end
        end
end

% remove any intervals where lack complete spiking data
extracted_times(isnan(extracted_times(:,4)),:) = [];
extracted_times(isnan(extracted_times(:,5)),:) = [];

extracted_times(extracted_times(:,1) < trial_range(1),:) = [];
extracted_times(extracted_times(:,1) > trial_range(2),:) = [];
