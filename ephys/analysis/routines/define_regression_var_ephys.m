function regressor_obj = define_regression_var_ephys(stim_type_name)

switch stim_type_name
	case 'speed'
		regressor_obj.var_tune = 'speed';
		regressor_obj.bin_vals = [0:5:45]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Speed (cm/s)';
		regressor_obj.x_range = [0 45];
		regressor_obj.x_tick = [0:5:45];
		regressor_obj.tune_type = 'Smooth';
		regressor_obj.x_fit_vals = [0:1:45];
	case 'running'
		regressor_obj.var_tune = 'speed';
		regressor_obj.bin_vals = [0 5 Inf]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Not running / running';
		regressor_obj.x_range = [0 10];
		regressor_obj.x_tick = [];
		regressor_obj.tune_type = '';
		regressor_obj.x_fit_vals = [0 10];
	case 'running_grouped'
		regressor_obj.var_tune = 'speed';
		regressor_obj.bin_vals = [0 5 18 Inf]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Not running / running';
		regressor_obj.x_range = [0 20];
		regressor_obj.x_tick = [];
		regressor_obj.tune_type = '';
		regressor_obj.x_fit_vals = [0 20];
	case 'running_fast_only'
		regressor_obj.var_tune = 'speed';
		regressor_obj.bin_vals = [5 18 Inf]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Running slow / fast';
		regressor_obj.x_range = [0 20];
		regressor_obj.x_tick = [];
		regressor_obj.tune_type = '';
		regressor_obj.x_fit_vals = [0 20];
	case 'lateral_speed'
		regressor_obj.var_tune = 'lateral_speed';
		regressor_obj.bin_vals = [-10:5:50]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Lateral speed (cm/s)';
		regressor_obj.x_range = [-10 50];
		regressor_obj.x_tick = [-10:5:50];
		regressor_obj.tune_type = '';
		regressor_obj.x_fit_vals = [-10:1:50];
	case 'run_angle'
		regressor_obj.var_tune = 'run_angle';
		regressor_obj.bin_vals = [-180:5:180]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Run angle (deg)';
		regressor_obj.x_range = [-180 180];
		regressor_obj.x_tick = [-180:5:180];
		regressor_obj.tune_type = '';
		regressor_obj.x_fit_vals = [-180:1:180];
	case 'run_direction'
		regressor_obj.var_tune = 'run_angle';
		regressor_obj.bin_vals = [-Inf 0 Inf]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Running left / right';
		regressor_obj.x_range = [-10 10];
		regressor_obj.x_tick = [];
		regressor_obj.tune_type = '';
		regressor_obj.x_fit_vals = [-10 10];
	case 'wall_vel'
		regressor_obj.var_tune = 'wall_vel';
		regressor_obj.bin_vals = [-35:5:35]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Wall velocity (mm/s)';
		regressor_obj.x_range = [-35 35];
		regressor_obj.x_tick = [-35:5:35];
		regressor_obj.tune_type = '';
		regressor_obj.x_fit_vals = [-35:1:35];
	case 'wall_direction'
		regressor_obj.var_tune = 'wall_vel';
		regressor_obj.bin_vals = [-Inf -.5 .5 Inf]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Wall velocity';
		regressor_obj.x_range = [-10 10];
		regressor_obj.x_tick = [];
		regressor_obj.tune_type = '';
		regressor_obj.x_fit_vals = [-10 10];
	case 'corPos'
		regressor_obj.var_tune = 'wall_pos';
		regressor_obj.bin_vals = [0:2:30]; 
		regressor_obj.bin_type = 'centers';
		regressor_obj.x_label = 'Wall distance (mm)';
		regressor_obj.x_range = [-1.5 31];
		regressor_obj.x_tick = [0:5:30];
		regressor_obj.tune_type = 'Smooth';
		regressor_obj.x_fit_vals = [0:.5:30];
	case 'touch'
		regressor_obj.var_tune = 'wall_pos';
		regressor_obj.bin_vals = [0 10 20 31]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Touch';
		regressor_obj.x_range = [0 30];
		regressor_obj.x_tick = [];
		regressor_obj.tune_type = '';
		regressor_obj.x_fit_vals = [0 30];
	case 'whisker_amp'
		regressor_obj.var_tune = 'whisker_amp';
		regressor_obj.bin_vals = [0:2:18]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Whisking amplitude (deg)';
		regressor_obj.x_range = [0 18];
		regressor_obj.x_tick = [0:3:18];
		regressor_obj.tune_type = 'Smooth';
		regressor_obj.x_fit_vals = [0:1:18];
	case 'whisking'
		regressor_obj.var_tune = 'whisker_amp';
		regressor_obj.bin_vals = [0 2 7 Inf]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Whisking small / large';
		regressor_obj.x_range = [0 10];
		regressor_obj.x_tick = [];
		regressor_obj.tune_type = '';
		regressor_obj.x_fit_vals = [0 10];
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

