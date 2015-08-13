function varargout = maze_designer(varargin)
% MAZE_DESIGNER MATLAB code for maze_designer.fig
%      MAZE_DESIGNER, by itself, creates a new MAZE_DESIGNER or raises the existing
%      singleton*.
%
%      H = MAZE_DESIGNER returns the handle to a new MAZE_DESIGNER or the handle to
%      the existing singleton*.
%
%      MAZE_DESIGNER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAZE_DESIGNER.M with the given input arguments.
%
%      MAZE_DESIGNER('Property','Value',...) creates a new MAZE_DESIGNER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before maze_designer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to maze_designer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help maze_designer

% Last Modified by GUIDE v2.5 15-May-2015 22:58:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @maze_designer_OpeningFcn, ...
                   'gui_OutputFcn',  @maze_designer_OutputFcn, ...
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


% --- Executes just before maze_designer is made visible.
function maze_designer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to maze_designer (see VARARGIN)

% Choose default command line output for maze_designer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

col_names = properties(branch);
col_names = strrep(col_names, '_', ' ');
set(handles.uitable_branches,'ColumnName',col_names);
set(handles.uitable_branches,'ColumnEditable',true(1,numel(col_names)))
ColumnFormat = repmat({'numeric'},1,numel(col_names));
%ColumnFormat{find(strcmp(col_names,'reward'))} = 'char';
set(handles.uitable_branches,'ColumnFormat',ColumnFormat)
set(handles.uitable_branches,'Data',[]);

%set(handles.axes_maze,'visible','off');
set(handles.axes_maze,'color',[0 0 0])
set(handles.axes_maze,'xtick',[])
set(handles.axes_maze,'ytick',[])

% UIWAIT makes maze_designer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = maze_designer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_add_branch.
function pushbutton_add_branch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_add_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = str2double(get(handles.edit_add_branch,'String'));
dat = get(handles.uitable_branches,'Data');

if value <= size(dat,1)
  dat_add = dat(value,:);
else
  col_names = properties(branch);
  default_branch = branch;
  dat_add = cell(1,numel(col_names));
  for ij = 1:numel(col_names)
    dat_add{ij} = default_branch.(col_names{ij});
  end
end

dat = cat(1,dat,dat_add);
set(handles.uitable_branches,'Data',dat);


% --- Executes on button press in pushbutton_remove_branch.
function pushbutton_remove_branch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_remove_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = str2double(get(handles.edit_remove_branch,'String'));
dat = get(handles.uitable_branches,'Data');

if value <= size(dat,1)
  dat(value,:) = [];
elseif ~isempty(dat)
  dat(end,:) = [];
end

set(handles.uitable_branches,'Data',dat);


function edit_remove_branch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_remove_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_remove_branch as text
%        str2double(get(hObject,'String')) returns contents of edit_remove_branch as a double

pushbutton_remove_branch_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_remove_branch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_remove_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_add_branch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_add_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_add_branch as text
%        str2double(get(hObject,'String')) returns contents of edit_add_branch as a double

pushbutton_add_branch_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_add_branch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_add_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in checkbox_show_branch_ids.
function checkbox_show_branch_ids_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_show_branch_ids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_show_branch_ids

pushbutton_plot_maze_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton_plot_maze.
function pushbutton_plot_maze_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot_maze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes_maze);
cla;

dat = get(handles.uitable_branches,'Data');
if ~isempty(dat)
  start_branch = get(handles.edit_starting_branch,'String');
  start_branch = str2double(start_branch);
  [maze dat] = create_maze(dat,start_branch);
  show_branch_labels = get(handles.checkbox_show_branch_ids,'value');
  plot_maze(gca,maze,show_branch_labels,1,1);
  set(handles.uitable_branches,'Data',dat);
end

function edit_maze_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maze_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maze_name as text
%        str2double(get(hObject,'String')) returns contents of edit_maze_name as a double


% --- Executes during object creation, after setting all properties.
function edit_maze_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maze_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_save_maze.
function pushbutton_save_maze_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_maze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);
[FileName,PathName,FilterIndex] = uiputfile(fullfile(pathstr,'Mazes','*.mat'));
if FilterIndex>0
    dat = get(handles.uitable_branches,'Data');
    start_branch = get(handles.edit_starting_branch,'String');
    set(handles.text_maze_name,'String',FileName)
    save([PathName FileName],'dat','start_branch');
end

% --- Executes on button press in pushbutton_load_maze.
function pushbutton_load_maze_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_maze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);
[FileName,PathName,FilterIndex] = uigetfile(fullfile(pathstr,'Mazes','*.mat'));

if FilterIndex>0
    load_dat = load([PathName FileName]);
    set(handles.uitable_branches,'Data',load_dat.dat);
    set(handles.text_maze_name,'String',FileName);
    set(handles.edit_starting_branch,'String',load_dat.start_branch);
