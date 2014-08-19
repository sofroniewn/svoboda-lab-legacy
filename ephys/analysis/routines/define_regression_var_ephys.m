function regressor_obj = define_regression_var_ephys(stim_type_name)

switch stim_type_name
	case 'speed'
		regressor_obj.var_tune = 'speed';
		regressor_obj.bin_vals = [0 5 Inf]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Not running / running';
		regressor_obj.x_range = [0 10];
		regressor_obj.x_tick = [];
		regressor_obj.tune_type = '';
		regressor_obj.x_fit_vals = [0 10];
	case 'corPos'
		regressor_obj.var_tune = 'wall_pos';
		regressor_obj.bin_vals = [0:2:30]; 
		regressor_obj.bin_type = 'centers';
		regressor_obj.x_label = 'Wall distance (mm)';
		regressor_obj.x_range = [-1.5 31];
		regressor_obj.x_tick = [0:5:30];
		regressor_obj.tune_type = 'Smooth';
		regressor_obj.x_fit_vals = [0:.5:30];
	case 'laser'
		regressor_obj.var_tune = 'laser';
		regressor_obj.bin_vals = [0 1 2 3 4];
		regressor_obj.bin_type = 'equal';		
		regressor_obj.x_label = 'Laser power (V)';
		regressor_obj.x_range = [0 4];
		regressor_obj.x_tick = [0:4];
		regressor_obj.tune_type = 'Gauss';
		regressor_obj.x_fit_vals = [0:4];
	otherwise
		error('Unrecognized stim type for spark regression')
end

regressor_obj.var_name = stim_type_name;
regressor_obj.y_label = 'Firing rate';

switch regressor_obj.bin_type
	case 'equal'
		regressor_obj.num_groups = length(regressor_obj.bin_vals);
		regressor_obj.x_vals = regressor_obj.bin_vals';
	case 'centers'
		regressor_obj.num_groups = length(regressor_obj.bin_vals);
		regressor_obj.x_vals = regressor_obj.bin_vals';
	case 'edges'
		regressor_obj.num_groups = length(regressor_obj.bin_vals)-1;
		regressor_obj.x_vals = diff(regressor_obj.bin_vals)'/2+regressor_obj.bin_vals(1:end-1)';
		if isinf(regressor_obj.x_vals(end))
			tmp = diff(regressor_obj.bin_vals)'/2;
			regressor_obj.x_vals(end) = regressor_obj.bin_vals(end-1) + tmp(end-1);
		end
		if isinf(regressor_obj.x_vals(1))
			tmp = diff(regressor_obj.bin_vals)'/2;
			regressor_obj.x_vals(1) = regressor_obj.bin_vals(2) - tmp(2);
		end
	otherwise
	error('Unrecognized bin type')
end

