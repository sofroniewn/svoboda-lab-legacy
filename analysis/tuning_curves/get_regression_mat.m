function [regMat regVect] = get_regression_mat(regressor_obj)
	% var_tune - input variable for regression
	% bin values -
	% type of binning - 
	% keed indices - 

switch regressor_obj.bin_type
	case 'equal'
		regMat = zeros(length(regressor_obj.bin_vals),length(regressor_obj.var_tune));
		regVect = zeros(1,length(regressor_obj.var_tune));
		for ij=1:length(regressor_obj.bin_vals)
			inds = regressor_obj.var_tune==regressor_obj.bin_vals(ij);
			regMat(ij,inds) = 1;
			regVect(inds) = ij;
		end
	case 'centers'
		bin_edges = diff(regressor_obj.bin_vals)/2+regressor_obj.bin_vals(1:end-1);
		bin_edges = [-Inf bin_edges Inf];
		regMat = zeros(length(regressor_obj.bin_vals),length(regressor_obj.var_tune));
		regVect = zeros(1,length(regressor_obj.var_tune));
		for ij=1:length(regressor_obj.bin_vals)
			inds = regressor_obj.var_tune>=bin_edges(ij) & regressor_obj.var_tune<bin_edges(ij+1);
			regMat(ij,inds) = 1;
			regVect(inds) = ij;
		end
	case 'edges'
		bin_edges = regressor_obj.bin_vals;
		regMat = zeros(length(bin_edges)-1,length(regressor_obj.var_tune));
		regVect = zeros(1,length(regressor_obj.var_tune));
		for ij=1:length(regressor_obj.bin_vals)-1
			inds = regressor_obj.var_tune>=bin_edges(ij) & regressor_obj.var_tune<bin_edges(ij+1);
			regMat(ij,inds) = 1;
			regVect(inds) = ij;
		end		
	otherwise
	error('Unrecognized bin type')
end