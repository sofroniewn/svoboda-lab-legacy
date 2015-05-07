function update_trial_plot(obj,event,handles)

global session;

cur_files = dir(fullfile(handles.data_dir,'*_trial_*.mat'));
if numel(cur_files)-1 == numel(session.data)
    %    disp('No new files')
else
    %    disp(['New files')
    start_trial = numel(session.data)+1;
    for ij = start_trial:numel(cur_files)-1
        f_name = fullfile(handles.data_dir,cur_files(ij).name);
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
    end
    parse_session_data(start_trial,[]);
    
    plot_options = get(handles.uitable_plotting,'Data');
    keep_trial_types = find(cell2mat(plot_options(:,1)));
    col_cell = plot_options(:,2);
    col_mat = zeros(numel(col_cell),3);
    for ik = 1:numel(col_cell)
        col_mat(ik,:) = eval(col_cell{ik});
    end
    
    
    trial_info_dat = extract_trial_info;
    set(handles.uitable_trial_info,'Data',trial_info_dat);
    
    keep_completed = get(handles.checkbox_completed,'value');
    if keep_completed == 1
        keep_inds = find(ismember(session.trial_info.inds(start_trial:numel(cur_files)-1),keep_trial_types) & session.trial_info.completed(start_trial:numel(cur_files)-1) == 1) + start_trial-1;
    else
        keep_inds = find(ismember(session.trial_info.inds(start_trial:numel(cur_files)-1),keep_trial_types)) + start_trial-1;
    end
    
    if isempty(keep_inds) ~= 1
        plot_names =  get(handles.popupmenu_ax1,'string');
        plot_val =  get(handles.popupmenu_ax1,'value');
        plot_function = plot_names{plot_val};
        plot_str = [plot_function(1:end-2) '(handles.axes1,session,0,[],keep_inds,col_mat)'];
        eval(plot_str);
        
        plot_names =  get(handles.popupmenu_ax2,'string');
        plot_val =  get(handles.popupmenu_ax2,'value');
        plot_function = plot_names{plot_val};
        plot_str = [plot_function(1:end-2) '(handles.axes2,session,0,[],keep_inds,col_mat)'];
        eval(plot_str);
        
        frac_str = get(handles.edit_range_ax3,'string');
        frac_range = cell2mat(eval(frac_str));
        plot_names =  get(handles.popupmenu_ax3,'string');
        plot_val =  get(handles.popupmenu_ax3,'value');
        plot_function = plot_names{plot_val};
        plot_str = [plot_function(1:end-2) '(handles.axes3,session,0,frac_range,keep_trial_types,keep_inds,col_mat)'];
        eval(plot_str);
        
        frac_str = get(handles.edit_range_ax4,'string');
        frac_range = cell2mat(eval(frac_str));
        plot_names =  get(handles.popupmenu_ax4,'string');
        plot_val =  get(handles.popupmenu_ax4,'value');
        plot_function = plot_names{plot_val};
        plot_str = [plot_function(1:end-2) '(handles.axes4,session,0,frac_range,keep_trial_types,keep_inds,col_mat)'];
        eval(plot_str);
        
        frac_str = get(handles.edit_range_ax5,'string');
        frac_range = cell2mat(eval(frac_str));
        plot_names =  get(handles.popupmenu_ax5,'string');
        plot_val =  get(handles.popupmenu_ax5,'value');
        plot_function = plot_names{plot_val};
        plot_str = [plot_function(1:end-2) '(handles.axes5,session,0,frac_range,keep_trial_types,keep_inds,col_mat)'];
        eval(plot_str);  
    end
    
    online_in_red = get(handles.checkbox_last_trial,'value');
    if online_in_red == 1;
        plot_list = get(handles.axes1,'Children');
        cur_length = length(plot_list);
        old_data = get(handles.axes1,'userdata');
        if isempty(old_data) ~= 1
            set(plot_list(cur_length - old_data.length + 1),'Color',old_data.col);
        end
        cur_col = get(plot_list(1),'Color');
        cur_data.length = cur_length;
        cur_data.col = cur_col;
        set(handles.axes1,'userdata',cur_data);
        if isempty(keep_inds) ~= 1
            if keep_inds(end) == numel(session.data)
                set(plot_list(1),'Color',[1 0 0]);
            end
        end
        
        plot_list = get(handles.axes2,'Children');
        cur_length = length(plot_list);
        old_data = get(handles.axes2,'userdata');
        if isempty(old_data) ~= 1
            set(plot_list(cur_length - old_data.length + 1),'Color',old_data.col);
        end
        cur_col = get(plot_list(1),'Color');
        cur_data.length = cur_length;
        cur_data.col = cur_col;
        set(handles.axes2,'userdata',cur_data)
        if isempty(keep_inds) ~= 1
            if keep_inds(end) == numel(session.data)
                set(plot_list(1),'Color',[1 0 0]);
            end
        end
    end
    
end

time_elapsed = toc;
time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
set(handles.text_elapsed_time,'String',time_elapsed_str);



