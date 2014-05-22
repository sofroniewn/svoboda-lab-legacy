function [regMat regress_var] = generate_tuning_curve_params(stim_type_name,keep_type_name)


keep_inds = generate_tuning_curve_keep_inds(keep_type_name);
[regMat regress_var] = generate_tuning_curve_regMat(stim_type_name);
regMat = remove_blank_inds(regMat,keep_inds);

