function keep_trials = keep_maze_traj(session,traj_str,maze_id)



switch traj_str
	case 'None'
		keep_trials = zeros(length(session.data),1);
	case 'All'
		keep_trials = ones(length(session.data),1);
	case 'Correct'
		keep_trials = session.trial_info.correct;
	case 'Timeout'
		keep_trials = session.trial_info.timeout;
	case 'Rewarded'
		keep_trials = session.trial_info.rewarded;
	case 'Rewarded incorrect'
		keep_trials = session.trial_info.rewarded & ~session.trial_info.correct;
	case 'Dead end no reward'
		keep_trials = (session.trial_info.dead_end_left | session.trial_info.dead_end_right) & ~session.trial_info.rewarded;
otherwise
	error('Unrecognized tpye of trial')
end


keep_trials = keep_trials & (session.trial_info.maze_id == maze_id);