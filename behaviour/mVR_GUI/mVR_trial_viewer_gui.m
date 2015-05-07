function varargout = mVR_trial_viewer_gui(varargin)
% MVR_TRIAL_VIEWER_GUI MATLAB code for mVR_trial_viewer_gui.fig
%      MVR_TRIAL_VIEWER_GUI, by itself, creates a new MVR_TRIAL_VIEWER_GUI or raises the existing
%      singleton*.
%
%      H = MVR_TRIAL_VIEWER_GUI returns the handle to a new MVR_TRIAL_VIEWER_GUI or the handle to
%      the existing singleton*.
%
%      MVR_TRIAL_VIEWER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MVR_TRIAL_VIEWER_GUI.M with the given input arguments.
%
%      MVR_TRIAL_VIEWER_GUI('Property','Value',...) creates a new MVR_TRIAL_VIEWER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mVR_trial_viewer_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mVR_trial_viewer_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mVR_trial_viewer_gui

% Last Modified by GUIDE v2.5 01-May-2015 16:31:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mVR_trial_viewer_gui_OpeningFcn, ...
    'gui_OutputFcn',  @mVR_trial_viewer_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mVR_trial_viewer_gui is made visible.
function mVR_trial_viewer_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mVR_trial_viewer_gui (see VARARGIN)

% Choose default command line output for mVR_trial_viewer_gui
handles.output = hObject;

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);
handles.pathstr = pathstr;

p = path;
start_str = strfind(p,'DATA');
if ~isempty(start_str)
start_file = strfind(p,':');
start_file_ind= find(start_file < start_str,1,'last');
if isempty(start_file_ind) == 1
    start_ind = 1;
    end_ind = start_file(1)-1;
else
    start_ind = start_file(start_file_ind) + 1;
    if start_file_ind < length(start_file)
    end_ind = start_file(start_file_ind+1)-1;
    else
    end_ind = length(p);
    end
end
handles.datastr = p(start_ind:end_ind);
else
handles.datastr = pwd;    
end

% set(handles.uitable1,'Data',[]);
% set(handles.uitable_plotting,'Data',[]);
% set(handles.uitable_trial_info,'Data',[]);

col_names = properties(branch);
col_names = strrep(col_names, '_', ' ');
set(handles.uitable_maze_param,'ColumnName',col_names);
set(handles.uitable_maze_param,'ColumnEditable',true(1,numel(col_names)))
ColumnFormat = repmat({'numeric'},1,numel(col_names));
%ColumnFormat{find(strcmp(col_names,'reward'))} = 'char';
set(handles.uitable_maze_param,'ColumnFormat',ColumnFormat)
set(handles.uitable_maze_param,'Data',[]);
set(handles.listbox_trajectories,'userdata',[]);

cla(handles.axes_maze)
set(handles.axes_maze,'Color',[0 0 0])
set(handles.axes_maze,'xtick',[])
set(handles.axes_maze,'ytick',[])

cla(handles.axes_hist)
cla(handles.axes_perf)


% plot_list = dir(fullfile(handles.pathstr,'accessory_fns','plot_functions','time_series_plots','*.m'));
% plot_names = cell(numel(plot_list),1);
% for ij = 1:numel(plot_list)
%     plot_names{ij} = plot_list(ij).name;
% end
% set(handles.popupmenu_ax1,'string',plot_names)
% set(handles.popupmenu_ax1,'value',4)
% set(handles.popupmenu_ax2,'string',plot_names)

% plot_list = dir(fullfile(handles.pathstr,'accessory_fns','plot_functions','histogram_plots','*.m'));
% plot_names = cell(numel(plot_list),1);
% for ij = 1:numel(plot_list)
%     plot_names{ij} = plot_list(ij).name;
% end
% set(handles.popupmenu_ax_hist,'string',plot_names)
% set(handles.popupmenu_ax4,'string',plot_names)
% set(handles.popupmenu_ax4,'value',5)

