function [keep_trials keep_vars split_var] = define_keep_trial(keep_type_name,trial_range)

global session_bv;

switch keep_type_name
	case 'base'
		keep_vars = cell(1,1);
		keep_vars{1}.vect = session_bv.trial_info.trial_num;
		keep_vars{1}.name = 'trial_num';
		keep_vars{1}.vals = trial_range;
		keep_vars{1}.type = 'range';

		split_var.vect = ones(length(session_bv.trial_info.trial_num),1);
		split_var.bins = 1;
		split_var.order = session_bv.trial_info.trial_num;		
		split_var.values = 0;
	
		split_var.x_label = 'Fraction of trial';
		split_var.x_max = 1;
	case 'running'
		keep_vars = cell(2,1);
		keep_vars{1}.vect = session_bv.trial_info.trial_num;
		keep_vars{1}.name = 'trial_num';
		keep_vars{1}.vals = trial_range;
		keep_vars{1}.type = 'range';
		keep_vars{2}.vect = session_bv.trial_info.mean_speed;
		keep_vars{2}.name = 'speed';
		keep_vars{2}.vals = [5 Inf];
		keep_vars{2}.type = 'range';

		split_var.vect = ones(length(session_bv.trial_info.trial_num),1);
		split_var.bins = 1;
		split_var.order = session_bv.trial_info.trial_num;		
		split_var.values = 0;
	
		split_var.x_label = 'Fraction of trial';
		split_var.x_max = 1;
	case 'farFromWall'
		keep_vars = cell(2,1);
		keep_vars{1}.vect = session_bv.trial_info.trial_num;
		keep_vars{1}.name = 'trial_num';
		keep_vars{1}.vals = trial_range;
		keep_vars{1}.type = 'range';
		keep_vars{2}.vect = session_bv.trial_info.inds;
		keep_vars{2}.name = 'trial_id';
		keep_vars{2}.vals = find(~session_bv.trial_config.processed_dat.vals.trial_type);
		keep_vars{2}.type = 'equal';
		keep_vars{2}.vals = keep_vars{2}.vals(7:end);
		
		split_var.vect = ones(length(session_bv.trial_info.trial_num),1);
		split_var.bins = 1;
		split_var.order = session_bv.trial_info.trial_num;		
		split_var.values = 0;
	
		split_var.x_label = 'Fraction of trial';
		split_var.x_max = 1;
	case 'openloop'
		keep_vars = cell(2,1);
		keep_vars{1}.vect = session_bv.trial_info.trial_num;
		keep_vars{1}.name = 'trial_num';
		keep_vars{1}.vals = trial_range;
		keep_vars{1}.type = 'range';
		keep_vars{2}.vect = session_bv.trial_info.inds;
		keep_vars{2}.name = 'trial_id';
		keep_vars{2}.vals = find(~session_bv.trial_config.processed_dat.vals.trial_type);
		keep_vars{2}.type = 'equal';
	
		split_var.vect = session_bv.trial_info.inds;
		split_var.bins = find(~session_bv.trial_config.processed_dat.vals.trial_type);
		split_var.order = session_bv.trial_info.trial_num;
		split_var.values = session_bv.trial_config.processed_dat.vals.trial_ol_vals(~session_bv.trial_config.processed_dat.vals.trial_type);
		split_var.x_label = 'Time (s)';
		split_var.x_max = mean(session_bv.trial_config.processed_dat.vals.trial_timeout(~session_bv.trial_config.processed_dat.vals.trial_type));
	case 'closedloop'
		keep_vars = cell(2,1);
		keep_vars{1}.vect = session_bv.trial_info.trial_num;
		keep_vars{1}.name = 'trial_num';
		keep_vars{1}.vals = trial_range;
		keep_vars{1}.type = 'range';
		keep_vars{2}.vect = session_bv.trial_info.inds;
		keep_vars{2}.name = 'trial_id';
		keep_vars{2}.vals = find(session_bv.trial_config.processed_dat.vals.trial_type);
		keep_vars{2}.type = 'equal';
		
		split_var.vect = session_bv.trial_info.inds;
		split_var.bins = find(session_bv.trial_config.processed_dat.vals.trial_type);
		split_var.order = session_bv.trial_info.trial_num;
		split_var.values = session_bv.trial_config.processed_dat.vals.trial_turn_vals(logical(session_bv.trial_config.processed_dat.vals.trial_type));
		split_var.x_label = 'Distance (cm)';
		split_var.x_max = mean(session_bv.trial_config.processed_dat.vals.trial_dur(logical(session_bv.trial_config.processed_dat.vals.trial_type)));
	otherwise
		error('Unrecognized stim type for spark regression')
end

split_var.name = keep_type_name;
split_var.num_groups = length(split_var.bins);
split_var.trial_num = session_bv.trial_info.trial_num;

keep_trials = get_keep_inds(keep_vars);

