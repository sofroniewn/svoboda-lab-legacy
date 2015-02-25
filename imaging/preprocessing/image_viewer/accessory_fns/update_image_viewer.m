function update_image_viewer(obj,event,handles)

% Check spark output directory
update_plot = load_spark_maps_streaming(handles.output_dir);
% Check imaging directory
global im_session;

if ~isempty(im_session.spark_output.streaming.stats{1}{1,1})
    num_spark_files = size(im_session.spark_output.streaming.stats{1}{1,1},3);
    set(handles.text_streamed_files,'String',['Streamed ' num2str(num_spark_files) ' / ' num2str(max(im_session.spark_output.streaming.tot_num_files))])
    if handles.trial_slider_spark
        set(handles.slider_trial_num,'max',num_spark_files)
        set(handles.slider_trial_num,'SliderStep',[1/(num_spark_files+1) 1/(num_spark_files+1)])
        update_im = get(handles.checkbox_plot_images,'value');
        if update_im == 1 && update_plot
            set(handles.edit_trial_num,'String',num2str(num_spark_files));
            set(handles.slider_trial_num,'Value',num_spark_files);
        end
    end
end

if update_plot
    plot_im_gui(handles,0);
end

cur_files = dir(fullfile(im_session.basic_info.data_dir,'raw','*_main_*.tif'));
if numel(cur_files) <= numel(im_session.basic_info.cur_files)
    %    	disp('No new files')
else
    %	    disp('New files')
    im_session.basic_info.cur_files = cur_files;
    set(handles.text_imaging_trials,'String',['Imaging trials ' num2str(numel(cur_files))]);
end

% Check behaviour directory
cur_file = dir(fullfile(handles.base_path,'behaviour','*_rig_config.mat'));
if numel(cur_file)>0
    cur_bv_files = dir(fullfile(handles.base_path,'behaviour','*_trial_*.mat'));
    val = get(handles.text_num_behaviour,'UserData');
    if numel(cur_bv_files)-1 > val
        set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(cur_bv_files)-1)]);
        set(handles.text_num_behaviour,'UserData',numel(cur_bv_files)-1)
    end
end

% Check registered directory
cur_files_reg = dir(fullfile(im_session.basic_info.data_dir,'summary','*_summary_*.mat'));
if isfield(im_session,'reg')
    num_old_files = length(im_session.reg.nFrames);
else
    num_old_files = 0;
end

num_planes = im_session.ref.im_props.numPlanes;
num_chan = im_session.ref.im_props.nchans;

cur_size = length(im_session.reg.nFrames);
target_size = numel(cur_files_reg);
add_size = target_size - cur_size;
if add_size > 0
    im_session.reg.nFrames = cat(2,im_session.reg.nFrames, zeros(1,add_size));
    im_session.reg.startFrame = cat(2,im_session.reg.startFrame, zeros(1,add_size));
    im_session.reg.raw_mean = cat(5,im_session.reg.raw_mean, zeros(im_session.ref.im_props.height,im_session.ref.im_props.width,num_planes,num_chan,add_size,'uint16'));
    im_session.reg.align_mean = cat(5,im_session.reg.align_mean, zeros(im_session.ref.im_props.height,im_session.ref.im_props.width,num_planes,num_chan,add_size,'uint16'));
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
        if ~exist('im_summary')
            %   display('Failed to read new summary')
            im_session.reg.nFrames(ij:end) = [];
            im_session.reg.startFrame(ij:end) = [];
            im_session.reg.raw_mean(:,:,:,:,ij:end) = [];
            im_session.reg.align_mean(:,:,:,:,ij:end) = [];
            return
        end
    catch
        %	display('Failed to read new summary')
        im_session.reg.nFrames(ij:end) = [];
        im_session.reg.startFrame(ij:end) = [];
        im_session.reg.raw_mean(:,:,:,:,ij:end) = [];
        im_session.reg.align_mean(:,:,:,:,ij:end) = [];
        return
    end
    
    % update im_session
    for ih = 1:num_chan
        for ik = 1:num_planes
            % extract mean images and summary data for each plane
            im_session.reg.raw_mean(:,:,ik,ih,ij) = im_summary.mean_raw{ik,ih};
            im_session.reg.align_mean(:,:,ik,ih,ij) = im_summary.mean_aligned{ik,ih};
        end
    end
    im_session.reg.nFrames(ij) = im_summary.props.num_frames;
    im_session.reg.startFrame(ij) = im_summary.props.firstFrame;
    
    % extract behaviour information if necessary
    %if behaviour_val == 1
    %	trial_num_im_session = ij;
    %	if get(handles.togglebutton_online_mode,'value') == 0
    %		trial_num_session = im_session.reg.behaviour_scim_trial_align(ij);
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
    

    if numel(cur_files_reg) > 0 && ~handles.trial_slider_spark
        set(handles.slider_trial_num,'max',ij)
        set(handles.slider_trial_num,'SliderStep',[1/(ij+1) 1/(ij+1)])
    end
    
    update_im = get(handles.checkbox_plot_images,'value');
    if update_im == 1 && numel(cur_files_reg) > 0 && ~handles.trial_slider_spark
        set(handles.edit_trial_num,'String',num2str(ij));
        set(handles.slider_trial_num,'Value',ij);
        plot_im_gui(handles,0);
        plot_trial_ts(ij);
    end
    
    time_elapsed = toc;
    time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
    set(handles.text_time,'String',time_elapsed_str)
    set(handles.text_registered_trials,'String',['Registered trials ' num2str(ij)]);
    drawnow
end

if add_size > 0
    for ih = 1:num_chan
        for ik = 1:num_planes
            % extract mean images and summary data for each plane
            im_session.ref.session_mean{ik,ih} = mean(im_session.reg.align_mean(:,:,ik,ih,:),5);
            im_session.ref.session_max_proj{ik,ih} = max(im_session.reg.align_mean(:,:,ik,ih,:),[],5);
        end
    end
    session_mean_images = im_session.ref.session_mean;
    session_max_proj_images = im_session.ref.session_max_proj;
    save(fullfile(im_session.basic_info.data_dir,'ref_means.mat'),'session_mean_images','session_max_proj_images');
end

time_elapsed = toc;
time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
set(handles.text_time,'String',time_elapsed_str)

end