% plot_list = dir(fullfile(handles.pathstr,'accessory_fns','plot_functions','bar_chart_plots','*.m'));
% plot_names = cell(numel(plot_list),1);
% for ij = 1:numel(plot_list)
%     plot_names{ij} = plot_list(ij).name;
% end
% set(handles.popupmenu_ax_perf,'string',plot_names)

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes mVR_trial_viewer_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mVR_trial_viewer_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_set_data_dir.
function pushbutton_set_data_dir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_set_data_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(handles.togglebutton_online_mode,'Value');
if value == 1
    set(handles.togglebutton_online_mode,'Value',0)
    togglebutton_online_mode_Callback(handles.togglebutton_online_mode, eventdata, handles)
end

set(handles.togglebutton_online_mode,'Enable','off')

start_path = handles.datastr;
folder_name = uigetdir(start_path);

if folder_name ~= 0
    cla(handles.axes_maze)
    cla(handles.axes_hist)
    cla(handles.axes_perf)

    % Load in data
    handles.data_dir = fullfile(folder_name,'behaviour');
    clear global session
    global session;
    session = load_session_data_mVR(handles.data_dir);
    handles.maze_config = session.maze_config;

    session = parse_session_data_mVR(1,[]);
    
    set(handles.text_anm,'Enable','on')
    set(handles.text_date,'Enable','on')
    set(handles.text_run_num,'Enable','on')
    
    set(handles.text_anm,'String',session.basic_info.anm_str)
    set(handles.text_date,'String',session.basic_info.date_str)
    set(handles.text_run_num,'String',session.basic_info.run_str)

    % setup fixed params associated with maze configs
    set(handles.listbox_mazes,'Enable','on');
    set(handles.checkbox_show_branch_ids,'Enable','on');
    set(handles.text_list_mazes,'Enable','inactive');
    set(handles.uitable_maze_param,'Enable','inactive');
    set(handles.text_start_branch,'Enable','inactive');
    set(handles.edit_start_branch,'Enable','inactive');
    set(handles.text_ids,'Enable','inactive');
    set(handles.edit_maze_ids,'Enable','inactive');
    set(handles.text_repeats,'Enable','inactive');
    set(handles.edit_repeats,'Enable','inactive');
    set(handles.radiobutton_random_order,'Enable','inactive');
    set(handles.radiobutton_repeat,'Enable','inactive');
    set(handles.text_trajectories,'Enable','on');
    set(handles.listbox_trajectories,'Enable','on');

    set(handles.edit_trial_range,'Enable','on');
    set(handles.text_trial_range,'Enable','on');
    set(handles.checkbox_last_trial,'Enable','on');
    set(handles.checkbox_rand_col,'Enable','on');


    set(handles.listbox_mazes,'String',session.array.name);
    set(handles.listbox_mazes,'UserData',session.array.dat);
    set(handles.listbox_mazes,'Value',1);
    set(handles.edit_start_branch,'UserData',session.array.start);
    if session.trial_vars.random == 1
        set(handles.radiobutton_random_order,'value',1)
        set(handles.radiobutton_repeat,'value',0)
    elseif session.trial_vars.random == 2
        set(handles.radiobutton_random_order,'value',0)
        set(handles.radiobutton_repeat,'value',1)
    else
        set(handles.radiobutton_random_order,'value',0)
        set(handles.radiobutton_repeat,'value',0)        
    end
    set(handles.edit_repeats,'string',session.trial_vars.maze_repeats)
    set(handles.edit_maze_ids,'string',session.trial_vars.maze_ids)
        
    set(handles.uitable_trial_info,'Enable','on');
    set(handles.pushbutton_plot_data,'Enable','on')
    set(handles.popupmenu_ax_hist,'Enable','on')
    set(handles.popupmenu_ax_perf,'Enable','on')
    set(handles.edit_range_ax_hist,'Enable','on')
    set(handles.edit_range_ax_perf,'Enable','on')
    % set(handles.edit_save_figs,'Enable','on')
    % set(handles.pushbutton_save_figs,'Enable','on')
    % set(handles.checkbox_last_trial,'Enable','on')
    % set(handles.checkbox_completed,'Enable','on')
    % set(handles.edit_trial_range,'Enable','on')
    % set(handles.text_trial_range,'Enable','on')
    

    listbox_mazes_Callback(hObject, eventdata, handles);       
    %pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles)
    