end

pushbutton_plot_maze_Callback(hObject, eventdata, handles)

% --- Executes on selection change in listbox_mazes.
function listbox_mazes_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_mazes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_mazes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_mazes

value = get(handles.listbox_mazes,'Value');
maze_names = get(handles.listbox_mazes,'String');
dat_array = get(handles.listbox_mazes,'UserData');
start_branch_array = get(handles.edit_starting_branch,'UserData');

if value <= numel(dat_array)
        set(handles.uitable_branches,'Data',dat_array{value});
        set(handles.text_maze_name,'String',maze_names{value});
        set(handles.edit_starting_branch,'String',start_branch_array{value});
end

pushbutton_plot_maze_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function listbox_mazes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_mazes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_add_maze.
function pushbutton_add_maze_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_add_maze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);
[FileName,PathName,FilterIndex] = uigetfile(fullfile(pathstr,'Mazes','*.mat'));

if FilterIndex>0
    load_dat = load([PathName FileName]);
    set(handles.uitable_branches,'Data',load_dat.dat);
    set(handles.text_maze_name,'String',FileName);
    set(handles.edit_starting_branch,'String',load_dat.start_branch);



    dat_array = get(handles.listbox_mazes,'UserData');
    dat_array{numel(dat_array)+1} = load_dat.dat;
    start_branch_array = get(handles.edit_starting_branch,'UserData');
    start_branch_array{numel(start_branch_array)+1} = load_dat.start_branch;

    maze_names = get(handles.listbox_mazes,'String');
    if isempty(maze_names)
       maze_names = [];
    end
    maze_names = cat(1,maze_names,{FileName});
    set(handles.listbox_mazes,'UserData',dat_array);
    set(handles.listbox_mazes,'String',maze_names);
    set(handles.listbox_mazes,'Value',numel(maze_names));
    set(handles.edit_starting_branch,'UserData',start_branch_array);

    pushbutton_plot_maze_Callback(hObject, eventdata, handles)

end

% --- Executes on button press in pushbutton_remove_maze.
function pushbutton_remove_maze_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_remove_maze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(handles.listbox_mazes,'Value');
maze_names = get(handles.listbox_mazes,'String');
dat_array = get(handles.listbox_mazes,'UserData');
start_branch_array = get(handles.edit_starting_branch,'UserData');

if value <= numel(dat_array)
    dat_array(value) = [];
    start_branch_array(value) = [];
    maze_names(value) = [];
    set(handles.edit_starting_branch,'UserData',start_branch_array);
    set(handles.listbox_mazes,'UserData',dat_array);
    set(handles.listbox_mazes,'String',maze_names);
    if value-1 > 0
        set(handles.listbox_mazes,'Value',value-1);
        set(handles.uitable_branches,'Data',dat_array{value-1});
        set(handles.text_maze_name,'String',maze_names{value-1});
        set(handles.edit_starting_branch,'String',start_branch_array{value-1});
    elseif numel(dat_array) > 0
        set(handles.listbox_mazes,'Value',1);
        set(handles.uitable_branches,'Data',dat_array{1});
        set(handles.text_maze_name,'String',maze_names{1}); 
        set(handles.edit_starting_branch,'String',start_branch_array{1});
    else
        set(handles.listbox_mazes,'Value',1);
        set(handles.uitable_branches,'Data',[]);
        set(handles.text_maze_name,'String',[]);
        set(handles.edit_starting_branch,'String',[]);
    end
end
    
pushbutton_plot_maze_Callback(hObject, eventdata, handles)




function edit_maze_repeats_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maze_repeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maze_repeats as text
%        str2double(get(hObject,'String')) returns contents of edit_maze_repeats as a double


% --- Executes during object creation, after setting all properties.
function edit_maze_repeats_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maze_repeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maze_id_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maze_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maze_id as text
%        str2double(get(hObject,'String')) returns contents of edit_maze_id as a double


% --- Executes during object creation, after setting all properties.
function edit_maze_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maze_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_save_config.
function pushbutton_save_config_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);
[FileName,PathName,FilterIndex] = uiputfile(fullfile(pathstr,'Configs','*.mat'));
if FilterIndex>0
    maze_names = get(handles.listbox_mazes,'String');
    dat_array = get(handles.listbox_mazes,'UserData');
    start_branch_array = get(handles.edit_starting_branch,'UserData');
    set(handles.text_config_name,'String',FileName)
    val_random = get(handles.radiobutton_random_order,'value');
    val_repeat = get(handles.radiobutton_repeat,'value');
    if val_random
        trial_vars.random = 1;
    elseif val_repeat
        trial_vars.random = 2;
    else
        trial_vars.random = 0;
    end
    trial_vars.maze_ids = get(handles.edit_maze_id,'string');
    trial_vars.maze_repeats = get(handles.edit_maze_repeats,'string');
    trial_vars.session_timeout = str2double(get(handles.edit_trial_timeout,'string'));
    trial_vars.session_iti = 1;
    trial_vars.session_drink_time = str2double(get(handles.edit_water_timeout,'string'));
    trial_vars.session_continuous_trials = get(handles.radiobutton_cts_trials,'value');
    save([PathName FileName],'maze_names','dat_array','start_branch_array','trial_vars');
