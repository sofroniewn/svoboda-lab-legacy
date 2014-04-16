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

% Last Modified by GUIDE v2.5 15-Apr-2014 20:39:46

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


handles.jTcpObj = [];

% disable gui buttons that should not be used
image_processing_gui_toggle_enable(handles,'off',[1 3 4 5 6])
set(handles.text_align_chan,'enable','off')
set(handles.pushbutton_gen_catsa,'enable','off')
set(handles.pushbutton_gen_text,'enable','off')
set(handles.checkbox_behaviour,'Value',1)
set(handles.text_status,'String','Status: offline')

clear global im_session;
global im_session;
im_session = [];
clear global session_ca;
global session_ca;
clear global session;
global session;

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
image_processing_gui_toggle_enable(handles,'off',[1 3 4 5 6])
set(handles.pushbutton_gen_catsa,'enable','off')
set(handles.pushbutton_gen_text,'enable','off')
set(handles.text_align_chan,'Enable','off')
set(handles.text_align_chan,'String',['Align channel ' num2str(0)])

set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(0)]);
set(handles.text_registered_trials,'String',['Registered trials ' num2str(0)]);
set(handles.text_imaging_trials,'String',['Imaging trials ' num2str(0)]);

set(handles.text_status,'String','Status: offline')


start_path = handles.datastr;
folder_name = uigetdir(start_path);

if folder_name ~= 0
    handles.base_path = folder_name;
    handles.data_dir = fullfile(handles.base_path, 'scanimage');
    
    clear global im_session
    global im_session;
    im_session = load_im_session_data(handles.data_dir);
    im_session.realtime.im_raw = [];
    im_session.realtime.ind = 0;
    
    clear global session;
    global session;
    session = [];
    session.data = [];
    
    clear global session_ca;
    global session_ca;
    
    set(handles.text_anm,'Enable','on')
    set(handles.text_date,'Enable','on')
    set(handles.text_run,'Enable','on')
    set(handles.text_registered_trials,'Enable','on')
    set(handles.text_imaging_trials,'Enable','on')
    
    set(handles.text_anm,'String',im_session.basic_info.anm_str)
    set(handles.text_date,'String',im_session.basic_info.date_str)
    set(handles.text_run,'String',im_session.basic_info.run_str)
    set(handles.text_imaging_trials,'String',['Imaging trials ' num2str(numel(im_session.basic_info.cur_files))]);
    
    type_name = 'text';
    handles.text_path = fullfile(im_session.basic_info.data_dir,type_name);
    
    % LOAD EXISTING REF IMAGES
    ref_files = dir(fullfile(handles.data_dir,'ref_images_*.mat'));
    if numel(ref_files) > 0
        set(handles.popupmenu_ref,'enable','on')
        ref_names = cell(numel(ref_files),1);
        for ij = 1:numel(ref_files)
            ref_names{ij} = ref_files(ij).name;
        end
        set(handles.popupmenu_ref,'string',ref_names)
        set(handles.popupmenu_ref,'value',1)
        popupmenu_ref_Callback(hObject, eventdata, handles)
    else
        display('No reference images found')
        set(handles.popupmenu_ref,'enable','off')
    end
    
    start_val = 1;
    % LOAD EXISTING ROIs
    roi_files = dir(fullfile(handles.data_dir,'ROIs_*.mat'));
    if numel(roi_files) > 0
        set(handles.popupmenu_rois,'enable','on')
        roi_names = cell(numel(roi_files),1);
        for ij = 1:numel(roi_files)
            roi_names{ij} = roi_files(ij).name;
            if ~isempty(strfind(roi_files(ij).name,'ROIs_cells'))
                start_val = ij;
            end
        end
        set(handles.popupmenu_rois,'string',roi_names)
        set(handles.popupmenu_rois,'value',start_val)
        popupmenu_rois_Callback(hObject, eventdata, handles)
    else
        display('No rois found')
        set(handles.popupmenu_rois,'enable','off')
    end
    
    
    % Check if behaviour mode on
    val = get(handles.checkbox_behaviour,'Value');
    if val == 1
        set(handles.text_status,'String','Status: loading behaviour')
        drawnow
        base_path_behaviour = fullfile(handles.base_path, 'behaviour');
        session = [];
        session = load_session_data(base_path_behaviour);
        session = parse_session_data(1,session);
        % match scim behaviour trial numbers (assume one to one)
        im_session.behaviour_scim_trial_align = [1:numel(session.data)];
        
        % initialize global variables for scim alignment
        global remove_first;
        remove_first = 0;
        set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(session.data))]);
        set(handles.text_status,'String','Status: offline')
        drawnow
    end
    
    
    
    guidata(hObject, handles);
    
else
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_ref.
function popupmenu_ref_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ref contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ref

PathName = handles.data_dir;
ref_names = get(handles.popupmenu_ref,'string');
ref_val =  get(handles.popupmenu_ref,'value');

