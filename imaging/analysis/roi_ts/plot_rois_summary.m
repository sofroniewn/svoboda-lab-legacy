function plot_rois_summary


global handles_roi_tuning_curve;
global handles_roi_ts;
global summary_ca
    
if ~isempty(handles_roi_tuning_curve) && ~isempty(summary_ca)
	if ~isempty(handles_roi_tuning_curve.roi_id)
		tuning_param = summary_ca{handles_roi_tuning_curve.summary_id}.tuning_param;
		title_str = ['Tuning to ' tuning_param.stim_type_name '    ROI ' num2str(handles_roi_tuning_curve.roi_id) '   PLANE ' num2str(handles_roi_tuning_curve.roi_plane)];
        set(handles_roi_tuning_curve.highlighted_roi_title,'string',title_str)

		x_data = tuning_param.estPrs(handles_roi_tuning_curve.roi_id,1);
		y_data = tuning_param.r2(handles_roi_tuning_curve.roi_id);
		set(handles_roi_tuning_curve.highlighted_roi,'xdata',x_data)
		set(handles_roi_tuning_curve.highlighted_roi,'ydata',y_data)
 		figure(4)
 	end
end