function update_image_viewer(obj,event,handles)

% Check imaging directory
global im_session;
cur_files = dir(fullfile(im_session.basic_info.data_dir,'*_main_*.tif'));
if numel(cur_files) <= numel(im_session.basic_info.cur_files)
%    	disp('No new files')
else
%	    disp('New files')	
	im_session.basic_info.cur_files = cur_files;
	set(handles.text_imaging_trials,'String',['Imaging trials ' num2str(numel(cur_files))]);
end

% Check behaviour directory
global session;
base_path_behaviour = fullfile(handles.base_path, 'behaviour');
cur_bv_files = dir(fullfile(base_path_behaviour,'*_trial_*.mat'));
if numel(cur_bv_files)-1 <= numel(session.data)
%    	disp('No new files')
else
%	    disp('New files')
    start_trial = numel(session.data)+1;
	for ij = start_trial:numel(cur_bv_files)-1
   		f_name = fullfile(base_path_behaviour,cur_bv_files(ij).name);
  		session.data{ij} = load(f_name);
    	session.data{ij}.f_name = f_name;
		im_session.behaviour_scim_trial_align = [im_session.behaviour_scim_trial_align, ij];
   	end
    parse_session_data(start_trial,[]);
	set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(session.data))]);
end


% Check registered directory
cur_files_reg = dir(fullfile(im_session.basic_info.data_dir,'summary','*_summary_*.mat'));
if isfield(im_session,'reg')
	num_old_files = length(im_session.reg.nFrames);
else
	num_old_files = 0;
end


% Load in im summary
for ij = num_old_files + 1: numel(cur_files_reg)
	cur_file = fullfile(im_session.basic_info.data_dir,im_session.basic_info.cur_files(ij).name);
	trial_name = cur_file(end-6:end-4);
	[pathstr, base_name, ext] = fileparts(cur_file);
	
	% define summary name
	replace_start = strfind(base_name,'main');
	replace_end = replace_start+4;
	type_name = 'summary';
	file_name = [base_name(1:replace_start-1) type_name  base_name(replace_end:end)];
	summary_file_name = fullfile(im_session.basic_info.data_dir,type_name,[file_name '.mat']);
	
	try
	load(summary_file_name);
	catch
		display('Failed to read new summary')
		return
	end
	num_planes = im_session.ref.im_props.numPlanes;
	num_chan = im_session.ref.im_props.nchans;

	% update im_session	
	tmp_raw_mean = zeros(im_session.ref.im_props.height,im_session.ref.im_props.width,num_planes,num_chan,1,'uint16');
	tmp_align_mean = zeros(im_session.ref.im_props.height,im_session.ref.im_props.width,num_planes,num_chan,1,'uint16');
	for ih = 1:num_chan
		for ik = 1:num_planes
			% extract mean images and summary data for each plane 
			tmp_raw_mean(:,:,ik,ih,1) = im_summary.mean_raw{ik,ih};
			tmp_align_mean(:,:,ik,ih,1) = im_summary.mean_aligned{ik,ih};
		end
	end
	im_session.reg.nFrames = cat(1,im_session.reg.nFrames, im_summary.props.num_frames);
	im_session.reg.startFrame = cat(1,im_session.reg.startFrame, im_summary.props.firstFrame);
	im_session.reg.raw_mean = cat(5,im_session.reg.raw_mean, tmp_raw_mean);
	im_session.reg.align_mean = cat(5,im_session.reg.align_mean, tmp_align_mean);
	
	% extract behaviour information if necessary
	%if behaviour_val == 1
    %	trial_num_im_session = ij;
	%	if get(handles.togglebutton_online_mode,'value') == 0
	%		trial_num_session = im_session.ref.behaviour_scim_trial_align(ij);
	%	else
	%		trial_num_session = ij;
	%	end
	%	fprintf('(scim_align) loading file %g/%g \n',ij,num_files);
    %	%%% ALIGN
	%	global remove_first;
	%	[im_summary remove_first] = sync_behviour_scim_data(im_summary,trial_num_session,trial_num_im_session,remove_first);
	%
	%	global session;
	%	trial_data_raw = session.data{trial_num_session};
	%	scim_frame_trig = im_summary.behaviour.align_vect;
	%	[trial_data data_variable_names] = parse_behaviour2im(trial_data_raw,trial_num_session,scim_frame_trig);
  	%	type_name = 'parsed_behaviour';
	%	file_name = [base_name(1:replace_start-1) type_name  base_name(replace_end:end)];
	%	full_file_name = fullfile(im_session.basic_info.data_dir,type_name,[file_name '.mat']);	
	%	save(full_file_name,'trial_data','data_variable_names');
	%else
	%	trial_data = [];
  	%end

  	if numel(cur_files_reg) > 0
		set(handles.slider_trial_num,'max',ij)
		set(handles.slider_trial_num,'SliderStep',[1/(ij+1) 1/(ij+1)])
	end

	update_im = get(handles.checkbox_plot_images,'value');
	if update_im == 1 && numel(cur_files_reg) > 0
		set(handles.edit_trial_num,'String',num2str(ij));
		set(handles.slider_trial_num,'Value',ij);
		im_data = plot_im_gui(handles,0);
		im_plot = get(handles.axes_images,'Children');
		set(im_plot,'CData',im_data)
	end

    time_elapsed = toc;
    time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
    set(handles.text_time,'String',time_elapsed_str)
	set(handles.text_registered_trials,'String',['Registered trials ' num2str(ij)]);
	drawnow
end

   time_elapsed = toc;
   time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
   set(handles.text_time,'String',time_elapsed_str)

end