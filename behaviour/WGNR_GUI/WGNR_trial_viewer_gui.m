function varargout = WGNR_trial_viewer_gui(varargin)
% WGNR_TRIAL_VIEWER_GUI MATLAB code for WGNR_trial_viewer_gui.fig
%      WGNR_TRIAL_VIEWER_GUI, by itself, creates a new WGNR_TRIAL_VIEWER_GUI or raises the existing
%      singleton*.
%
%      H = WGNR_TRIAL_VIEWER_GUI returns the handle to a new WGNR_TRIAL_VIEWER_GUI or the handle to
%      the existing singleton*.
%
%      WGNR_TRIAL_VIEWER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WGNR_TRIAL_VIEWER_GUI.M with the given input arguments.
%
%      WGNR_TRIAL_VIEWER_GUI('Property','Value',...) creates a new WGNR_TRIAL_VIEWER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WGNR_trial_viewer_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WGNR_trial_viewer_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WGNR_trial_viewer_gui

% Last Modified by GUIDE v2.5 28-Jan-2014 00:24:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @WGNR_trial_viewer_gui_OpeningFcn, ...
    'gui_OutputFcn',  @WGNR_trial_viewer_gui_OutputFcn, ...
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


% --- Executes just before WGNR_trial_viewer_gui is made visible.
function WGNR_trial_viewer_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WGNR_trial_viewer_gui (see VARARGIN)

% Choose default command line output for WGNR_trial_viewer_gui
handles.output = hObject;
% addpath(fullfile('.','accessory_fns'));
% addpath(fullfile('.','accessory_fns','plot_functions'));
% addpath(fullfile('.','accessory_fns','plot_functions','time_series_plots'));
% addpath(fullfile('.','accessory_fns','plot_functions','histogram_plots'));
% addpath(fullfile('.','accessory_fns','plot_functions','bar_chart_plots'));

value = get(handles.togglebutton_online_mode,'Value');
if value == 1
    set(handles.togglebutton_online_mode,'Value',0)
    togglebutton_online_mode_Callback(handles.togglebutton_online_mode, eventdata, handles)
end

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);

handles.trial_config = trial_config_class;
handles.trial_config.column_names = get(handles.uitable1,'ColumnName');
handles.trial_config.random_order = get(handles.random_trial_on,'value');
handles.trial_config.repeating_order = get(handles.trial_repeat_string,'String');
handles.trial_config.repeating_numbers = get(handles.edit_num_reps,'String');
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

set(handles.uitable1,'Data',[]);
set(handles.uitable_plotting,'Data',[]);
set(handles.uitable_trial_info,'Data',[]);

cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes3)
cla(handles.axes4)
cla(handles.axes5)


plot_list = dir(fullfile(handles.pathstr,'accessory_fns','plot_functions','time_series_plots','*.m'));
plot_names = cell(numel(plot_list),1);
for ij = 1:numel(plot_list)
    plot_names{ij} = plot_list(ij).name;
end
set(handles.popupmenu_ax1,'string',plot_names)
set(handles.popupmenu_ax1,'value',4)
set(handles.popupmenu_ax2,'string',plot_names)

plot_list = dir(fullfile(handles.pathstr,'accessory_fns','plot_functions','histogram_plots','*.m'));
plot_names = cell(numel(plot_list),1);
for ij = 1:numel(plot_list)
    plot_names{ij} = plot_list(ij).name;
end
set(handles.popupmenu_ax3,'string',plot_names)
set(handles.popupmenu_ax4,'string',plot_names)
set(handles.popupmenu_ax4,'value',5)

plot_list = dir(fullfile(handles.pathstr,'accessory_fns','plot_functions','bar_chart_plots','*.m'));
plot_names = cell(numel(plot_list),1);
for ij = 1:numel(plot_list)
    plot_names{ij} = plot_list(ij).name;
end
set(handles.popupmenu_ax5,'string',plot_names)

