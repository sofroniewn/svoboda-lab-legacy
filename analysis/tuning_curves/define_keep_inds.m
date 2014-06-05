function [keep_inds keep_vars] = define_keep_inds(keep_type_name,trial_range)

global session_bv;

switch keep_type_name
	case 'base'
		keep_vars = cell(2,1);
		keep_vars{1}.vect = session_bv.data_mat(9,:);
		keep_vars{1}.name = 'ITI';
		keep_vars{1}.vals = 0;
		keep_vars{1}.type = 'equal'; % equal - use ismember, range two element vector use range, inclusive.
		keep_vars{2}.vect = session_bv.data_mat(25,:);
		keep_vars{2}.name = 'trial_num';
		keep_vars{2}.vals = trial_range;
		keep_vars{2}.type = 'range';
	case 'running'
		keep_vars = cell(3,1);
		keep_vars{1}.vect = session_bv.data_mat(9,:);
		keep_vars{1}.name = 'ITI';
		keep_vars{1}.vals = 0;
		keep_vars{1}.type = 'equal'; % equal - use ismember, range two element vector use range, inclusive.
		keep_vars{2}.vect = session_bv.data_mat(25,:);
		keep_vars{2}.name = 'trial_num';
		keep_vars{2}.vals = trial_range;
		keep_vars{2}.type = 'range';
		keep_vars{3}.vect = session_bv.data_mat(22,:);
		keep_vars{3}.name = 'speed';
		keep_vars{3}.vals = [5 Inf];
		keep_vars{3}.type = 'range'; % equal - use ismember, range two element vector use range.
	case 'farFromWall'
		keep_vars = cell(3,1);
		keep_vars{1}.vect = session_bv.data_mat(9,:);
		keep_vars{1}.name = 'ITI';
		keep_vars{1}.vals = 0;
		keep_vars{1}.type = 'equal'; % equal - use ismember, range two element vector use range, inclusive.
		keep_vars{2}.vect = session_bv.data_mat(25,:);
		keep_vars{2}.name = 'trial_num';
		keep_vars{2}.vals = trial_range;
		keep_vars{2}.type = 'range';
		keep_vars{3}.vect = session_bv.data_mat(3,:); %smooth(session_bv.data_mat(3,:),500);
		keep_vars{3}.name = 'corPos';
		keep_vars{3}.vals = [16 Inf];
		keep_vars{3}.type = 'range'; % equal - use ismember, range two element vector use range.
	case 'openloop'
		keep_vars = cell(4,1);
		keep_vars{1}.vect = session_bv.data_mat(9,:);
		keep_vars{1}.name = 'ITI';
		keep_vars{1}.vals = 0;
		keep_vars{1}.type = 'equal';
		keep_vars{2}.vect = session_bv.data_mat(25,:);
		keep_vars{2}.name = 'trial_num';
		keep_vars{2}.vals = trial_range;
		keep_vars{2}.type = 'range';
		keep_vars{3}.vect = session_bv.data_mat(8,:);
		keep_vars{3}.name = 'trial_id';
		keep_vars{3}.vals = find(~session_bv.trial_config.processed_dat.vals.trial_type);
		keep_vars{3}.type = 'equal'; % equal - use ismember, range two element vector use range.
		keep_vars{4}.vect = session_bv.data_mat(17,:);
		keep_vars{4}.name = 'test_period';
		keep_vars{4}.vals = 1;
		keep_vars{4}.type = 'equal'; % equal - use ismember, range two element vector use range.
	case 'closedloop'
		keep_vars = cell(3,1);
		keep_vars{1}.vect = session_bv.data_mat(9,:);
		keep_vars{1}.name = 'ITI';
		keep_vars{1}.vals = 0;
		keep_vars{1}.type = 'equal'; % equal - use ismember, range two element vector use range.
		keep_vars{2}.vect = session_bv.data_mat(25,:);
		keep_vars{2}.name = 'trial_num';
		keep_vars{2}.vals = trial_range;
		keep_vars{2}.type = 'range';
		keep_vars{3}.vect = session_bv.data_mat(8,:);
		keep_vars{3}.name = 'trial_id';
		keep_vars{3}.vals = find(session_bv.trial_config.processed_dat.vals.trial_type);
		keep_vars{3}.type = 'equal'; % equal - use ismember, range two element vector use range.
	otherwise
		error('Unrecognized stim type for spark regression')
end

keep_inds = get_keep_inds(keep_vars);

