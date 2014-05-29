function [regMat regVect regressor_obj keep_obj] = get_full_regression_vars(stim_type_name,keep_type_name,trial_range)

[regMat regVect regressor_obj] = define_regression_var(stim_type_name);
[keep_inds keep_obj] = define_keep_inds(keep_type_name,trial_range);



regMat = remove_blank_inds(regMat,keep_inds);
regVect = remove_blank_inds(regVect,keep_inds);