set(handles.uitable_trial_info,'Enable','off');
set(handles.togglebutton_online_mode,'Enable','off')
set(handles.pushbutton_plot_data,'Enable','off')
set(handles.popupmenu_ax1,'Enable','off')
set(handles.popupmenu_ax2,'Enable','off')
set(handles.popupmenu_ax3,'Enable','off')
set(handles.popupmenu_ax4,'Enable','off')
set(handles.popupmenu_ax5,'Enable','off')
set(handles.edit_range_ax3,'Enable','off')
set(handles.edit_range_ax4,'Enable','off')
set(handles.edit_range_ax5,'Enable','off')
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

%     list = get(hObject,'String');
%     item_selected = list{index_selected};
%
handles.data_dir = [];
clear global session;
if nargin > 3
    file_name = varargin{1};
    load_trial_Callback(handles.load_trial, eventdata, handles, file_name{1})
end

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes WGNR_trial_viewer_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WGNR_trial_viewer_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in add_row.
function add_row_Callback(hObject, eventdata, handles)
% hObject    handle to add_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
default_data =  {'Left turn','Distance', 200, 12, 1, true, true, true, '{0, 1}','{15, 15}', '{0, 1}','{30, 30}', '{0, .25, .75, 1}', '{0, -10, 0}','{0, 1}','{1}', '{.25, .75}',true, '{.85}','{2}', '{28}','Wall distance (mm)','{100}','Off','{0, .75}',2,0,'Off','{.25, .75}','S1','Left',2,0,0,.1,true,false};
default_plot_data =  {true,'[0 0 0]'};

clear handles.trial_config.plot_options
handles.trial_config.dat = get(handles.uitable1,'Data');
handles.trial_config.plot_options.dat{1} = get(handles.uitable_plotting,'Data');
handles.trial_config.plot_options.names = 'DEFAULT';
set(handles.edit_plot_options_name,'String','DEFAULT');

num_to_add = str2num(get(handles.add_row_number,'String'));
if isnumeric(num_to_add) && isempty(num_to_add) ~=1
    if size(handles.trial_config.dat,1) >= num_to_add && num_to_add > 0
        handles.trial_config.dat = [handles.trial_config.dat;handles.trial_config.dat(num_to_add,:)];
        handles.trial_config.plot_options.dat{1} = [handles.trial_config.plot_options.dat{1};handles.trial_config.plot_options.dat{1}(num_to_add,:)];
    else
        handles.trial_config.dat = [handles.trial_config.dat;default_data];
        handles.trial_config.plot_options.dat{1} = [handles.trial_config.plot_options.dat{1};default_plot_data];
    end
else
    handles.trial_config.dat = [handles.trial_config.dat;default_data];
    handles.trial_config.plot_options.dat{1} = [handles.trial_config.plot_options.dat{1};default_plot_data];
end

set(handles.uitable1,'Data',handles.trial_config.dat);
set(handles.uitable_plotting,'Data',handles.trial_config.plot_options.dat{1});
set(handles.popupmenu_plot_options,'String',handles.trial_config.plot_options.names);
set(handles.popupmenu_plot_options,'Value',1);

% Update handles structure
guidata(hObject, handles);

function add_row_number_Callback(hObject, eventdata, handles)
% hObject    handle to add_row_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of add_row_number as text
%        str2double(get(hObject,'String')) returns contents of add_row_number as a double


% --- Executes during object creation, after setting all properties.
function add_row_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to add_row_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in remove_row.
function remove_row_Callback(hObject, eventdata, handles)
% hObject    handle to remove_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear handles.trial_config.plot_options
handles.trial_config.dat = get(handles.uitable1,'Data');
handles.trial_config.plot_options.dat{1} = get(handles.uitable_plotting,'Data');
handles.trial_config.plot_options.names = 'DEFAULT';
set(handles.edit_plot_options_name,'String','DEFAULT');

num_to_remove = str2num(get(handles.remove_row_number,'String'));
if size(handles.trial_config.dat,1) > 0
    if isnumeric(num_to_remove) && isempty(num_to_remove) ~=1
        if size(handles.trial_config.dat,1) >= num_to_remove && num_to_remove > 0
            handles.trial_config.dat(num_to_remove,:) = [];
            handles.trial_config.plot_options.dat{1}(num_to_remove,:) = [];
        else
            handles.trial_config.dat(end,:) = [];
            handles.trial_config.plot_options.dat{1}(end,:) = [];
        end
    else
        handles.trial_config.dat(end,:) = [];
        handles.trial_config.plot_options.dat{1}(end,:) = [];
    end
    set(handles.uitable1,'Data',handles.trial_config.dat);
    set(handles.uitable_plotting,'Data',handles.trial_config.plot_options.dat{1});
