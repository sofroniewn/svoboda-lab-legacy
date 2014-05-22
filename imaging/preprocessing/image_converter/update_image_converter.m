function update_image_viewer(obj,event,handles)

num_frames = str2num(get(handles.edit_num_frames,'string'));
overwrite = get(handles.checkbox_overwrite,'value');




time_elapsed = toc;
time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
set(handles.text_time,'String',time_elapsed_str)

end