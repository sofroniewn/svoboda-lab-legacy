function regMat = gen_regression_mat(regress_var,bin_vals,bin_type)
	% regress_var - input variable for regression
	% bin values -
	% type of binning - 
	% keed indices - 

switch bin_type
	case 'equal'
		regMat = zeros(length(bin_vals),length(regress_var));
		for ij=1:length(bin_vals)
			inds = regress_var==bin_vals(ij);
			regMat(ij,inds) = 1;
		end
	case 'centers'
		bin_edges = diff(bin_vals)/2+bin_vals(1:end-1);
		bin_edges = [-Inf bin_edges Inf];
		regMat = zeros(length(bin_edges)-1,length(regress_var));
		for ij=1:length(bin_vals)
			inds = regress_var>=bin_edges(ij) & regress_var<bin_edges(ij+1);
			regMat(ij,inds) = 1;
		end
	case 'edges'
		bin_edges = bin_vals;
		regMat = zeros(length(bin_edges)-1,length(regress_var));
		for ij=1:length(bin_vals)-1
			inds = regress_var>=bin_edges(ij) & regress_var<bin_edges(ij+1);
			regMat(ij,inds) = 1;
		end		
	otherwise
	error('Unrecognized bin type')
end