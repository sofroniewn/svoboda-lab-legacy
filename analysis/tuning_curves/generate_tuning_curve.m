function tuning_curve = generate_tuning_curve(roi_id,stim_type_name,keep_type_name,trial_range)


global session_bv;
global session_ca;

[regMat regVect regressor_obj keep_obj] = get_full_regression_vars(stim_type_name,keep_type_name,trial_range);

scim_frames = logical(session_bv.data_mat(24,:));

regVect = regVect(scim_frames);
num_groups = regressor_obj.num_groups;
respones_vect = session_ca.dff(roi_id,:);


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


tuning_curve = get_tuning_curve(regVect,num_groups,respones_vect);
tuning_curve.x_vals = regressor_obj.x_vals;
tuning_curve.x_fit_vals = regressor_obj.x_fit_vals;
tuning_curve.x_label = regressor_obj.x_label;
tuning_curve.y_label = regressor_obj.y_label;
tuning_curve.x_range = regressor_obj.x_range;

if strcmp(keep_type_name,'openloop') | strcmp(keep_type_name,'closedloop')
	fit_model_on = 0;
else
	fit_model_on = 1;	
end



if fit_model_on
    full_x = [];
full_y = [];
for ij = 1:length(tuning_curve.x_vals)
	full_x = [full_x;repmat(tuning_curve.x_vals(ij),length(tuning_curve.data{ij}),1)];
	full_y = [full_y;tuning_curve.data{ij}'];
end

baseline = prctile(tuning_curve.means,10);
	weight = tuning_curve.means - baseline;
	mod_depth = max(weight);
    %weight = abs(weight);
	weight = weight/sum(weight);
	tuned_val = sum(weight.*tuning_curve.x_vals);


switch regressor_obj.tune_type
	case 'Gauss'
		initPrs = [tuned_val, 1, mod_depth, baseline];
		tuning_curve.model_fit = fitGauss(full_x,full_y,initPrs);
		tuning_curve.model_fit.curve = fitGauss_modelFun(tuning_curve.x_fit_vals,tuning_curve.model_fit.estPrs);
	case 'Sigmoid'
		initPrs = [];
		tuning_curve.model_fit = fitSigmoid(full_x,full_y,initPrs);
		tuning_curve.model_fit.curve = fitSigmoid_modelFun(tuning_curve.x_fit_vals,tuning_curve.model_fit.estPrs);
	otherwise
	tuning_curve.model_fit = [];
end

else
tuning_curve.model_fit = [];
end