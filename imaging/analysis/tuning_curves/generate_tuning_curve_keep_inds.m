function [keep_inds] = generate_tuning_curve_keep_inds(keep_type_name)

switch keep_type_name
	case 'base'
		x_vars = cell(1,1);
		x_vars{1}.str = 'session_bv.data_mat(9,:)';
		x_vars{1}.name = 'ITI';
		x_vars{1}.vals = 0;
		x_vars{1}.type = 'equal'; % equal - use ismember, range two element vecotr use range.
	case 'openloop'
		x_vars = cell(1,1);
		x_vars{1}.str = 'session_bv.data_mat(9,:)';
		x_vars{1}.name = 'ITI';
		x_vars{1}.vals = 0;
		x_vars{1}.type = 'equal';
		x_vars{2}.str = 'session_bv.data_mat(8,:)';
		x_vars{2}.name = 'trial_num';
		x_vars{2}.vals = find(~session_bv.trial_config.processed_dat.vals.trial_type);
		x_vars{2}.type = 'equal'; % equal - use ismember, range two element vecotr use range.
	case 'closedloop'
		x_vars = cell(1,1);
		x_vars{1}.str = 'session_bv.data_mat(9,:)';
		x_vars{1}.name = 'ITI';
		x_vars{1}.vals = 0;
		x_vars{1}.type = 'equal'; % equal - use ismember, range two element vecotr use range.
		x_vars{2}.str = 'session_bv.data_mat(8,:)';
		x_vars{2}.name = 'trial_num';
		x_vars{2}.vals = find(session_bv.trial_config.processed_dat.vals.trial_type);
		x_vars{2}.type = 'equal'; % equal - use ismember, range two element vecotr use range.
	otherwise
		error('Unrecognized stim type for spark regression')
end

keep_inds = define_keep_inds(x_vars);

