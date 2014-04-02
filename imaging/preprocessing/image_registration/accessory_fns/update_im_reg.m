function update_im_reg(obj,event,handles)

global im_session;

cur_files = dir(fullfile(im_session.basic_info.data_dir,'*_main_*.tif'));
num_old_files = numel(im_session.basic_info.cur_files);
num_behaviour = Inf;
set(handles.text_frac_registered,'String',sprintf('Registered %d/%d',num_old_files,numel(cur_files)))


	% extract behaviour information if necessary
if get(handles.checkbox_behaviour,'Value') == 1
	global session;
	num_behaviour = numel(session.data);
end

num_match = min(num_behaviour,numel(cur_files));

if num_match > num_old_files
  %  disp('New files')
	im_session.basic_info.cur_files = cur_files(1:num_match);
    start_trial = num_old_files+1;
	align_chan = eval(get(handles.edit_align_channel,'string'));
	save_opts.overwrite = get(handles.checkbox_overwrite,'Value');
	save_opts.aligned = get(handles.checkbox_save_aligned,'Value');
	save_opts.text = get(handles.checkbox_save_text,'Value');
	register_directory(start_trial,num_match,numel(cur_files),align_chan,save_opts,handles)	
end

   time_elapsed = toc;
   time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
   set(handles.text_time,'String',time_elapsed_str)

end