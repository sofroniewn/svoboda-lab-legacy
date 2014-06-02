function plot_rois_raster


global handles_roi_tuning_curve;
global handles_roi_ts;

if ~isempty(handles_roi_tuning_curve)
if ~isempty(handles_roi_tuning_curve.roi_id)
	trial_raster = generate_trial_raster(handles_roi_tuning_curve.roi_id,handles_roi_tuning_curve.bv_name,handles_roi_tuning_curve.keep_type_name,handles_roi_tuning_curve.trial_range);
	trial_raster.title = ['ROI ' num2str(handles_roi_tuning_curve.roi_id)];
	plot_trial_raster(3,trial_raster);
	end
end