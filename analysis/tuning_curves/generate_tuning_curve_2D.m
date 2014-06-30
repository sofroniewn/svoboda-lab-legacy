function tuning_curve = generate_tuning_curve_2D(roi_id,stim_type_name_1,stim_type_name_2,keep_type_name,trial_range)


global session_bv;
global session_ca;

scim_frames = logical(session_bv.data_mat(24,:));
respones_vect = session_ca.dff(roi_id,:);

[regMat regVect regressor_obj_1 keep_obj] = get_full_regression_vars(stim_type_name_1,keep_type_name,trial_range);
regVect_1 = regVect(scim_frames);
num_groups_1 = regressor_obj_1.num_groups;
[regMat regVect regressor_obj_2 keep_obj] = get_full_regression_vars(stim_type_name_2,keep_type_name,trial_range);
regVect_2 = regVect(scim_frames);
num_groups_2 = regressor_obj_2.num_groups;


% if strcmp(keep_type_name,'openloop')
%  iti_vect = session_bv.data_mat(9,scim_frames);
%  tmp = session_bv.data_mat(25,:);
%  % correction for bug in anm0227254 data
%  if iti_vect(1) == 0
%   tmp = [tmp(501:end),repmat(tmp(end),1,501)];
%   end
%  trial_num_vect = tmp(scim_frames);
%  respones_vect = subtract_iti_dff(respones_vect,iti_vect,trial_num_vect);
% end


tuning_curve = get_tuning_curve_2D(regVect_1,num_groups_1,regVect_2,num_groups_2,respones_vect);
tuning_curve.x_vals = regressor_obj_1.x_vals;
tuning_curve.x_label = regressor_obj_1.x_label;
tuning_curve.x_range = regressor_obj_1.x_range;
tuning_curve.y_vals = regressor_obj_2.x_vals;
tuning_curve.y_label = regressor_obj_2.x_label;
tuning_curve.y_range = regressor_obj_2.x_range;

tuning_curve.z_label = regressor_obj_1.y_label;

tuning_curve.model_fit = [];
