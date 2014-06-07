function plot_rois_raster


global handles_roi_tuning_curve;
global handles_roi_ts;

if ~isempty(handles_roi_tuning_curve)
if ~isempty(handles_roi_tuning_curve.roi_id)
	if strcmp(handles_roi_tuning_curve.bv_name,'corPos')
		used_keep_name = 'openloop';
	elseif strcmp(handles_roi_tuning_curve.bv_name,'speed')
		used_keep_name = 'openloop';
	else
		used_keep_name = handles_roi_tuning_curve.keep_type_name;
	end

	trial_raster = generate_trial_raster(handles_roi_tuning_curve.roi_id,handles_roi_tuning_curve.bv_name,used_keep_name,handles_roi_tuning_curve.trial_range);
	trial_raster.title_1 = ['ROI ' num2str(handles_roi_tuning_curve.roi_id) '   '  handles_roi_tuning_curve.bv_name];
	trial_raster.title_2 = ['ROI ' num2str(handles_roi_tuning_curve.roi_id) '   '  used_keep_name];
	plot_trial_raster(3,trial_raster);
	end
end