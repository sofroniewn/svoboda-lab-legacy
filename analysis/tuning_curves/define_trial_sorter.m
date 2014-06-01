function [regressor_obj] = define_trial_sorter(stim_type_name)


global session_bv
switch stim_type_name
	case 'speed'
		regressor_obj.timeseries_tune = session_bv.data_mat(22,:);
		regressor_obj.y_label = 'Speed (cm/s)';
		regressor_obj.y_range = [0 max(round(session_bv.trial_info.mean_speed/5)*5)];
	case 'corPos'
		regressor_obj.timeseries_tune = session_bv.data_mat(22,:);
		regressor_obj.y_label = 'Wall distance (mm)';
		regressor_obj.y_range = [0 30];
		%regressor_obj.order = session_bv.trial_config.processed_dat.vals.trial_ol_vals(session_bv.trial_info.inds,2);
		%regressor_obj.bin_vals = session_bv.trial_config.processed_dat.vals.trial_ol_vals(~session_bv.trial_config.processed_dat.vals.trial_type); 
	otherwise
		error('Unrecognized stim type for spark regression')
end


regressor_obj.timeseries_trial_num = session_bv.data_mat(25,:);
regressor_obj.timeseries_x_axis = session_bv.data_mat(21,:);

regressor_obj.var_name = stim_type_name;
regressor_obj.x_label = 'Frac';
regressor_obj.x_range = [0 1];
