function plot_rois_tuning_2D


global handles_roi_tuning_curve;
global handles_roi_ts;

if ~isempty(handles_roi_tuning_curve)
if ~isempty(handles_roi_tuning_curve.roi_id)
	stim_type_name_1 = 'speed2D';
	stim_type_name_2 = 'corPos2D';
	if strcmp(handles_roi_tuning_curve.keep_type_name,'openloop') || strcmp(handles_roi_tuning_curve.keep_type_name,'closedloop')
		keep_type_name = handles_roi_tuning_curve.keep_type_name;
	else
		keep_type_name = 'base';	
	end
	trial_range = [0 Inf];
	roi_id = handles_roi_tuning_curve.roi_id;
	tuning_curve = generate_tuning_curve_2D(roi_id,stim_type_name_1,stim_type_name_2,keep_type_name,trial_range);
	plot_tuning_curves_2D(5,tuning_curve)
end
end