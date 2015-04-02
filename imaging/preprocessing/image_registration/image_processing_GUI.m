function varargout = image_processing_GUI(varargin)
% IMAGE_PROCESSING_GUI MATLAB code for image_processing_GUI.fig
%      IMAGE_PROCESSING_GUI, by itself, creates a new IMAGE_PROCESSING_GUI or raises the existing
%      singleton*.
%
%      H = IMAGE_PROCESSING_GUI returns the handle to a new IMAGE_PROCESSING_GUI or the handle to
%      the existing singleton*.
%
%      IMAGE_PROCESSING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_PROCESSING_GUI.M with the given input arguments.
%
%      IMAGE_PROCESSING_GUI('Property','Value',...) creates a new IMAGE_PROCESSING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before image_processing_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to image_processing_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help image_processing_GUI

% Last Modified by GUIDE v2.5 02-Apr-2015 10:22:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @image_processing_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @image_processing_GUI_OutputFcn, ...
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


% --- Executes just before image_processing_GUI is made visible.
function image_processing_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to image_processing_GUI (see VARARGIN)

% Choose default command line output for image_processing_GUI
set(hObject,'HandleVisibility','on')
handles.output = hObject;

handles.datastr = pwd;

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);
handles.pathstr = pathstr;


% disable gui buttons that should not be used
image_processing_gui_toggle_enable(handles,'off',[1:5])
set(handles.checkbox_behaviour,'Value',1)
set(handles.checkbox_register,'Value',1)
set(handles.text_status,'String','Status: offline')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes image_processing_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = image_processing_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton_data_dir.
function pushbutton_data_dir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_data_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disable gui buttons that should not be used

start_path = handles.datastr;
folder_name = uigetdir(start_path);

if folder_name ~= 0
    image_processing_gui_toggle_enable(handles,'off',[1:5])
    set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(0)]);
    set(handles.text_registered_trials,'String',['Registered trials ' num2str(0)]);
    set(handles.text_imaging_trials,'String',['Imaging trials ' num2str(0)]);
    set(handles.text_status,'String','Status: offline')
    set(handles.checkbox_register,'Value',1)
    drawnow
    
    handles.base_path = folder_name;
    handles.data_dir = fullfile(handles.base_path, 'scanimage');
    
    clear global im_session
    global im_session;
    im_session = load_im_session_data(handles.data_dir);
    
    clear global session;
    global session;
    session = [];
    session.data = [];
    
    clear global remove_first;
    clear global scim_first_offset;
    global remove_first;
    global scim_first_offset;
    scim_first_offset = 0;
    remove_first = 0;
    if exist(fullfile(handles.data_dir,'sync_offsets.mat')) == 2
        sync_data = load(fullfile(handles.data_dir,'sync_offsets.mat'));
        remove_first = sync_data.remove_first;
        scim_first_offset = sync_data.scim_first_offset;
    end
        
    image_processing_gui_toggle_enable(handles,'on',[1 2 5])

    set(handles.text_anm,'String',im_session.basic_info.anm_str)
    set(handles.text_date,'String',im_session.basic_info.date_str)
    set(handles.text_run,'String',im_session.basic_info.run_str)
    
    handles.output_base_path = handles.base_path;
    
    guidata(hObject, handles);
end


% --- Executes on button press in checkbox_save_aligned.
function checkbox_save_aligned_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_save_aligned (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_save_aligned

%set(handles.togglebutton_register,'enable','off')
%set(handles.togglebutton_realtime_mode,'enable','off')


% --- Executes on button press in checkbox_overwrite.
function checkbox_overwrite_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_overwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_overwrite

%set(handles.togglebutton_register,'enable','off')
%set(handles.togglebutton_realtime_mode,'enable','off')

% --- Executes on button press in pushbutton_output_path.
function pushbutton_output_path_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_output_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start_path = handles.datastr;
folder_name = uigetdir(start_path);
if folder_name ~= 0
    handles.output_base_path = folder_name;
    new_dir = fullfile(handles.output_base_path,'registered_im');
    if exist(new_dir) ~=7
        mkdir(new_dir)
    end
    if get(handles.checkbox_behaviour,'Value')
        new_dir = fullfile(handles.output_base_path,'registered_bv');
        if exist(new_dir) ~=7
            mkdir(new_dir)
        end
    end
end
guidata(hObject, handles);


function edit_align_chan_Callback(hObject, eventdata, handles)
% hObject    handle to edit_align_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_align_chan as text
%        str2double(get(hObject,'String')) returns contents of edit_align_chan as a double

%set(handles.togglebutton_register,'enable','off')
%set(handles.togglebutton_realtime_mode,'enable','off')

% --- Executes during object creation, after setting all properties.
function edit_align_chan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_align_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_behaviour.
function checkbox_behaviour_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_behaviour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_behaviour


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in togglebutton_register.
function togglebutton_register_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_register (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    value = get(hObject,'Value');
    if value == 1

        % load reference if not already there
        global im_session
        if isempty(im_session.ref)
            ref = load_referrence(handles.data_dir);
            ref = post_process_ref_fft(ref);
            im_session.ref = ref;
            set(handles.text_num_planes,'String',sprintf('Num planes %d',im_session.ref.im_props.numPlanes))
            set(handles.text_num_chan,'String',sprintf('Num channels %d',im_session.ref.im_props.nchans))
        end
    
        align_chan = str2double(get(handles.edit_align_chan,'String'));
        im_session.ref.im_props.align_chan = align_chan;

        im_session.basic_info.output_base_path = handles.output_base_path;
        im_session.basic_info.save_registered = get(handles.checkbox_save_aligned,'Value');
        im_session.basic_info.overwrite = get(handles.checkbox_overwrite,'Value');
        im_session.basic_info.behaviour_on = get(handles.checkbox_behaviour,'Value');
        im_session.basic_info.down_sample = str2double(get(handles.edit_downsample,'String'));
        im_session.basic_info.register_on = get(handles.checkbox_register,'Value');

        tic;
        image_processing_gui_toggle_enable(handles,'off',[2])
        image_processing_gui_toggle_enable(handles,'on',[3 4 5])
        set(handles.pushbutton_data_dir,'enable','off')
        set(handles.text_status,'String','Status: waiting')
        
        % Setup timer
        handles.obj_t = timer('TimerFcn',{@update_im_processing,handles});
        set(handles.obj_t,'ExecutionMode','fixedSpacing');
        set(handles.obj_t,'Period', .5);
        set(handles.obj_t,'BusyMode','drop');
        set(handles.obj_t,'ErrorFcn',@(obj,event)disp('Timing Error'));
        set(handles.obj_t,'UserData',0);
        
        % Update handles structure
        guidata(hObject, handles);
        start(handles.obj_t)    
    else
        stop(handles.obj_t);
        delete(handles.obj_t);
        
        image_processing_gui_toggle_enable(handles,'on',[2])
        set(handles.pushbutton_data_dir,'enable','on')
        
        time_elapsed_str = sprintf('Time online %.1f s',0);
        set(handles.text_time,'String',time_elapsed_str)
        set(handles.text_time,'Enable','off')
        set(handles.text_status,'String','Status: offline')
    end
    
function edit_downsample_Callback(hObject, eventdata, handles)
% hObject    handle to edit_downsample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_downsample as text
%        str2double(get(hObject,'String')) returns contents of edit_downsample as a double

% --- Executes during object creation, after setting all properties.
function edit_downsample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_downsample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_register.
function checkbox_register_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_register (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_register
