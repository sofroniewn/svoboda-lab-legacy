function register_directory_fast(trial_num,handles)

global im_session;
data_dir = im_session.basic_info.data_dir;
save_registered_on = get(handles.checkbox_save_aligned,'Value');
overwrite = get(handles.checkbox_overwrite,'Value');
behaviour_on = get(handles.checkbox_behaviour,'Value');
save_text_on = get(handles.checkbox_save_text,'Value');
analyze_chan = str2double(get(handles.edit_analyze_chan,'String'));
down_sample = str2double(get(handles.edit_downsample,'String'));

num_planes = im_session.ref.im_props.numPlanes;
num_chan = im_session.ref.im_props.nchans;
text_dir = handles.text_path;

% Go through new files
cur_file = fullfile(data_dir,'raw',im_session.basic_info.cur_files(trial_num).name);
trial_name = cur_file(end-6:end-4);
[pathstr, base_name, ext] = fileparts(cur_file);

% define summary data name
replace_start = strfind(base_name,'main');
replace_end = replace_start+4;
trial_str = base_name(replace_end:end);
base_name = base_name(1:replace_start-1);

type_name = 'summary';
file_name = [base_name type_name trial_str];
summary_file_name = fullfile(data_dir,type_name,[file_name '.mat']);


% if overwrite is off and summary file exists load it in
if overwrite ~= 1 && exist(summary_file_name) == 2
    load(summary_file_name,'im_summary');
    im_shifted = [];
else % Otherwise register file
    %display('Loading image')
    opt.data_type = 'uint16';
    [im_raw improps] = load_image_fast(cur_file,opt);
    
    % register files
    [im_shifted shifts] = register_file(im_raw,im_session.ref);
    
    % summarize images
    im_summary = sumarize_images(improps,im_raw,im_shifted,shifts,trial_num);
    
    % save summary data
    save(summary_file_name,'im_summary');
end

    im_session.reg.nFrames = cat(1,im_session.reg.nFrames, im_summary.props.num_frames);
    im_session.reg.startFrame = cat(1,im_session.reg.startFrame, im_summary.props.firstFrame);

% extract behaviour information if necessary
if behaviour_on
    trial_num_im_session = trial_num;
    trial_num_session = im_session.reg.behaviour_scim_trial_align(trial_num);
    fprintf('(scim_align) loading file %g \n',trial_num);
    %%% ALIGN
    global remove_first;
    [im_summary remove_first] = sync_behviour_scim_data(im_summary,trial_num_session,trial_num_im_session,remove_first);
    
    global session;
    trial_data_raw = session.data{trial_num_session};
    scim_frame_trig = im_summary.behaviour.align_vect;
    [trial_data data_variable_names] = parse_behaviour2im(trial_data_raw,trial_num_session,scim_frame_trig);

    type_name = 'behaviour';
    file_name = [base_name type_name trial_str];
    behaviour_file_name = fullfile(data_dir,type_name,[file_name '.mat']);
    if overwrite || exist(behaviour_file_name) ~= 2
        save(behaviour_file_name,'trial_data','data_variable_names','trial_num_session');
    end
else
    trial_data = [];
end


% save registered data
if (save_registered_on) && ~isempty(im_shifted)
    % create and save registered file data
    %save_registered_data(data_dir,base_name,trial_str,im_shifted,num_planes,num_chan,text_dir,down_sample,trial_data,save_registered_on,save_text_on);
    prev_frame_num = (im_summary.props.firstFrame - 1)/(num_planes*num_chan);
    save_registered_data_frame(text_dir,base_name,trial_str,prev_frame_num,im_shifted,num_planes,num_chan,trial_data);
end
end





