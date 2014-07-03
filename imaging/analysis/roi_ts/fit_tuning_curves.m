function tuning_param = fit_tuning_curves(stim_type_name,keep_type_name,trial_range,num_roi)


tuning_param.estPrs = zeros(num_roi,4);
tuning_param.r2 = zeros(num_roi,1);
tuning_param.dI = zeros(num_roi,1);
tuning_param.keep_val = zeros(num_roi,1);
tuning_param.stim_type_name = stim_type_name;
tuning_param.keep_type_name = keep_type_name;
tuning_param.trial_range = trial_range;

for ij = 1:num_roi
	roi_id = ij;
	
	fprintf('GET %s TUNING roi %d of %d \n',stim_type_name,roi_id,num_roi)
	tuning_curve = generate_tuning_curve(roi_id,stim_type_name,keep_type_name,trial_range);

	tuning_param.estPrs(ij,:) = tuning_curve.model_fit.estPrs;
	tuning_param.r2(ij,:) = tuning_curve.model_fit.r2;
	tuning_param.dI(ij,:) = tuning_curve.model_fit.dI;
	tuning_param.keep_val(ij) = tuning_curve.model_fit.keep_val;
	if ij == 1
		tuning_param.x_range = tuning_curve.x_range;
		tuning_param.x_label = tuning_curve.x_label;
		tuning_param.y_label = tuning_curve.y_label;
	end
end