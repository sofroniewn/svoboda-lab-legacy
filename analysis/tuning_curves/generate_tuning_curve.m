function tuning_curve = generate_tuning_curve(roi_id,stim_type_name,keep_type_name,trial_range)


global session_bv;
global session_ca;

[regMat regVect regressor_obj keep_obj] = get_full_regression_vars(stim_type_name,keep_type_name,trial_range);

scim_frames = logical(session_bv.data_mat(24,:));

regVect = regVect(scim_frames);
num_groups = regressor_obj.num_groups;
responseVar = session_ca.dff(roi_id,:);

tuning_curve = get_tuning_curve(regVect,num_groups,responseVar);
tuning_curve.x_vals = regressor_obj.x_vals;
tuning_curve.x_label = regressor_obj.x_label;
tuning_curve.x_range = regressor_obj.x_range;
