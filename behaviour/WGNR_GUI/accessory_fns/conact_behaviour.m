function session_bv = conact_behaviour(num_files,session)

	session_bv.basic_info = session.basic_info;
	session_bv.rig_config = session.rig_config;
	session_bv.trial_config = session.trial_config;
	session_bv.trial_info = session.trial_info;
	
	names = fieldnames(session_bv.trial_info);
	for ik = 1:numel(names)
		session_bv.trial_info.(names{ik}) = session_bv.trial_info.(names{ik})(1:num_files);
	end

	data_mat = [];
	data_names = [];
	data_names = cat(1,session.data{1}.trial_mat_names',session.data{1}.processed_matrix_names');
	for ij = 1:num_files
		data_mat_tmp = cat(1,session.data{ij}.trial_matrix,session.data{ij}.processed_matrix);
		data_mat = cat(2,data_mat,data_mat_tmp);
	end

	session_bv.data_names = data_names;
	session_bv.data_mat = data_mat;