FileName = ref_names{ref_val};

overwrite = get(handles.checkbox_overwrite,'Value');

global im_session
load(fullfile(PathName,FileName));
name = FileName(12:end);
ref = post_process_ref_fft(ref);
im_session.ref = ref;
im_session.ref.path_name = PathName;
im_session.ref.file_name = name;

set(handles.text_num_planes,'String',sprintf('Num planes %d',im_session.ref.im_props.numPlanes))
set(handles.text_num_chan,'String',sprintf('Num channels %d',im_session.ref.im_props.nchans))

image_processing_gui_toggle_enable(handles,'on',[1 3 4 5 6])
if get(handles.checkbox_behaviour,'value') == 0
    set(handles.text_num_behaviour,'enable','off')
end

set(handles.text_align_chan,'Enable','on')
set(handles.text_align_chan,'String',['Align channel ' num2str(im_session.ref.im_props.align_chan)])

set(handles.pushbutton_data_dir,'enable','on')
set(handles.pushbutton_cluster_path,'enable','on')
set(handles.pushbutton_gen_text,'enable','on')

set(handles.text_time,'enable','off')
set(handles.text_status,'String','Status: offline')
drawnow


% --- Executes on selection change in popupmenu_rois.
function popupmenu_rois_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_rois contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_rois

PathName = handles.data_dir;
roi_names = get(handles.popupmenu_rois,'string');
roi_val =  get(handles.popupmenu_rois,'value');
FileName = roi_names{roi_val};
load(fullfile(PathName,FileName));
global im_session
im_session.ref.roi_array = roi_array;
set(handles.pushbutton_gen_catsa,'enable','on')
drawnow


% --- Executes during object creation, after setting all properties.
function popupmenu_rois_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_save_text.
function checkbox_save_text_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_save_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_save_text

%set(handles.togglebutton_register,'enable','off')
%set(handles.togglebutton_realtime_mode,'enable','off')


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

% --- Executes on button press in pushbutton_cluster_path.
function pushbutton_cluster_path_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cluster_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.togglebutton_register,'enable','off')
set(handles.togglebutton_realtime_mode,'enable','off')


start_path = handles.datastr;
folder_name = uigetdir(start_path);

if folder_name ~= 0
    handles.text_path = folder_name;
end
guidata(hObject, handles);


function edit_analyze_chan_Callback(hObject, eventdata, handles)
% hObject    handle to edit_analyze_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_analyze_chan as text
%        str2double(get(hObject,'String')) returns contents of edit_analyze_chan as a double

%set(handles.togglebutton_register,'enable','off')
%set(handles.togglebutton_realtime_mode,'enable','off')


% --- Executes during object creation, after setting all properties.
function edit_analyze_chan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_analyze_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function uipanel1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_behaviour.
function checkbox_behaviour_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_behaviour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_behaviour

if get(handles.checkbox_behaviour,'value') == 0
    set(handles.text_num_behaviour,'enable','off')
else
    set(handles.text_num_behaviour,'enable','on')
end


% --- Executes on button press in checkbox_use_cluster.
function checkbox_use_cluster_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_use_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_use_cluster



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in togglebutton_register.
function togglebutton_register_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_register (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

use_cluser = get(handles.checkbox_use_cluster,'Value');

if use_cluser
    evalScript = prepare_register_cluster;
    set(handles.togglebutton_register,'value',0);
else
    
    value = get(hObject,'Value');
    
    if value == 1
        tic;
        image_processing_gui_toggle_enable(handles,'off',[1 2])
        set(handles.pushbutton_data_dir,'enable','off')
        set(handles.togglebutton_register,'enable','on')
        set(handles.text_status,'enable','on')
        set(handles.text_registered_trials,'enable','on')
        set(handles.text_time,'Enable','on')
        set(handles.text_status,'String','Status: waiting')
        set(handles.pushbutton_gen_text,'enable','off')
        set(handles.pushbutton_gen_catsa,'enable','off')
        
        % Setup timer
        handles.obj_t = timer('TimerFcn',{@update_im_processing,handles});
        set(handles.obj_t,'ExecutionMode','fixedSpacing');
        set(handles.obj_t,'Period', .5);
        set(handles.obj_t,'BusyMode','drop');
        set(handles.obj_t,'ErrorFcn',@(obj,event)disp('Timing Error'));
        set(handles.obj_t,'UserData',0);
        
        global im_session;
        
        if ~isfield(im_session,'reg')
            % Setup registration
            setup_im_reg(handles);
        end
        
        
        % Check if behaviour mode on
        if get(handles.checkbox_behaviour,'Value');
            % match scim behaviour trial numbers (assume one to one)
            %global behaviour_scim_trial_align;
            %behaviour_scim_trial_align = [1:numel(session.data)];
            
            % Check if behaviour mode on
            global session;
            if isempty(session.data)
                set(handles.text_status,'String','Status: loading behaviour')
                drawnow
                base_path_behaviour = fullfile(handles.base_path, 'behaviour');
                session = [];
                session = load_session_data(base_path_behaviour);
                session = parse_session_data(1,session);
                % match scim behaviour trial numbers (assume one to one)
                im_session.behaviour_scim_trial_align = [1:numel(session.data)];
                
                % initialize global variables for scim alignment
                global remove_first;
                remove_first = 0;
                set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(session.data))]);
            end
        end
        
        % Update handles structure
        guidata(hObject, handles);
        start(handles.obj_t)        
    
    else
        stop(handles.obj_t);
        delete(handles.obj_t);
        
        image_processing_gui_toggle_enable(handles,'on',[1 2])
        set(handles.pushbutton_data_dir,'enable','on')
        
        time_elapsed_str = sprintf('Time online %.1f s',0);
        set(handles.text_time,'String',time_elapsed_str)
        set(handles.text_time,'Enable','off')
        set(handles.text_status,'String','Status: offline')
        set(handles.pushbutton_gen_text,'enable','on')
        global im_session
        if isfield(im_session.ref,'roi_array')
            set(handles.pushbutton_gen_catsa,'enable','on')
        end
    end
    