else
end


guidata(hObject, handles);


% --- Executes on button press in pushbutton_plot_data.
function pushbutton_plot_data_Callback(hObject, eventdata, handles,varargin)
% hObject    handle to pushbutton_plot_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(handles.togglebutton_online_mode,'Value');
if value == 1
    set(handles.togglebutton_online_mode,'Value',0)
    togglebutton_online_mode_Callback(handles.togglebutton_online_mode, eventdata, handles)
end

global session;

pushbutton_add_plot_options_Callback(handles.pushbutton_add_plot_options, eventdata, handles)

plot_options = get(handles.uitable_plotting,'Data');
keep_trial_types = find(cell2mat(plot_options(:,1)));
keep_inds = find(ismember(session.trial_info.inds,keep_trial_types));
col_cell = plot_options(:,2);
col_mat = zeros(numel(col_cell),3);
for ij = 1:numel(col_cell)
    col_mat(ij,:) = eval(col_cell{ij});
end

trial_info_dat = extract_trial_info;
set(handles.uitable_trial_info,'Data',trial_info_dat);

if nargin <= 3
    axes_use = [1 2 4 3 5];
else
    axes_use = varargin{1};
end

for ik = 1:length(axes_use)
    eval(['cla(handles.axes' num2str(axes_use(ik)) ')']);
    eval(['hold(handles.axes' num2str(axes_use(ik)) ',''on'')']);
end

drawnow

% remove trial indices outside range
keep_range_str = get(handles.edit_trial_range,'string');
keep_range = cell2mat(eval(keep_range_str));
keep_inds = keep_inds(keep_inds>=keep_range(1) & keep_inds<=keep_range(2));

% remove non completed trials
keep_completed = get(handles.checkbox_completed,'value');
if keep_completed == 1
    keep_inds = intersect(find(session.trial_info.completed == 1),keep_inds);
end

for ik = 1:length(axes_use)
    plot_names =  get(eval(['handles.popupmenu_ax' num2str(axes_use(ik))]),'string');
    plot_val =  get(eval(['handles.popupmenu_ax' num2str(axes_use(ik))]),'value');
    plot_function = plot_names{plot_val};
    if axes_use(ik) == 1 || axes_use(ik) == 2
        plot_str = [plot_function(1:end-2) '(handles.axes' num2str(axes_use(ik)) ',session,1,keep_trial_types,keep_inds,col_mat);'];
        eval(plot_str);
    else
        frac_str = get(eval(['handles.edit_range_ax' num2str(axes_use(ik))]),'string');
        frac_range = cell2mat(eval(frac_str));
        plot_str = [plot_function(1:end-2) '(handles.axes' num2str(axes_use(ik)) ',session,1,frac_range,keep_trial_types,keep_inds,col_mat);'];
        eval(plot_str);
    end
    
end

set(handles.axes2,'userdata',[]);
set(handles.axes_maze,'userdata',[]);
set(handles.togglebutton_online_mode,'Enable','on')
guidata(hObject, handles);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function edit_save_figs_Callback(hObject, eventdata, handles)
% hObject    handle to edit_save_figs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_save_figs as text
%        str2double(get(hObject,'String')) returns contents of edit_save_figs as a double


% --- Executes during object creation, after setting all properties.
function edit_save_figs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_save_figs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_save_figs.
function pushbutton_save_figs_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_figs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save figure

global session;
[pathstr, name, ext] = fileparts(session.basic_info.data_dir);
fig_folder = fullfile(pathstr,'figures');
fig_fname = get(handles.edit_save_figs,'string');
if exist(fig_folder,'dir') ~= 7
    mkdir(fig_folder);
