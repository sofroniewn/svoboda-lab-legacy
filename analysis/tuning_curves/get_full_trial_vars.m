function trial_raster = get_full_trial_vars(stim_type_name,keep_type_name,trial_range,respones_vect)

[keep_trials keep_vars split_var] = define_keep_trials(keep_type_name,trial_range);
[regressor_obj] = define_trial_sorter(stim_type_name);



num_samples = 80;
trial_raster_obj.traj = cell(split_var.num_groups,1);
for ik = 1:split_var.num_groups
	group_trials = split_var.trial_num(split_var.vect == split_var.bins(ik) & keep_trials');
	num_trials = length(group_trials);
	if 	num_trials > 0
		trial_raster.traj{ik} = NaN(num_trials,num_samples);
		trial_raster.response{ik} = NaN(num_trials,num_samples);
		
		if strcmp(split_var.name,'running')
			[val Idx] = sort(regressor_obj.trial_order(group_trials),'descend');
		end

		for ij = 1:num_trials
			if strcmp(split_var.name,'running')
				cur_trial_num = group_trials(Idx(ij));
			else
				cur_trial_num = group_trials(ij);
			end
			traj_time = regressor_obj.timeseries_tune(regressor_obj.timeseries_trial_num == cur_trial_num);
			frac = regressor_obj.timeseries_x_axis(regressor_obj.timeseries_trial_num == cur_trial_num);
			frames_time = regressor_obj.timeseries_frames(regressor_obj.timeseries_trial_num == cur_trial_num);
            response_time = respones_vect(frames_time(find(frames_time)));
			response_time_upsample = interp1(find(frames_time),response_time,[1:length(frames_time)]);
			ind = ceil(frac*num_samples);
    		traj_time(ind<=0) = [];
    		response_time_upsample(ind<=0) = [];
    		frac(ind<=0) = [];
    		ind(ind<=0) = [];
    		traj_time(ind>num_samples) = [];
    		response_time_upsample(ind>num_samples) = [];
    		frac(ind>num_samples) = [];
    		ind(ind>num_samples) = [];
        	tmp_data = accumarray(ind',traj_time,[],@mean);
			trial_raster.traj{ik}(ij,1:length(tmp_data)) = tmp_data;
        	tmp_data = accumarray(ind',response_time_upsample,[],@mean);
			trial_raster.response{ik}(ij,1:length(tmp_data)) = tmp_data;
		end
	end
end

trial_raster.num_groups = split_var.num_groups;
trial_raster.num_samples = num_samples;
trial_raster.x_label = split_var.x_label;
trial_raster.x_vect = [1:num_samples]/num_samples*split_var.x_max;
trial_raster.y_label = regressor_obj.y_label;
trial_raster.y_range = regressor_obj.y_range;
trial_raster.activity_label = 'Avg dF/F';

