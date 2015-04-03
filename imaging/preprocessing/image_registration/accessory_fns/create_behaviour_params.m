function s = create_behaviour_params(session)

length_params = 0;
num_params = 0;
for ij = 1:numel(session.data)
	if isfield(session.data{ij},'imaging_matrix')
	length_params = length_params+size(session.data{ij}.imaging_matrix,1);
	num_params = size(session.data{ij}.imaging_matrix,2);
	params_names = session.data{ij}.imaging_names;
	end
end

params_mat = zeros(num_params,length_params);
start_ind = 0;
for ij = 1:numel(session.data)
	if isfield(session.data{ij},'imaging_matrix')
	params_mat(:,start_ind+1:start_ind+size(session.data{ij}.imaging_matrix,1)) = session.data{ij}.imaging_matrix';
	start_ind = start_ind + size(session.data{ij}.imaging_matrix,1);
	end
end

if ~isempty(params_mat)
	s = struct('name', params_names, 'value', mat2cell(params_mat,ones(num_params,1))');
else
	s = [];
end