function [regMat,vals,range_vals] = buildReg_spark(full_trial_data,stimType)

%% make two files
% first file ..._X contains variable X, 0 1 matrix as matfile, matrix of regressors, rows by time
% must have same number of time points as imaging data. variable has been discretized.
% freeman function - buildreg
%
% second file (for tuning analysis)    ..._s contains values each of the regressors correspons to
% 

regMat = [];
vals = [];
num_bins = 5;

switch stimType
	case 'corPos'
		range_vals = [0 30];
		%vals = [floor(min(full_trial_data(:,12))):2:ceil(max(full_trial_data(:,12)))];
		if ~isempty(full_trial_data)
			regress_var = full_trial_data(:,12);
			keep_ind = ~logical(full_trial_data(:,3)) & full_trial_data(:,7)>5;
            keep_data =	regress_var(keep_ind);
			vals = valsReg_spark(keep_data,num_bins);
			vals = [range_vals(1) vals range_vals(2)];
			vals(2) = ceil(vals(2)/2)*2;
			vals(end-1) = floor(vals(end-1)/2)*2;
			vals = round(vals/2)*2;
			vals = unique(vals);
			vals = [-1:2:31];
			regMat = binReg_spark(regress_var,vals,keep_ind);
			display([stimType ' bin centers'])
			vals = vals(1:end-1) + diff(vals)/2;
			display(vals)
			if det(regMat*regMat') == 0
				sum(regMat')
            	error([stimType ' matrix not invertible'])
			end
		end
	case 'speed'
		range_vals = [0 50];
		if ~isempty(full_trial_data)
			regress_var = full_trial_data(:,7);
			keep_ind = ~logical(full_trial_data(:,3));
			keep_data =	regress_var(keep_ind);
			vals = valsReg_spark(keep_data,num_bins);
			vals = [range_vals(1) vals range_vals(2)];
			vals(2) = ceil(vals(2)/2)*2;
			vals(end-1) = floor(vals(end-1)/2)*2;
			vals = round(vals/2)*2;
			vals = unique(vals);
			vals = [0:2:30];
			regMat = binReg_spark(regress_var,vals,keep_ind);
			display([stimType ' bin centers'])
			vals = vals(1:end-1) + diff(vals)/2;
			display(vals)
			if det(regMat*regMat') == 0
				sum(regMat')
				error([stimType ' matrix not invertible'])
			end
		end
	otherwise
		error('Unrecognized stim type for spark regression')
end
