function keep_trials = apply_trial_constraints(u_ck,u_labels,constrain_trials)

	keep_trials = ones(numel(constrain_trials),size(u_ck,2));

	for ij = 1:numel(constrain_trials)
		u_ind = find(strcmp(u_labels,constrain_trials{ij}.name));
		if isempty(u_ind)
			error('WGNR :: could not find u label to constrain trials')
		end
		switch constrain_trials{ij}.type
			case 'equal'
				keep_trials(ij,:) = ismember(u_ck(u_ind,:),constrain_trials{ij}.vals);
			case 'range'
				keep_trials(ij,:) = u_ck(u_ind,:)>=constrain_trials{ij}.vals(1) & u_ck(u_ind,:)<constrain_trials{ij}.vals(2);
			otherwise
				error('WGNR :: constrain type not recognized ')
		end
	end

keep_trials = all(keep_trials);