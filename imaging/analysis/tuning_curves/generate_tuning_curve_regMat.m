function [regMat regress_var] = generate_tuning_curve_regMat(stim_type_name)


global session_bv
switch stim_type_name
	case 'speed'
		regress_var = session_bv.data_mat(22,:);
		bin_vals = [0:15 Inf]; 
		bin_type = 'edges';
	case 'corPos'
		regress_var = session_bv.data_mat(3,:);
		bin_vals = [0:31]; 
		bin_type = 'edges';
	case 'laser'
		var_tune = session_bv.data_mat(5,:);
		bin_vals = [0 1 2 3 4];
		bin_type = 'equal';		
	otherwise
		error('Unrecognized stim type for spark regression')
end

regMat = gen_regression_mat(regress_var,bin_vals,bin_type);