else
end
set(handles.popupmenu_plot_options,'String',handles.trial_config.plot_options.names);
set(handles.popupmenu_plot_options,'Value',1);

% Update handles structure
guidata(hObject, handles);

function remove_row_number_Callback(hObject, eventdata, handles)
% hObject    handle to remove_row_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of remove_row_number as text
%        str2double(get(hObject,'String')) returns contents of remove_row_number as a double


% --- Executes during object creation, after setting all properties.
function remove_row_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove_row_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in random_trial_on.
function random_trial_on_Callback(hObject, eventdata, handles)
% hObject    handle to random_trial_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of random_trial_on
toggle_value = get(hObject,'Value');

if toggle_value == 1
    set(handles.trial_repeat_label,'Enable','off');
    set(handles.trial_repeat_string,'Enable','off');
    set(handles.trial_repeat_string,'String','');
    set(handles.text_num_reps,'Enable','off');
    set(handles.edit_num_reps,'Enable','off');
    set(handles.edit_num_reps,'String','');
else
    set(handles.trial_repeat_label,'Enable','on');
    set(handles.trial_repeat_string,'Enable','on');
    set(handles.text_num_reps,'Enable','on');
    set(handles.edit_num_reps,'Enable','on');
end

% --- Executes on button press in radiobutton_laser_calibration.
function radiobutton_laser_calibration_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_laser_calibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_laser_calibration


function trial_repeat_string_Callback(hObject, eventdata, handles)
% hObject    handle to trial_repeat_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trial_repeat_string as text
%        str2double(get(hObject,'String')) returns contents of trial_repeat_string as a double


% --- Executes during object creation, after setting all properties.
function trial_repeat_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trial_repeat_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_trial.
function save_trial_Callback(hObject, eventdata, handles)
% hObject    handle to save_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,FilterIndex] = uiputfile(fullfile(handles.pathstr,'Trial_configs','*.mat'));
if FilterIndex>0
    handles.trial_config.dat = get(handles.uitable1,'Data');
    handles.trial_config.random_order = get(handles.random_trial_on,'value');
    handles.trial_config.repeating_order = get(handles.trial_repeat_string,'String');
    handles.trial_config.repeating_numbers = get(handles.edit_num_reps,'String');
    handles.trial_config.column_names = get(handles.uitable1,'ColumnName');
    pushbutton_add_plot_options_Callback(handles.pushbutton_add_plot_options, eventdata, handles)
    handles.trial_config.file_name = FileName;
    handles.trial_config.laser_calibration = get(handles.radiobutton_laser_calibration,'Value');
    set(handles.trial_config_name,'String',FileName);
    trial_config = handles.trial_config;
    trial_config = trial_dat_parser(trial_config);
    save([PathName FileName],'trial_config');
end

% --- Executes on button press in load_trial.
function load_trial_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to load_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if nargin > 3
    PathName = [];
    FileName = varargin{1};
    FilterIndex = 1;
else
    [FileName,PathName,FilterIndex] = uigetfile(fullfile(handles.pathstr,'Trial_configs','*.mat'));
end

if FilterIndex>0
    load([PathName FileName]);
    handles.trial_config = trial_config;
    set(handles.uitable1,'Data',handles.trial_config.dat);
    set(handles.trial_config_name,'String',FileName);
    set(handles.trial_repeat_string,'String',handles.trial_config.repeating_order);
    set(handles.edit_num_reps,'String',handles.trial_config.repeating_numbers);
    set(handles.random_trial_on,'Value',handles.trial_config.random_order);
    random_trial_on_Callback(handles.random_trial_on, eventdata, handles)
    set(handles.uitable_plotting,'Data',handles.trial_config.plot_options.dat{1});
    set(handles.popupmenu_plot_options,'String',handles.trial_config.plot_options.names);
    set(handles.popupmenu_plot_options,'Value',1);
    set(handles.radiobutton_laser_calibration,'Value',handles.trial_config.laser_calibration);
    
    set(handles.trial_config_name,'String',handles.trial_config.file_name);
    if iscell(handles.trial_config.plot_options.names) == 1
        set(handles.edit_plot_options_name,'String',handles.trial_config.plot_options.names{1});
    else
        set(handles.edit_plot_options_name,'String',handles.trial_config.plot_options.names);
    end
