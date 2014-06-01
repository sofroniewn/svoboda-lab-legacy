function [regMat regVect regressor_obj split_var keep_obj] = get_full_regression_vars(stim_type_name,keep_type_name,trial_range)


[keep_trials keep_vars split_var] = define_keep_trials(keep_type_name,trial_range);
[regressor_obj] = define_trial_sorter(stim_type_name);

num_samples = 800;
keep_obj.traj = cell(split_var.num_groups,1);

for ik = 1:split_var.num_groups
group_trials = split_var.trial_num(split_var.vect == split_var.bins(ik) & keep_trials');

num_trials = length(group_trials);
if 	num_trials > 0
		keep_obj.traj{ik} = NaN(num_trials,num_samples);
		for ij = 1:num_trials
		traj_time = regressor_obj.timeseries_tune(regressor_obj.timeseries_trial_num == group_trials(ij));
		frac = regressor_obj.timeseries_x_axis(regressor_obj.timeseries_trial_num == group_trials(ij));
		figure; plot(frac,traj_time)
		ind = ceil(frac*800);
    	ind(ind<=0) = 1;
    	ind(ind>800) = 800;
		keep_obj.traj{ik}(ij,ind) = traj_time;
		end
	end
end



figure
hold on
plot(session_bv.data_mat)