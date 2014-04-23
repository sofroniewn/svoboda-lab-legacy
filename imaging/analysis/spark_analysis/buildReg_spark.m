function [regMat,vals] = buildReg_spark(full_trial_data,stimType)

%% make two files
% first file ..._X contains variable X, 0 1 matrix as matfile, matrix of regressors, rows by time
% must have same number of time points as imaging data. variable has been discretized.
% freeman function - buildreg
%
% second file (for tuning analysis)    ..._s contains values each of the regressors correspons to
% 

regMat = [];

switch stimType
	case 'corPos'
		vals = [0:2:30];
		if ~isempty(full_trial_data)
			regress_var = full_trial_data(:,12);
			keep_ind = 1 - full_trial_data(:,3);
			regMat = binReg_spark(regress_var,vals,keep_ind);
		end
	case 'speed'
		vals = [0:5:35];
		if ~isempty(full_trial_data)
			regress_var = full_trial_data(:,7);
			keep_ind = 1 - full_trial_data(:,3);
			regMat = binReg_spark(regress_var,vals,keep_ind);
		end
	otherwise
		error('Unrecognized stim type for spark regression')
end
