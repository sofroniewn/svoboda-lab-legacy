function image_processing_gui_toggle_enable(handles,enable_str,type)

if any(ismember(type,1))
set(handles.togglebutton_register,'enable',enable_str)
end

if any(ismember(type,2))
set(handles.checkbox_overwrite,'enable',enable_str)
set(handles.checkbox_save_aligned,'enable',enable_str)
set(handles.text_align_chan,'enable',enable_str)
set(handles.edit_align_chan,'enable',enable_str)
set(handles.text_downsample,'enable',enable_str)
set(handles.edit_downsample,'enable',enable_str)
set(handles.pushbutton_output_path,'enable',enable_str)
set(handles.checkbox_behaviour,'enable',enable_str)
set(handles.checkbox_register,'enable',enable_str) 
set(handles.pushbutton_export_params,'enable',enable_str)
set(handles.pushbutton_export_data,'enable',enable_str)
end

if any(ismember(type,5))
set(handles.text_anm,'enable',enable_str)
set(handles.text_date,'enable',enable_str)
set(handles.text_run,'enable',enable_str)
end

if any(ismember(type,3))
set(handles.text_registered_trials,'enable',enable_str)
set(handles.text_imaging_trials,'enable',enable_str)
set(handles.text_num_behaviour,'enable',enable_str)
set(handles.text_num_chan,'enable',enable_str)
set(handles.text_num_planes,'enable',enable_str)
end

if any(ismember(type,4))
	set(handles.text_status,'enable',enable_str)
	set(handles.text_time,'enable',enable_str)
end

if any(ismember(type,6))
set(handles.pushbutton_data_dir,'enable',enable_str)
end

end