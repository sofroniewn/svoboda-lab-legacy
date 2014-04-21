function [regMat,vals] = buildReg_spark(full_trial_data,stimType)

%% make two files
% first file ..._X contains variable X, 0 1 matrix as matfile, matrix of regressors, rows by time
% must have same number of time points as imaging data. variable has been discretized.
% freeman function - buildreg
%
% second file (for tuning analysis)    ..._s contains values each of the regressors correspons to
% 

switch stimType
	case 'cor_pos'
		regress_var = full_trial_data(12,:);
		vals = [0:2:30];
		keep_ind = 1 - full_trial_data(3,:);
		regMat = binReg_spark(regress_var,vals,keep_ind);
	case 'speed'
		regress_var = full_trial_data(7,:);
		vals = [0:2:40];
		keep_ind = 1 - full_trial_data(3,:);
		regMat = binReg_spark(regress_var,vals,keep_ind);
end
