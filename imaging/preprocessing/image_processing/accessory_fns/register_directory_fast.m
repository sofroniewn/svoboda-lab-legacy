function register_directory_fast(start_trial,handles)

global im_session;

num_planes = im_session.ref.im_props.numPlanes;
num_chan = im_session.ref.im_props.nchans;
align_chan = im_session.ref.im_props.align_chan;
base_name = [im_session.basic_info.anm_str '_' im_session.basic_info.date_str '_' im_session.basic_info.run_str '_'];

overwrite = get(handles.checkbox_overwrite,'Value');

% Go through new files
cur_file = fullfile(im_session.basic_info.data_dir,im_session.basic_info.cur_files(start_trial).name);
trial_name = cur_file(end-6:end-4);
[pathstr, base_name, ext] = fileparts(cur_file);

% define summary name
replace_start = strfind(base_name,'main');
replace_end = replace_start+4;
type_name = 'summary';
file_name = [base_name(1:replace_start-1) type_name  base_name(replace_end:end)];
summary_file_name = fullfile(im_session.basic_info.data_dir,type_name,[file_name '.mat']);

% if overwrite is off and summary file exists load it in
if overwrite ~= 1 && exist(summary_file_name) == 2
    set(handles.text_status,'String','Status: loading existing')
    drawnow
    load(summary_file_name);
    im_raw = [];
    im_aligned = [];
else % Otherwise register file
    set(handles.text_status,'String','Status: registering')
    drawnow
    % register file
    [im_raw im_aligned im_summary] = register_file(cur_file,base_name,im_session.ref,align_chan,start_trial);
    % save summary data
    save(summary_file_name,'im_summary');
    % save registered data
    if get(handles.checkbox_save_aligned,'Value');
        set(handles.text_status,'String','Status: saving aligned')
        time_elapsed = toc;
        time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
        set(handles.text_time,'String',time_elapsed_str)
        drawnow
        type_name = 'registered';
        file_name = [base_name(1:replace_start-1) type_name  base_name(replace_end:end)];
        full_file_name = fullfile(im_session.basic_info.data_dir,type_name,[file_name '.mat']);
        save(full_file_name,'im_aligned');
    end
end

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
if get(handles.checkbox_behaviour,'Value')
    trial_num_im_session = start_trial;
    if get(handles.togglebutton_register,'value') == 0
        trial_num_session = im_session.behaviour_scim_trial_align(start_trial);
    else
        trial_num_session = start_trial;
    end
    fprintf('(scim_align) loading file %g \n',start_trial);
    %%% ALIGN
    global remove_first;
    [im_summary remove_first] = sync_behviour_scim_data(im_summary,trial_num_session,trial_num_im_session,remove_first);
    
    global session;
    trial_data_raw = session.data{trial_num_session};
    scim_frame_trig = im_summary.behaviour.align_vect;
    [trial_data data_variable_names] = parse_behaviour2im(trial_data_raw,trial_num_session,scim_frame_trig);
    type_name = 'parsed_behaviour';
    file_name = [base_name(1:replace_start-1) type_name  base_name(replace_end:end)];
    full_file_name = fullfile(im_session.basic_info.data_dir,type_name,[file_name '.mat']);
    save(full_file_name,'trial_data','data_variable_names');
else
    trial_data = [];
end

% save text file
if get(handles.checkbox_save_text,'Value');
    type_name = 'text';
    file_name = [base_name(1:replace_start-1) type_name  base_name(replace_end:end)];
    full_file_name = fullfile(im_session.basic_info.data_dir,type_name,[file_name '.txt']);
    % if file does not exist or overwrite is on remake it
    if exist(full_file_name) ~= 2 || overwrite
        % if im_algined is not already loaded - load it in
        if isempty(im_aligned)
            set(handles.text_status,'String','Status: loading aligned')
            drawnow
            type_name = 'registered';
            file_name = [base_name(1:replace_start-1) type_name  base_name(replace_end:end)];
            full_file_name_aligned = fullfile(im_session.basic_info.data_dir,type_name,[file_name '.mat']);
            load(full_file_name_aligned);
        end
        % now do the saving of the text
        set(handles.text_status,'String','Status: saving text')
        time_elapsed = toc;
        time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
        set(handles.text_time,'String',time_elapsed_str)
        drawnow
        analyze_chan = str2double(get(handles.edit_analyze_chan,'String'));
        save_im2text(im_aligned,trial_data,analyze_chan,full_file_name,1);
    end
end

set(handles.text_status,'String','Status: waiting')
end



