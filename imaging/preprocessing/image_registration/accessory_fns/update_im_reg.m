function update_im_reg(obj,event,handles)

global im_session;

cur_files = dir(fullfile(im_session.basic_info.data_dir,'*_main_*.tif'));
if isfield(im_session,'reg')
	num_old_files = length(im_session.reg.nFrames);
else
	num_old_files = 0;
end

set(handles.text_frac_registered,'String',sprintf('Registered %d/%d',num_old_files,numel(cur_files)))


% extract behaviour information if necessary
if get(handles.checkbox_behaviour,'Value') == 1
	global session;
    base_path_behaviour = fullfile(handles.base_path, 'behaviour');
	cur_bv_files = dir(fullfile(base_path_behaviour,'*_trial_*.mat'));
		if numel(cur_bv_files)-1 == numel(session.data)
	    	%    disp('No new files')
		else
		    %    disp(['New files')
		    start_trial = numel(session.data)+1;
    		for ij = start_trial:numel(cur_bv_files)-1
        		f_name = fullfile(base_path_behaviour,cur_bv_files(ij).name);
       			session.data{ij} = load(f_name);
        		session.data{ij}.f_name = f_name;
				im_session.ref.behaviour_scim_trial_align = [im_session.ref.behaviour_scim_trial_align, ij];
    		end
	    	parse_session_data(start_trial,[]);
			set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(session.data))]);
		end
	num_behaviour = numel(session.data);
else
	num_behaviour = Inf;
end


num_match = min(num_behaviour,numel(cur_files));

if num_match > num_old_files
  %  disp('New files')
	%im_session.basic_info.cur_files = cur_files(1:num_match);
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