end
date_str = session.basic_info.date_str;
date_str(strfind(date_str,'_')) = 'x';
fig_fname = fullfile(fig_folder,[session.basic_info.anm_str '_' date_str '_' session.basic_info.run_str '_' fig_fname]);
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'PaperOrientation', 'portrait');
set(gcf, 'Renderer', 'painters');
print('-depsc', fig_fname,'-r72');

% --- Executes on selection change in popupmenu_ax2.
function popupmenu_ax2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ax2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ax2
pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 2)


% --- Executes during object creation, after setting all properties.
function popupmenu_ax2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_ax1.
function popupmenu_ax1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ax1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ax1
pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 1)


% --- Executes during object creation, after setting all properties.
function popupmenu_ax1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_ax_hist.
function popupmenu_ax_hist_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax_hist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 3)

% --- Executes during object creation, after setting all properties.
function popupmenu_ax_hist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax_hist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_ax4.
function popupmenu_ax4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 4)



% --- Executes during object creation, after setting all properties.
function popupmenu_ax4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_online_mode.
function togglebutton_online_mode_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_online_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_online_mode

value = get(hObject,'Value');

if value == 1
    tic;
    % Setup timer
    handles.obj_t = timer('TimerFcn',{@update_trial_plot,handles});
    set(handles.obj_t,'ExecutionMode','fixedRate');
    set(handles.obj_t,'Period', .5);
    set(handles.obj_t,'BusyMode','queue');
    set(handles.obj_t,'ErrorFcn',@(obj,event)disp('Timing Error'));
    set(handles.obj_t,'UserData',0);
    
    set(handles.text_elapsed_time,'Enable','on')
    set(handles.popupmenu_ax1,'Enable','off')
    set(handles.popupmenu_ax2,'Enable','off')
    set(handles.popupmenu_ax_hist,'Enable','off')
    set(handles.popupmenu_ax4,'Enable','off')
    set(handles.popupmenu_ax_perf,'Enable','off')
    set(handles.edit_range_ax_hist,'Enable','off')
    set(handles.edit_range_ax4,'Enable','off')
    set(handles.edit_range_ax_perf,'Enable','off')
    set(handles.pushbutton_plot_data,'Enable','off')
    set(handles.pushbutton_set_data_dir,'Enable','off')
    set(handles.uitable_plotting,'Enable','off')
    set(handles.popupmenu_plot_options,'Enable','off')
    set(handles.edit_plot_options_name,'Enable','off')
    set(handles.pushbutton_add_plot_options,'Enable','off')
    set(handles.edit_save_figs,'Enable','off')
    set(handles.pushbutton_save_figs,'Enable','off')
    set(handles.checkbox_last_trial,'Enable','off')
    set(handles.checkbox_completed,'Enable','off')
    set(handles.edit_trial_range,'Enable','off')
    set(handles.text_trial_range,'Enable','off')
    set(handles.pushbutton_trial_maker,'Enable','off')
    
    % Update handles structure
    guidata(hObject, handles);
    
    % Start Timer
    start(handles.obj_t)
    
else
    stop(handles.obj_t);
    delete(handles.obj_t);
    
    time_elapsed_str = sprintf('Time online %.1f s',0);
    set(handles.text_elapsed_time,'String',time_elapsed_str)
    set(handles.text_elapsed_time,'Enable','off')
    
    set(handles.popupmenu_ax1,'Enable','on')
    set(handles.popupmenu_ax2,'Enable','on')
    set(handles.popupmenu_ax_hist,'Enable','on')
    set(handles.popupmenu_ax4,'Enable','on')
    set(handles.popupmenu_ax_perf,'Enable','on')
    set(handles.edit_range_ax_hist,'Enable','on')
    set(handles.edit_range_ax4,'Enable','on')
    set(handles.edit_range_ax_perf,'Enable','on')
    set(handles.pushbutton_plot_data,'Enable','on')
    set(handles.pushbutton_set_data_dir,'Enable','on')
    set(handles.uitable_plotting,'Enable','on')
    set(handles.popupmenu_plot_options,'Enable','on')
    set(handles.edit_plot_options_name,'Enable','on')
    set(handles.pushbutton_add_plot_options,'Enable','on')
    set(handles.edit_save_figs,'Enable','on')
    set(handles.pushbutton_save_figs,'Enable','on')
    set(handles.checkbox_last_trial,'Enable','on')
    set(handles.checkbox_completed,'Enable','on')
    set(handles.edit_trial_range,'Enable','on')
    set(handles.text_trial_range,'Enable','on')
    set(handles.pushbutton_trial_maker,'Enable','on')
    
