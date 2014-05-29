function plot_rois_tuning


global handles_roi_tuning_curve;
global handles_roi_ts;

if ~isempty(handles_roi_tuning_curve)
if ~isempty(handles_roi_tuning_curve.roi_id)
 tuning_curve = generate_tuning_curve(handles_roi_tuning_curve.roi_id,handles_roi_tuning_curve.bv_name,handles_roi_tuning_curve.keep_type_name,handles_roi_tuning_curve.trial_range);
 tuning_curve.title = ['ROI ' num2str(handles_roi_tuning_curve.roi_id)];
 plot_tuning_curves(2,tuning_curve,handles_roi_ts.y_col);
end
end