function [regMat regVect regressor_obj] = define_regression_var(stim_type_name)


global session_bv

switch stim_type_name
	case 'speed2D'
		regressor_obj.var_tune = session_bv.data_mat(22,:);
		regressor_obj.bin_vals = [0:4:30 Inf]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Speed (cm/s)';
		regressor_obj.x_range = [0 30];
		regressor_obj.tune_type = 'Sigmoid';
	case 'speed'
		regressor_obj.var_tune = session_bv.data_mat(22,:);
		regressor_obj.bin_vals = [0:2:30 Inf]; 
		regressor_obj.bin_type = 'edges';
		regressor_obj.x_label = 'Speed (cm/s)';
		regressor_obj.x_range = [0 30];
		regressor_obj.tune_type = 'Sigmoid';
	case 'corPos2D'
		regressor_obj.var_tune = session_bv.data_mat(3,:);
		regressor_obj.bin_vals = [0:2:29]+0.5; 
		regressor_obj.bin_type = 'centers';
		regressor_obj.x_label = 'Wall distance (mm)';
		regressor_obj.x_range = [0 30];
		regressor_obj.tune_type = 'Gauss';
	case 'corPos'
		regressor_obj.var_tune = session_bv.data_mat(3,:);
		regressor_obj.bin_vals = [0:2:29]+0.5; 
		regressor_obj.bin_type = 'centers';
		regressor_obj.x_label = 'Wall distance (mm)';
		regressor_obj.x_range = [0 30];
		regressor_obj.tune_type = 'Gauss';
	case 'laser'
		regressor_obj.var_tune = session_bv.data_mat(5,:);
		regressor_obj.bin_vals = [0 1 2 3 4];
		regressor_obj.bin_type = 'equal';		
		regressor_obj.x_label = 'Laser power (V)';
		regressor_obj.x_range = [0 4];
		regressor_obj.tune_type = 'Gauss';
	otherwise
		error('Unrecognized stim type for spark regression')
end

regressor_obj.var_name = stim_type_name;
regressor_obj.y_label = 'Avg dF/F';

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

regressor_obj.x_fit_vals = [regressor_obj.x_range(1):.5:regressor_obj.x_range(2)];


[regMat regVect] = get_regression_mat(regressor_obj);