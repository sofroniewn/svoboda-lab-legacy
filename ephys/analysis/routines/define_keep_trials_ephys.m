function constrain_trials = define_keep_trials_ephys(keep_type_name,id_type,exp_type)

switch keep_type_name
	case 'ol_base'
		[group_ids groups] = define_group_ids(exp_type,id_type,[]);
		constrain_trials = cell(2,1);
		constrain_trials{1}.name = 'group_id';
		constrain_trials{1}.vals = group_ids;
		constrain_trials{1}.type = 'equal';
		constrain_trials{2}.name = 'mean_speed';
		constrain_trials{2}.vals = [0 Inf];
		constrain_trials{2}.type = 'range';
	case 'ol_running'
		[group_ids groups] = define_group_ids(exp_type,id_type,[]);
		constrain_trials = cell(2,1);
		constrain_trials{1}.name = 'group_id';
		constrain_trials{1}.vals = group_ids;
		constrain_trials{1}.type = 'equal';
		constrain_trials{2}.name = 'mean_speed';
		constrain_trials{2}.vals = [5 Inf];
		constrain_trials{2}.type = 'range';
	case 'ol_not_running'
		[group_ids groups] = define_group_ids(exp_type,id_type,[]);
		constrain_trials = cell(2,1);
		constrain_trials{1}.name = 'group_id';
		constrain_trials{1}.vals = group_ids;
		constrain_trials{1}.type = 'equal';
		constrain_trials{2}.name = 'mean_speed';
		constrain_trials{2}.vals = [0 1];
		constrain_trials{2}.type = 'range';
	otherwise
		error('WGNR :: unrecognized keep type for ephys')
end