end

guidata(hObject, handles);


% --- Executes on selection change in popupmenu_plot_options.
function popupmenu_plot_options_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_plot_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_plot_options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_plot_options

contents = cellstr(get(hObject,'String'))
value = get(hObject,'Value')
set(handles.uitable_plotting,'Data',handles.trial_config.plot_options.dat{value});
set(handles.edit_plot_options_name,'String',contents(value));

pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_plot_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_plot_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_plot_options_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_plot_options_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_plot_options_name as text
%        str2double(get(hObject,'String')) returns contents of edit_plot_options_name as a double


% --- Executes during object creation, after setting all properties.
function edit_plot_options_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_plot_options_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_add_plot_options.
function pushbutton_add_plot_options_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_add_plot_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dat = get(handles.uitable_plotting,'Data');
name_list = get(handles.popupmenu_plot_options,'String');
cur_name = get(handles.edit_plot_options_name,'String');
if iscell(name_list) ~= 1
    name_list = {name_list};
end
value = find(strcmp(name_list,cur_name), 1);
if isempty(value) == 1
    name_list = [name_list;cur_name];
    value = numel(name_list);
end
handles.trial_config.plot_options.dat{value} = dat;
handles.trial_config.plot_options.names = name_list;
set(handles.popupmenu_plot_options,'String',name_list);
set(handles.popupmenu_plot_options,'Value',value);
guidata(hObject, handles);

% make check through input list

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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

cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes3)
cla(handles.axes4)
cla(handles.axes5)

start_path = handles.datastr;
folder_name = uigetdir(start_path);

if folder_name ~= 0
    handles.data_dir = fullfile(folder_name,'behaviour');
    clear global session
    global session;
    session = load_session_data(handles.data_dir);
    session = parse_session_data(1,[]);
    handles.trial_config = session.trial_config;
    set(handles.uitable1,'Data',handles.trial_config.dat);
    set(handles.trial_repeat_string,'String',handles.trial_config.repeating_order);
    set(handles.edit_num_reps,'String',handles.trial_config.repeating_numbers);    
    set(handles.random_trial_on,'Value',handles.trial_config.random_order);
    random_trial_on_Callback(handles.random_trial_on, eventdata, handles)
    set(handles.trial_config_name,'String',handles.trial_config.file_name);
    set(handles.uitable_plotting,'Data',handles.trial_config.plot_options.dat{1});
    set(handles.popupmenu_plot_options,'String',handles.trial_config.plot_options.names);
    set(handles.popupmenu_plot_options,'Value',1);
    if iscell(handles.trial_config.plot_options.names) == 1
        set(handles.edit_plot_options_name,'String',handles.trial_config.plot_options.names{1});
    else
        set(handles.edit_plot_options_name,'String',handles.trial_config.plot_options.names);
    end
    
    set(handles.text_anm,'Enable','on')
    set(handles.text_date,'Enable','on')
    set(handles.text_run_num,'Enable','on')
    
    set(handles.text_anm,'String',session.basic_info.anm_str)
    set(handles.text_date,'String',session.basic_info.date_str)
    set(handles.text_run_num,'String',session.basic_info.run_str)
    
    set(handles.uitable_trial_info,'Enable','on');
    set(handles.pushbutton_plot_data,'Enable','on')
    set(handles.popupmenu_ax1,'Enable','on')
    set(handles.popupmenu_ax2,'Enable','on')
    set(handles.popupmenu_ax3,'Enable','on')
    set(handles.popupmenu_ax4,'Enable','on')
    set(handles.popupmenu_ax5,'Enable','on')
    set(handles.edit_range_ax3,'Enable','on')
    set(handles.edit_range_ax4,'Enable','on')
    set(handles.edit_range_ax5,'Enable','on')
    set(handles.edit_save_figs,'Enable','on')
    set(handles.pushbutton_save_figs,'Enable','on')
    set(handles.checkbox_last_trial,'Enable','on')
    set(handles.checkbox_completed,'Enable','on')
    set(handles.edit_trial_range,'Enable','on')
    set(handles.text_trial_range,'Enable','on')
    set(handles.pushbutton_trial_maker,'Enable','on')
    set(handles.pushbutton_trial_maker,'Value',0)
    
    set(handles.uitable1,'Enable','inactive')
    set(handles.save_trial,'Enable','off')
    set(handles.load_trial,'Enable','off')
    set(handles.add_row,'Enable','off')
    set(handles.add_row_number,'Enable','off')
    set(handles.remove_row,'Enable','off')
    set(handles.remove_row_number,'Enable','off')
    set(handles.radiobutton_laser_calibration,'Enable','inactive')
    set(handles.random_trial_on,'Enable','inactive')

    if get(handles.random_trial_on,'Value') ~= 1;
        set(handles.trial_repeat_label,'Enable','inactive');
        set(handles.trial_repeat_string,'Enable','inactive');
        set(handles.text_num_reps,'Enable','inactive');
        set(handles.edit_num_reps,'Enable','inactive');
    end
       
    pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles)
    
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
set(handles.axes1,'userdata',[]);
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


