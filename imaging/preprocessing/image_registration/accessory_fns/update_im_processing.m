function update_im_processing(obj,event,handles)

% Check number of imaging files
global im_session;
cur_files = dir(fullfile(im_session.basic_info.data_dir,'*_main_*.tif'));
if numel(cur_files) > numel(im_session.basic_info.cur_files)
    im_session.basic_info.cur_files = cur_files;
    set(handles.text_imaging_trials,'String',['Imaging trials ' num2str(numel(cur_files))]);
end

% extract behaviour information if necessary
if get(handles.checkbox_behaviour,'Value') == 1
    global session;
    if isempty(session.data)
        cur_rig_file = dir(fullfile(handles.base_path,'behaviour','*_rig_config.mat'));
        if numel(cur_rig_file)>0
            try
                set(handles.text_status,'String','Status: loading behaviour')
                drawnow
                base_path_behaviour = fullfile(handles.base_path, 'behaviour');
                session = load_session_data(base_path_behaviour);
                session = parse_session_data(1,session);
                % match scim behaviour trial numbers (assume one to one)
                im_session.reg.behaviour_scim_trial_align = [1:numel(session.data)];
                % initialize global variables for scim alignment
                global remove_first;
                remove_first = 0;
                set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(session.data))]);
            catch
                im_session.reg.behaviour_scim_trial_align = [];
                session = [];
                session.data = [];
            end
        end
        num_behaviour = numel(session.data);
    else
        base_path_behaviour = fullfile(handles.base_path, 'behaviour');
        cur_bv_files = dir(fullfile(base_path_behaviour,'*_trial_*.mat'));
        if numel(cur_bv_files)-1 == numel(session.data)
            %    	disp('No new files')
        else
            %	    disp('New files')
            start_trial = numel(session.data)+1;
            for ij = start_trial:numel(cur_bv_files)-1
                f_name = fullfile(base_path_behaviour,cur_bv_files(ij).name);
                try 
                    trial_mat_names = [];
                    trial_matrix = [];
                    trial_num = [];
                    load(f_name);
                    if isempty(trial_mat_names) || isempty(trial_matrix) || isempty(trial_num)
                        return
                    end
                catch
                    return
                end
                session.data{ij}.trial_mat_names = trial_mat_names;
                session.data{ij}.trial_matrix = trial_matrix;
                session.data{ij}.trial_num = trial_num;
                session.data{ij}.f_name = f_name;
                im_session.reg.behaviour_scim_trial_align = [im_session.reg.behaviour_scim_trial_align, ij];
            end
            parse_session_data(start_trial,[]);
            set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(session.data))]);
        end
        num_behaviour = numel(session.data);
    end
else
    num_behaviour = Inf;
end

num_old_files = length(im_session.reg.nFrames);
num_match = min(num_behaviour,numel(cur_files)-1);

for trial_num = num_old_files+1:num_match
    drawnow
    if ~get(handles.togglebutton_register,'Value')
        return
    end
    time_elapsed = toc;
    time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
    set(handles.text_time,'String',time_elapsed_str)
    set(handles.text_status,'String','Status: registering')
    drawnow
    register_directory_fast(trial_num,handles)
    set(handles.text_registered_trials,'String',['Registered trials ' num2str(trial_num)])
end
time_elapsed = toc;
time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
set(handles.text_time,'String',time_elapsed_str)
set(handles.text_status,'String','Status: waiting')
drawnow

end