end

% --- Executes on button press in pushbutton_load_config.
function pushbutton_load_config_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);
[FileName,PathName,FilterIndex] = uigetfile(fullfile(pathstr,'Configs','*.mat'));

if FilterIndex>0
    load_dat = load([PathName FileName]);
    set(handles.listbox_mazes,'String',load_dat.maze_names);
    set(handles.listbox_mazes,'UserData',load_dat.dat_array);
    set(handles.listbox_mazes,'Value',1);
    set(handles.edit_starting_branch,'UserData',load_dat.start_branch_array);
    listbox_mazes_Callback(hObject, eventdata, handles);
    if load_dat.trial_vars.random == 1
        set(handles.radiobutton_random_order,'value',1)
        set(handles.radiobutton_repeat,'value',0)
    elseif load_dat.trial_vars.random == 2
        set(handles.radiobutton_random_order,'value',0)
        set(handles.radiobutton_repeat,'value',1)
    else
        set(handles.radiobutton_random_order,'value',0)
        set(handles.radiobutton_repeat,'value',0)        
    end
    set(handles.edit_maze_repeats,'string',load_dat.trial_vars.maze_repeats)
    set(handles.edit_maze_id,'string',load_dat.trial_vars.maze_ids)
    set(handles.edit_water_timeout,'string',num2str(load_dat.trial_vars.session_drink_time))
    set(handles.edit_trial_timeout,'string',num2str(load_dat.trial_vars.session_timeout))
    set(handles.radiobutton_cts_trials,'value',load_dat.trial_vars.session_continuous_trials)
    radiobutton_random_order_Callback(handles.radiobutton_random_order, eventdata, handles);
    radiobutton_repeat_Callback(handles.radiobutton_repeat, eventdata, handles);
end


% --- Executes on button press in radiobutton_random_order.
function radiobutton_random_order_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_random_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_random_order

value = get(hObject,'Value');
if value
      set(handles.text_maze_repeats,'enable','off');
      set(handles.edit_maze_repeats,'enable','off');
      set(handles.text_maze_id,'enable','off');
      set(handles.edit_maze_id,'enable','off');
      set(handles.radiobutton_repeat,'value',0)        
elseif get(handles.radiobutton_repeat,'value') == 0
      set(handles.text_maze_repeats,'enable','on');
      set(handles.edit_maze_repeats,'enable','on');
      set(handles.text_maze_id,'enable','on');
      set(handles.edit_maze_id,'enable','on'); 
else
end


function edit_starting_branch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_starting_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_starting_branch as text
%        str2double(get(hObject,'String')) returns contents of edit_starting_branch as a double


% --- Executes during object creation, after setting all properties.
function edit_starting_branch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_starting_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable_branches.
function uitable_branches_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_branches (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

%34334


% --- Executes on button press in radiobutton_repeat.
function radiobutton_repeat_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_repeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_repeat

value = get(hObject,'Value');
if value
      set(handles.text_maze_repeats,'enable','off');
      set(handles.edit_maze_repeats,'enable','off');
      set(handles.text_maze_id,'enable','off');
      set(handles.edit_maze_id,'enable','off');
      set(handles.radiobutton_random_order,'value',0)        
elseif get(handles.radiobutton_random_order,'value') == 0
      set(handles.text_maze_repeats,'enable','on');
      set(handles.edit_maze_repeats,'enable','on');
      set(handles.text_maze_id,'enable','on');
      set(handles.edit_maze_id,'enable','on'); 
else
end


% --- Executes on button press in radiobutton_cts_trials.
function radiobutton_cts_trials_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cts_trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cts_trials



function edit_water_timeout_Callback(hObject, eventdata, handles)
% hObject    handle to edit_water_timeout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_water_timeout as text
%        str2double(get(hObject,'String')) returns contents of edit_water_timeout as a double


% --- Executes during object creation, after setting all properties.
function edit_water_timeout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_water_timeout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_trial_timeout_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trial_timeout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trial_timeout as text
%        str2double(get(hObject,'String')) returns contents of edit_trial_timeout as a double


% --- Executes during object creation, after setting all properties.
function edit_trial_timeout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trial_timeout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