end



function edit_range_ax_hist_Callback(hObject, eventdata, handles)
% hObject    handle to edit_range_ax_hist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_range_ax_hist as text
%        str2double(get(hObject,'String')) returns contents of edit_range_ax_hist as a double
pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 3)


% --- Executes during object creation, after setting all properties.
function edit_range_ax_hist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_range_ax_hist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_range_ax4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_range_ax4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_range_ax4 as text
%        str2double(get(hObject,'String')) returns contents of edit_range_ax4 as a double
pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 4)


% --- Executes during object creation, after setting all properties.
function edit_range_ax4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_range_ax4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_last_trial.
function checkbox_last_trial_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_last_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_last_trial


% --- Executes on button press in checkbox_completed.
function checkbox_completed_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_completed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles)



function edit_trial_range_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trial_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trial_range as text
%        str2double(get(hObject,'String')) returns contents of edit_trial_range as a double
listbox_trajectories_Callback(handles.listbox_trajectories, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_trial_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trial_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_trial_maker.
function pushbutton_trial_maker_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_trial_maker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton_trial_maker
set(handles.uitable1,'Enable','on')
set(handles.save_trial,'Enable','on')
set(handles.load_trial,'Enable','on')
set(handles.add_row,'Enable','on')
set(handles.add_row_number,'Enable','on')
set(handles.remove_row,'Enable','on')
set(handles.remove_row_number,'Enable','on')
set(handles.radiobutton_laser_calibration,'Enable','on')
set(handles.random_trial_on,'Enable','on')
if get(handles.random_trial_on,'Value') ~= 1;
   set(handles.trial_repeat_label,'Enable','on');
   set(handles.trial_repeat_string,'Enable','on');
   set(handles.text_num_reps,'Enable','on');
   set(handles.edit_num_reps,'Enable','on');
end

cla(handles.axes_maze)
cla(handles.axes2)
cla(handles.axes_hist)
cla(handles.axes4)
cla(handles.axes_perf)

set(handles.uitable_trial_info,'Data',[]);
set(handles.uitable_trial_info,'Enable','off');
set(handles.togglebutton_online_mode,'Enable','off')
set(handles.pushbutton_plot_data,'Enable','off')
set(handles.popupmenu_ax1,'Enable','off')
set(handles.popupmenu_ax2,'Enable','off')
set(handles.popupmenu_ax_hist,'Enable','off')
set(handles.popupmenu_ax4,'Enable','off')
set(handles.popupmenu_ax_perf,'Enable','off')
set(handles.edit_range_ax_hist,'Enable','off')
set(handles.edit_range_ax4,'Enable','off')
set(handles.edit_range_ax_perf,'Enable','off')
set(handles.edit_save_figs,'Enable','off')
set(handles.pushbutton_save_figs,'Enable','off')
set(handles.checkbox_last_trial,'Enable','off')
set(handles.checkbox_completed,'Enable','off')
set(handles.edit_trial_range,'Enable','off')
set(handles.text_trial_range,'Enable','off')
set(handles.text_anm,'Enable','off')
set(handles.text_date,'Enable','off')
set(handles.text_run_num,'Enable','off')
set(handles.text_elapsed_time,'Enable','off')
set(handles.pushbutton_trial_maker,'Enable','off')



function edit_num_reps_Callback(hObject, eventdata, handles)
% hObject    handle to edit_num_reps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_num_reps as text
%        str2double(get(hObject,'String')) returns contents of edit_num_reps as a double


% --- Executes during object creation, after setting all properties.
function edit_num_reps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_num_reps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_ax_perf.
function popupmenu_ax_perf_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax_perf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ax_perf contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ax_perf
pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 5)


