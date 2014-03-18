function [full_vars col_mat] = expand_behavioural_types(x_vars,var_tune,edges)

	num_behav_vars = numel(x_vars);
	num_types = length(edges) - 1;

	full_vars = cell(num_behav_vars,num_types);
	for ij = 1:num_behav_vars
		for ik = 1:num_types
			if ij == var_tune
				range = [edges(ik) edges(ik+1)];
			else
				range = x_vars{ij}.range;
			end
			full_vars{ij,ik}.str = x_vars{ij}.str;
			full_vars{ij,ik}.name = x_vars{ij}.name;
			full_vars{ij,ik}.range = range;
		end
	end

% define colour matrix
col_mat = zeros(length(edges)-1,3);
col_mat(1:end,1) = [0:(length(edges)-2)]/(length(edges)-2);

end