end

% --- Executes on button press in pushbutton_gen_catsa.
function pushbutton_gen_catsa_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gen_catsa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

neuropilDilationRange = [3 8];
neuropilSubSF = -1;

global im_session;
num_files = numel(im_session.basic_info.cur_files);
% Check if behaviour mode on
behaviour_on = get(handles.checkbox_behaviour,'Value');
global session;
if behaviour_on == 1
    num_files = min(num_files,numel(session.data));
end

num_files = min(num_files,length(im_session.reg.nFrames));

signalChannels = str2num(get(handles.edit_analyze_chan,'string'));
overwrite = get(handles.checkbox_overwrite,'Value');

roi_names =  get(handles.popupmenu_rois,'string');
roi_val =  get(handles.popupmenu_rois,'value');
roi_file_names = roi_names{roi_val};
file_name_tag = roi_file_names(6:end);
roi_tag_end = strfind(file_name_tag,'_');
file_name_tag = file_name_tag(1:roi_tag_end-1);


global session_ca;
session_ca = [];
if num_files > 0
    cur_status = get(handles.text_status,'String');
    set(handles.text_status,'String','Status: extracting CaTSA')
    drawnow
    save_path = fileparts(im_session.basic_info.data_dir);
    session_path = fullfile(save_path,'session');
    
    if exist(session_path) ~= 7
        mkdir(session_path);
    end
    
    caTSA_file_name = fullfile(session_path,['session_ca_data_' file_name_tag '.mat']);
    session_ca = get_session_ca(caTSA_file_name,num_files,neuropilDilationRange,signalChannels,neuropilSubSF,file_name_tag,overwrite);
    
    save_path = fileparts(im_session.basic_info.data_dir);
    session_path = fullfile(save_path,'session');
    if exist(session_path) ~= 7
        mkdir(session_path);
    end
    
    overwrite = get(handles.checkbox_overwrite,'Value');
    set(handles.text_status,'String','Status: saving session')
    drawnow
    save_common_data_format(session_path,file_name_tag,overwrite,num_files,behaviour_on,session,im_session,session_ca);
    set(handles.text_status,'String',cur_status)
    
else
    display('No files for CaTSA');
end


% --- Executes on button press in pushbutton_gen_text.
function pushbutton_gen_text_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gen_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im_session;
num_files = numel(im_session.basic_info.cur_files);
% Check if behaviour mode on
behaviour_on = get(handles.checkbox_behaviour,'Value');
if behaviour_on
    global session;
    num_files = min(num_files,numel(session.data));
end
analyze_chan = str2num(get(handles.edit_analyze_chan,'string'));

save_path = fileparts(im_session.basic_info.data_dir);
save_path = fullfile(save_path,'session');

if exist(save_path) ~= 7
    mkdir(save_path);
end

save_path_im = fullfile(save_path,['Text_images_' im_session.ref.file_name '.txt']);
overwrite = get(handles.checkbox_overwrite,'Value');

if overwrite ~= 1 && exist(save_path_im) == 2
    imaging_on = 0;
else
    imaging_on = 1;
end

use_cluser = get(handles.checkbox_use_cluster,'Value');

if use_cluser
    num_files = min(num_files,length(im_session.reg.nFrames));
    evalScript = prepare_text_cluster(num_files,analyze_chan);
    imaging_on = 0;
end

if num_files > 0
    cur_status = get(handles.text_status,'String');
    set(handles.text_status,'String','Status: extracting text')
    drawnow
    save_session_im_text(save_path,num_files,analyze_chan,imaging_on,behaviour_on);
    set(handles.text_status,'String',cur_status)
end
