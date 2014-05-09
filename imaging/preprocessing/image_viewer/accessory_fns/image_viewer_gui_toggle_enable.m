function image_viewer_gui_toggle_enable(handles,enable_str,type)

if any(ismember(type,1))
set(handles.pushbutton_load_ref,'enable',enable_str)
set(handles.togglebutton_online_mode,'enable',enable_str)
set(handles.togglebutton_realtime_mode,'enable',enable_str)
end

if any(ismember(type,2))

end

if any(ismember(type,3))
set(handles.checkbox_plot_shifts,'enable',enable_str)
end

if any(ismember(type,4))
set(handles.text_anm,'enable',enable_str)
set(handles.text_date,'enable',enable_str)
set(handles.text_run,'enable',enable_str)
set(handles.text_num_planes,'enable',enable_str)
set(handles.text_imaging_trials,'enable',enable_str)
set(handles.text_registered_trials,'enable',enable_str)
set(handles.text_num_behaviour,'enable',enable_str)
set(handles.text_num_chan,'enable',enable_str)
set(handles.text_align_chan,'enable',enable_str)
end

if any(ismember(type,5))
set(handles.edit_display_chan,'enable',enable_str)
set(handles.text_display_chan,'enable',enable_str)
set(handles.popupmenu_list_plots,'enable',enable_str)
set(handles.popupmenu_spark_regressors,'enable',enable_str)
set(handles.checkbox_plot_images,'enable',enable_str)
set(handles.slider_look_up_table,'enable',enable_str)
set(handles.edit_look_up_table,'enable',enable_str)
set(handles.edit_display_planes,'enable',enable_str)
set(handles.text_display_planes,'enable',enable_str)
set(handles.slider_look_up_table_black,'enable',enable_str)
set(handles.edit_look_up_table_black,'enable',enable_str)
set(handles.slider_overlay,'enable',enable_str)
set(handles.edit_overlay_level,'enable',enable_str)
set(handles.text_overlay_level,'enable',enable_str)
set(handles.slider_trial_num,'enable',enable_str)
set(handles.edit_trial_num,'enable',enable_str)
set(handles.text_display_trial,'enable',enable_str)
set(handles.text_white_level,'enable',enable_str)
set(handles.text_black_level,'enable',enable_str)
set(handles.popupmenu_ref_selector,'enable',enable_str)
end

if any(ismember(type,6))
	set(handles.text_time,'enable',enable_str)
end


if any(ismember(type,7))
set(handles.pushbutton_set_output_dir,'enable',enable_str)
set(handles.togglebutton_draw_rois,'enable',enable_str)
set(handles.pushbutton_save_rois,'enable',enable_str)
set(handles.pushbutton_import_rois,'enable',enable_str)
set(handles.pushbutton_load_rois,'enable',enable_str)
set(handles.pushbutton_load_ts,'enable',enable_str)
set(handles.edit_rois_name,'enable',enable_str)
set(handles.pushbutton_previous_ref,'enable',enable_str)
set(handles.edit_align_channel,'enable',enable_str)
end



end