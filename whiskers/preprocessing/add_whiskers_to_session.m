function session = add_whiskers_to_session(session,wv,keep_behaviour,keep_whiskers)

	% Check number of kept files correct
	if length(keep_behaviour) ~= length(keep_whiskers)
		error('WGNR :: wrong number of kept trials')
	end

	% Check number of frames off by +/- one at most
	wv_file_lengths = zeros(length(keep_whiskers),1);
	for ij = 1:length(keep_whiskers)
		wv_file_lengths(ij) = size(wv.data{keep_whiskers(ij)}.theta_raw,2);
	end

	frame_errors = wv_file_lengths - session.trial_info.length(keep_behaviour)+session.trial_info.trial_start(keep_behaviour)-1;

	if max(abs(frame_errors)) > 1
		frame_errors
		error('WGNR :: wrong number of frames')
	end

	session.trial_info.whisker_data = zeros(numel(session.data),1);
	for ij = 1:numel(session.data)
		tmp = NaN(1,session.trial_info.length(ij));
		ind = find(keep_behaviour == ij,1,'first');
		if ~isempty(ind)
			session.trial_info.whisker_data(ij) = 1;
			min_length = min(session.trial_info.length(ij)-session.trial_info.trial_start(ij)+1,size(wv.data{keep_whiskers(ind)}.theta_raw,2));
			tmp(session.trial_info.trial_start(ij):session.trial_info.trial_start(ij)+min_length-1) = wv.data{keep_whiskers(ind)}.theta_amp(2,1:min_length);		
		end
		session.data{ij}.processed_matrix_names = cat(2,session.data{ij}.processed_matrix_names,'whisker_amp');
		session.data{ij}.processed_matrix = cat(1,session.data{ij}.processed_matrix,tmp);
	end

