function BEHAVIOUR_VECT = get_behaviour_vect(session,type,trial_range)
% normalize amplitude values and create trial by trial firing rate histograms

BEHAVIOUR_VECT.trial_range = [min(trial_range) max(trial_range)];

switch type
	case 'speed'
		BEHAVIOUR_VECT.vals = session.trial_info.mean_speed(BEHAVIOUR_VECT.trial_range(1):BEHAVIOUR_VECT.trial_range(2));
		BEHAVIOUR_VECT.ylabel = 'Mean speed (cm/s)';
	otherwise
		error('WGNR :: unrecognized behaviour vector type')
	end
 end
