function image_processing_gui_toggle_enable(handles,enable_str,type)

if any(ismember(type,1))
set(handles.popupmenu_ref,'enable',enable_str)
set(handles.pushbutton_register_im,'enable',enable_str)
set(handles.togglebutton_online_mode,'enable',enable_str)
set(handles.popupmenu_rois,'enable',enable_str)

end

if any(ismember(type,2))
set(handles.checkbox_overwrite,'enable',enable_str)
set(handles.checkbox_save_aligned,'enable',enable_str)
set(handles.text_analyze_chan,'enable',enable_str)
set(handles.edit_analyze_chan,'enable',enable_str)
set(handles.pushbutton_cluster_path,'enable',enable_str)
set(handles.checkbox_save_text,'enable',enable_str)
set(handles.checkbox_behaviour,'enable',enable_str)
set(handles.checkbox_use_cluster,'enable',enable_str)
%set(handles.text_TCP_status,'enable',enable_str)
end

if any(ismember(type,4))
set(handles.text_anm,'enable',enable_str)
set(handles.text_date,'enable',enable_str)
set(handles.text_run,'enable',enable_str)
set(handles.text_num_planes,'enable',enable_str)
set(handles.text_frac_registered,'enable',enable_str)
set(handles.text_num_behaviour,'enable',enable_str)
set(handles.text_num_chan,'enable',enable_str)
set(handles.text_align_chan,'enable',enable_str)
end

if any(ismember(type,6))
	set(handles.text_status,'enable',enable_str)
	set(handles.text_time,'enable',enable_str)
end

end