% --- Executes during object creation, after setting all properties.
function popupmenu_ax_perf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax_perf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_range_ax_perf_Callback(hObject, eventdata, handles)
% hObject    handle to edit_range_ax_perf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_range_ax_perf as text
%        str2double(get(hObject,'String')) returns contents of edit_range_ax_perf as a double
pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 5)


% --- Executes during object creation, after setting all properties.
function edit_range_ax_perf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_range_ax_perf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_show_branch_ids.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_show_branch_ids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_show_branch_ids



function edit_start_branch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_start_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_start_branch as text
%        str2double(get(hObject,'String')) returns contents of edit_start_branch as a double


% --- Executes during object creation, after setting all properties.
function edit_start_branch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_start_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_repeats_Callback(hObject, eventdata, handles)
% hObject    handle to edit_repeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_repeats as text
%        str2double(get(hObject,'String')) returns contents of edit_repeats as a double


% --- Executes during object creation, after setting all properties.
function edit_repeats_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_repeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_maze_ids_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maze_ids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maze_ids as text
%        str2double(get(hObject,'String')) returns contents of edit_maze_ids as a double


% --- Executes during object creation, after setting all properties.
function edit_maze_ids_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maze_ids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_random_order.
function radiobutton_random_order_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_random_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_random_order


% --- Executes on selection change in listbox_list_mazes.
function listbox_mazes_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_list_mazes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_list_mazes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_list_mazes

value = get(handles.listbox_mazes,'Value');
maze_names = get(handles.listbox_mazes,'String');
dat_array = get(handles.listbox_mazes,'UserData');
start_branch_array = get(handles.edit_start_branch,'UserData');

if value <= numel(dat_array)
        set(handles.uitable_maze_param,'Data',dat_array{value});
        set(handles.edit_start_branch,'String',start_branch_array{value});
        global session;
        maze = session.array.maze{value};
        show_branch_labels = get(handles.checkbox_show_branch_ids,'value');
        axes(handles.axes_maze);
        cla(handles.axes_maze);
        plot_maze(handles.axes_maze,maze,show_branch_labels,1,1);
        listbox_trajectories_Callback(handles.listbox_trajectories, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function listbox_mazes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_list_mazes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_repeat.
function radiobutton_repeat_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_repeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_repeat

% --- Executes on button press in checkbox_show_branch_ids.
function checkbox_show_branch_ids_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_show_branch_ids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_show_branch_ids
    listbox_mazes_Callback(handles.listbox_mazes, eventdata, handles);       


% --- Executes on selection change in listbox_trajectories.
function listbox_trajectories_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_trajectories (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_trajectories contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_trajectories

contents = cellstr(get(hObject,'String'));
traj_str = contents{get(hObject,'Value')};
maze_id = get(handles.listbox_mazes,'Value');

global session;
keep_trials = keep_maze_traj(session,traj_str,maze_id);

frac_str = get(handles.edit_trial_range,'string');
frac_range = cell2mat(eval(frac_str));
inds = zeros(length(keep_trials),1);
inds(frac_range(1):min(frac_range(2),length(keep_trials))) = 1;
keep_trials = keep_trials & inds;
 
rand_col = get(handles.checkbox_rand_col,'Value');

% plot only kept trials
h_traj = get(handles.listbox_trajectories,'userdata');
if ishandle(h_traj)
    delete(h_traj);
end
h_traj = plot_mVR_maze_traj(handles.axes_maze,session,keep_trials,rand_col);
set(handles.listbox_trajectories,'userdata',h_traj);

% --- Executes during object creation, after setting all properties.
function listbox_trajectories_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_trajectories (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_rand_col.
function checkbox_rand_col_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_rand_col (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_rand_col
    listbox_mazes_Callback(handles.listbox_mazes, eventdata, handles);       
