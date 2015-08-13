function s = concat_behaviour_params(session)

length_params = 0;
num_params = 0;
for ij = 1:numel(session.data)
	if isfield(session.data{ij},'trial_matrix')
	length_params = length_params+size(session.data{ij}.trial_matrix,2);
	session.data{ij}.trial_matrix = cat(1,session.data{ij}.trial_matrix,session.data{ij}.processed_matrix);
	num_params = size(session.data{ij}.trial_matrix,1);
	params_names = cat(2,session.data{ij}.trial_mat_names,session.data{ij}.processed_matrix_names);
	end
end

params_mat = zeros(num_params,length_params);
start_ind = 0;
for ij = 1:numel(session.data)
	if isfield(session.data{ij},'trial_matrix')
	params_mat(:,start_ind+1:start_ind+size(session.data{ij}.trial_matrix,2)) = session.data{ij}.trial_matrix;
	start_ind = start_ind + size(session.data{ij}.trial_matrix,2);
	end
end


if ~isempty(params_mat)
%	s = struct('name', params_names, 'value', mat2cell(params_mat,ones(num_params,1))');
	s = [];
	for ij = 1:numel(params_names)
		s.(params_names{ij}) = params_mat(ij,:);
	end
else
	s = [];
end

