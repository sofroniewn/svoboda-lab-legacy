function constrain_trials = define_keep_trials_ephys(keep_type_name,id_type,exp_type,trial_range,run_thresh)

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
		constrain_trials{2}.vals = [run_thresh Inf];
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
	case 'ol_whisking'
		[group_ids groups] = define_group_ids(exp_type,id_type,[]);
		constrain_trials = cell(3,1);
		constrain_trials{1}.name = 'group_id';
		constrain_trials{1}.vals = group_ids;
		constrain_trials{1}.type = 'equal';
		constrain_trials{2}.name = 'mean_speed';
		constrain_trials{2}.vals = [0 Inf];
		constrain_trials{2}.type = 'range';
		constrain_trials{3}.name = 'whisker_data';
		constrain_trials{3}.vals = [1];
		constrain_trials{3}.type = 'equal';
	otherwise
		error('WGNR :: unrecognized keep type for ephys')
end

		% constrain_trials{numel(constrain_trials)+1}.name = 'trial_num';
		% constrain_trials{numel(constrain_trials)+1}.vals = trial_range;
		% constrain_trials{numel(constrain_trials)+1}.type = 'equal';