% --- Executes on selection change in popupmenu_ax3.
function popupmenu_ax3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 3)

% --- Executes during object creation, after setting all properties.
function popupmenu_ax3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax3 (see GCBO)
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
    set(handles.popupmenu_ax3,'Enable','off')
    set(handles.popupmenu_ax4,'Enable','off')
    set(handles.popupmenu_ax5,'Enable','off')
    set(handles.edit_range_ax3,'Enable','off')
    set(handles.edit_range_ax4,'Enable','off')
    set(handles.edit_range_ax5,'Enable','off')
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
    set(handles.popupmenu_ax3,'Enable','on')
    set(handles.popupmenu_ax4,'Enable','on')
    set(handles.popupmenu_ax5,'Enable','on')
    set(handles.edit_range_ax3,'Enable','on')
    set(handles.edit_range_ax4,'Enable','on')
    set(handles.edit_range_ax5,'Enable','on')
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



function edit_range_ax3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_range_ax3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_range_ax3 as text
%        str2double(get(hObject,'String')) returns contents of edit_range_ax3 as a double
pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 3)


% --- Executes during object creation, after setting all properties.
function edit_range_ax3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_range_ax3 (see GCBO)
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
pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles)


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

cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes3)
cla(handles.axes4)
cla(handles.axes5)

set(handles.uitable_trial_info,'Data',[]);
set(handles.uitable_trial_info,'Enable','off');
set(handles.togglebutton_online_mode,'Enable','off')
set(handles.pushbutton_plot_data,'Enable','off')
set(handles.popupmenu_ax1,'Enable','off')
set(handles.popupmenu_ax2,'Enable','off')
set(handles.popupmenu_ax3,'Enable','off')
set(handles.popupmenu_ax4,'Enable','off')
set(handles.popupmenu_ax5,'Enable','off')
set(handles.edit_range_ax3,'Enable','off')
set(handles.edit_range_ax4,'Enable','off')
set(handles.edit_range_ax5,'Enable','off')
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


% --- Executes on selection change in popupmenu_ax5.
function popupmenu_ax5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ax5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ax5
pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 5)


% --- Executes during object creation, after setting all properties.
function popupmenu_ax5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ax5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_range_ax5_Callback(hObject, eventdata, handles)
% hObject    handle to edit_range_ax5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_range_ax5 as text
%        str2double(get(hObject,'String')) returns contents of edit_range_ax5 as a double
pushbutton_plot_data_Callback(handles.pushbutton_plot_data, eventdata, handles, 5)


% --- Executes during object creation, after setting all properties.
function edit_range_ax5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_range_ax5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
