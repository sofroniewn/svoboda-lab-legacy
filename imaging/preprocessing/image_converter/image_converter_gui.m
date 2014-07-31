function varargout = image_converter_gui(varargin)
% IMAGE_CONVERTER_GUI MATLAB code for image_converter_gui.fig
%      IMAGE_CONVERTER_GUI, by itself, creates a new IMAGE_CONVERTER_GUI or raises the existing
%      singleton*.
%
%      H = IMAGE_CONVERTER_GUI returns the handle to a new IMAGE_CONVERTER_GUI or the handle to
%      the existing singleton*.
%
%      IMAGE_CONVERTER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_CONVERTER_GUI.M with the given input arguments.
%
%      IMAGE_CONVERTER_GUI('Property','Value',...) creates a new IMAGE_CONVERTER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before image_converter_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to image_converter_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help image_converter_gui

% Last Modified by GUIDE v2.5 22-May-2014 13:59:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @image_converter_gui_OpeningFcn, ...
    'gui_OutputFcn',  @image_converter_gui_OutputFcn, ...
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


% --- Executes just before image_converter_gui is made visible.
function image_converter_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to image_converter_gui (see VARARGIN)

% Choose default command line output for image_converter_gui
handles.output = hObject;
handles.datastr = pwd;

set(handles.pushbutton_set_output_dir,'enable','off')
set(handles.togglebutton_start,'enable','off')
%set(handles.edit_num_frames,'enable','off')
set(handles.checkbox_overwrite,'enable','off')
%set(handles.text_num_frames,'enable','off')
set(handles.text_time,'enable','off')
set(handles.text_done,'enable','off')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes image_converter_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = image_converter_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton_set_dir.
function pushbutton_set_dir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_set_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start_path = handles.datastr;
folder_name = uigetdir(start_path);

if folder_name ~= 0
    handles.data_dir = folder_name;
    handles.output_dir = fullfile(folder_name,'scanimage','streaming');
    
    % Check number of imaging files
    global im_conv_session;
    cur_files = dir(fullfile(handles.data_dir,'scanimage','summary','*_summary_*.mat'));
    im_conv_session.cur_files = cur_files;
    overwrite = get(handles.checkbox_overwrite,'value');
    if overwrite
        im_conv_session.num_conv = 0;
    else
        cur_files = dir(fullfile(handles.output_dir,'*.bin'));
        im_conv_session.num_conv = numel(cur_files);
    end
    
    set(handles.text_done,'String',['Files converted ' num2str(im_conv_session.num_conv) '/' num2str(numel(im_conv_session.cur_files))]);
    
    set(handles.pushbutton_set_output_dir,'enable','on')
    %set(handles.edit_num_frames,'enable','on')
    set(handles.checkbox_overwrite,'enable','on')
    %set(handles.text_num_frames,'enable','on')
    set(handles.text_done,'enable','on')
    
    guidata(hObject, handles);
end

% --- Executes on button press in pushbutton_set_output_dir.
function pushbutton_set_output_dir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_set_output_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start_path = handles.datastr;
folder_name = uigetdir(start_path);

if folder_name ~= 0
    handles.output_dir = fullfile(folder_name,'streaming');
    
    if exist(handles.output_dir) ~= 7
        mkdir(handles.output_dir)
    end
    
    if exist([handles.output_dir '_tmp']) ~= 7
        mkdir([handles.output_dir '_tmp'])
    end
    
    ref_files = dir(fullfile(handles.data_dir,'scanimage','ref_images_*.mat'));
    if numel(ref_files) > 0
        load(fullfile(handles.data_dir,'scanimage',ref_files(1).name));
        im_props = ref.im_props;
    else
        display('No reference images found, use defaults')
        im_props.nchans = 1;
        im_props.numPlanes = 4;
        im_props.height = 512;
        im_props.width = 512;
    end
    
    varNames = {'corPos'};
    binVals = {[0:2:30]};
    save_streaming_config(handles.output_dir,varNames,binVals,im_props);
    
    % Check number of imaging files
    global im_conv_session;
    overwrite = get(handles.checkbox_overwrite,'value');
    if overwrite
        im_conv_session.num_conv = 0;
    else
        cur_files = dir(fullfile(handles.output_dir,'*.bin'));
        im_conv_session.num_conv = numel(cur_files);
    end
    
    set(handles.togglebutton_start,'enable','on')  
    guidata(hObject, handles);
end

% --- Executes on button press in togglebutton_start.
function togglebutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_start


value = get(hObject,'Value');

if value == 1
    tic;
    
    set(handles.pushbutton_set_dir,'enable','off')
    set(handles.pushbutton_set_output_dir,'enable','off')
    %set(handles.edit_num_frames,'enable','off')
    set(handles.checkbox_overwrite,'enable','off')
    %set(handles.text_num_frames,'enable','off')
    
    % Setup timer
    set(handles.text_time,'Enable','on')
    handles.obj_t = timer('TimerFcn',{@update_image_converter,handles});
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
    
    set(handles.pushbutton_set_dir,'enable','on')
    set(handles.pushbutton_set_output_dir,'enable','on')
    %set(handles.edit_num_frames,'enable','on')
    set(handles.checkbox_overwrite,'enable','on')
    %set(handles.text_num_frames,'enable','on')
    
    time_elapsed_str = sprintf('Time online %.1f s',0);
    set(handles.text_time,'String',time_elapsed_str)
    set(handles.text_time,'Enable','off')
end


% --- Executes on button press in checkbox_overwrite.
function checkbox_overwrite_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_overwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_overwrite
% Check number of imaging files
global im_conv_session;
overwrite = get(handles.checkbox_overwrite,'value');
if overwrite
    im_conv_session.num_conv = 0;
else
    cur_files = dir(fullfile(handles.output_dir,'*.bin'));
    im_conv_session.num_conv = numel(cur_files);
end
set(handles.text_done,'String',['Files converted ' num2str(im_conv_session.num_conv) '/' num2str(numel(im_conv_session.cur_files))]);
