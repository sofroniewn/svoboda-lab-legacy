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

% Last Modified by GUIDE v2.5 06-May-2014 09:26:41

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
set(handles.togglebutton_gen_catsa,'enable','off')
set(handles.pushbutton_prepare_spark,'enable','off')
set(handles.togglebutton_gen_text,'enable','off')
set(handles.checkbox_behaviour,'Value',1)
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
    image_processing_gui_toggle_enable(handles,'off',[1 3 4 5 6])
    set(handles.pushbutton_prepare_spark,'enable','off')
    set(handles.togglebutton_gen_catsa,'enable','off')
    set(handles.togglebutton_gen_text,'enable','off')
    set(handles.text_align_chan,'Enable','off')
    set(handles.text_align_chan,'String',['Align channel ' num2str(0)])
    
    set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(0)]);
    set(handles.text_registered_trials,'String',['Registered trials ' num2str(0)]);
    set(handles.text_imaging_trials,'String',['Imaging trials ' num2str(0)]);
    
    set(handles.text_status,'String','Status: offline')
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
    set(handles.popupmenu_ref,'enable','on')
    ref_files = dir(fullfile(handles.data_dir,'ref_images_*.mat'));
    if numel(ref_files) > 0
        %    set(handles.popupmenu_ref,'enable','on')
        ref_names = cell(numel(ref_files),1);
        for ij = 1:numel(ref_files)
            ref_names{ij} = ref_files(ij).name(1:end-4);
        end
        set(handles.popupmenu_ref,'string',ref_names)
        set(handles.popupmenu_ref,'value',1)
        popupmenu_ref_Callback(hObject, eventdata, handles)
    else
        display('No reference images found')
        %    set(handles.popupmenu_ref,'enable','off')
    end
    
    start_val = 1;
    % LOAD EXISTING ROIs
    set(handles.popupmenu_rois,'enable','on')
    roi_files = dir(fullfile(handles.data_dir,'ROIs_*.mat'));
    if numel(roi_files) > 0
        roi_names = cell(numel(roi_files),1);
        for ij = 1:numel(roi_files)
            roi_names{ij} = roi_files(ij).name(1:end-4);
            if ~isempty(strfind(roi_files(ij).name,'ROIs_cells'))
                start_val = ij;
            end
        end
        set(handles.popupmenu_rois,'string',roi_names)
        set(handles.popupmenu_rois,'value',start_val)
        popupmenu_rois_Callback(hObject, eventdata, handles)
    else
        display('No rois found')
    end
    
    
    % Check if behaviour mode on
    val = get(handles.checkbox_behaviour,'Value');
    if val == 1
        set(handles.text_status,'String','Status: loading behaviour')
        image_processing_gui_toggle_enable(handles,'off',[1 2])
        set(handles.pushbutton_data_dir,'enable','off')
        set(handles.togglebutton_gen_text,'enable','off')
        set(handles.togglebutton_gen_catsa,'enable','off')
        set(handles.pushbutton_prepare_spark,'enable','off')
        drawnow
        base_path_behaviour = fullfile(handles.base_path, 'behaviour');
        cur_file = dir(fullfile(handles.base_path,'behaviour','*_rig_config.mat'));
        if numel(cur_file)>0
            session = load_session_data(base_path_behaviour);
            session = parse_session_data(1,session);
            % match scim behaviour trial numbers (assume one to one)
            im_session.reg.behaviour_scim_trial_align = [1:numel(session.data)];
            set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(session.data))]);
        else
            set(handles.text_num_behaviour,'String',['Behaviour trials ' 'none']);
        end
        set(handles.text_status,'String','Status: offline')
        image_processing_gui_toggle_enable(handles,'on',[1 2])
        set(handles.pushbutton_data_dir,'enable','on')
        set(handles.togglebutton_gen_text,'enable','on')
        set(handles.togglebutton_gen_catsa,'enable','on')
        set(handles.pushbutton_prepare_spark,'enable','on')
        drawnow
    end
    
    guidata(hObject, handles);
end


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
if ischar(ref_names)
    ref_names = {ref_names};
end
FileName = [ref_names{ref_val} '.mat'];

num_refs = numel(ref_names);
ref_files = dir(fullfile(handles.data_dir,'ref_images_*.mat'));

if numel(ref_files) > 0
    if strcmp(FileName,'References.mat')
        ref_names = cell(numel(ref_files),1);
        for ij = 1:numel(ref_files)
            ref_names{ij} = ref_files(ij).name(1:end-4);
        end
        set(handles.popupmenu_ref,'string',ref_names)
        set(handles.popupmenu_ref,'value',1)
        FileName = ref_names{1};
    elseif numel(ref_files) > num_refs
        new_val = 1;
        ref_names = cell(numel(ref_files),1);
        for ij = 1:numel(ref_files)
            ref_names{ij} = ref_files(ij).name(1:end-4);
            if strcmp(FileName,ref_names{ij})
                new_val = ij;
            end
        end
        set(handles.popupmenu_ref,'string',ref_names)
        set(handles.popupmenu_ref,'value',new_val)
    else
    end
    
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
    set(handles.togglebutton_gen_text,'enable','on')
    
    set(handles.text_time,'enable','off')
    set(handles.text_status,'String','Status: offline')
    drawnow
else
    display('No reference images found')
    %    set(handles.popupmenu_ref,'enable','off')
end


% --- Executes on selection change in popupmenu_rois.
function popupmenu_rois_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_rois contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_rois

PathName = handles.data_dir;
roi_names = get(handles.popupmenu_rois,'string');
if ischar(roi_names)
    roi_names = {roi_names};
end
roi_val =  get(handles.popupmenu_rois,'value');
FileName = [roi_names{roi_val} '.mat'];

num_rois = numel(roi_names);
roi_files = dir(fullfile(handles.data_dir,'ROIs_*.mat'));

start_val = 1;

if numel(roi_files) > 0
    if strcmp(FileName,'ROIs.mat')
        roi_names = cell(numel(roi_files),1);
        for ij = 1:numel(roi_files)
            roi_names{ij} = roi_files(ij).name(1:end-4);
            if ~isempty(strfind(roi_files(ij).name,'ROIs_cells'))
                start_val = ij;
            end
        end
        set(handles.popupmenu_rois,'string',roi_names)
        set(handles.popupmenu_rois,'value',start_val)
        FileName = roi_names{start_val};
    elseif numel(roi_files) > num_rois
        roi_names = cell(numel(roi_files),1);
        for ij = 1:numel(roi_files)
            roi_names{ij} = roi_files(ij).name(1:end-4);
            if strcmp(FileName,roi_names{ij})
                start_val = ij;
            end
        end
        set(handles.popupmenu_ref,'string',roi_names)
        set(handles.popupmenu_ref,'value',start_val)
    else
    end
    
    load(fullfile(PathName,FileName));
    global im_session
    im_session.ref.roi_array = roi_array;
    im_session.ref.roi_array_fname = fullfile(PathName,FileName);
    set(handles.togglebutton_gen_catsa,'enable','on')
    drawnow
else
    display('No rois found')
end

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
        set(handles.togglebutton_gen_text,'enable','off')
        set(handles.togglebutton_gen_catsa,'enable','off')
        set(handles.pushbutton_prepare_spark,'enable','off')
        
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
        
        image_processing_gui_toggle_enable(handles,'on',[1 2])
        set(handles.pushbutton_data_dir,'enable','on')
        set(handles.pushbutton_prepare_spark,'enable','on')
        
        time_elapsed_str = sprintf('Time online %.1f s',0);
        set(handles.text_time,'String',time_elapsed_str)
        set(handles.text_time,'Enable','off')
        set(handles.text_status,'String','Status: offline')
        set(handles.togglebutton_gen_text,'enable','on')
        global im_session
        if isfield(im_session.ref,'roi_array')
            set(handles.togglebutton_gen_catsa,'enable','on')
        end
    end
    
end

% --- Executes on button press in togglebutton_gen_catsa.
function togglebutton_gen_catsa_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_gen_catsa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(hObject,'Value');
global im_session;

if value && isfield(im_session,'reg')
    
    neuropilDilationRange = [3 8];
    
    use_cluser = get(handles.checkbox_use_cluster,'Value');
    overwrite = get(handles.checkbox_overwrite,'Value');
    if use_cluser
        processedRoi = generate_roi_indices(im_session.ref.roi_array,neuropilDilationRange,im_session.ref.roi_array_fname,overwrite);
        evalScript = prepare_roi_extract_cluster;
    else
        
        neuropilSubSF = -1;
        
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
        
        global session_ca;
        session_ca = [];
        if num_files > 0
            try
                image_processing_gui_toggle_enable(handles,'off',[1 2])
                set(handles.pushbutton_data_dir,'enable','off')
                set(handles.togglebutton_register,'enable','off')
                set(handles.text_status,'enable','on')
                set(handles.text_registered_trials,'enable','on')
                set(handles.togglebutton_gen_text,'enable','off')
                set(handles.pushbutton_prepare_spark,'enable','off')
                
                set(handles.text_status,'String','Status: extracting CaTSA')
                drawnow
                save_path = fileparts(im_session.basic_info.data_dir);
                session_path = fullfile(save_path,'session');
                
                if exist(session_path) ~= 7
                    mkdir(session_path);
                end
                
                caTSA_file_name = fullfile(session_path,['session_ca_data_' file_name_tag '.mat']);
                session_ca = get_session_ca(caTSA_file_name,num_files,neuropilDilationRange,signalChannels,neuropilSubSF,file_name_tag,overwrite,handles);
                
                save_path = fileparts(im_session.basic_info.data_dir);
                session_path = fullfile(save_path,'session');
                if exist(session_path) ~= 7
                    mkdir(session_path);
                end
                
                overwrite = get(handles.checkbox_overwrite,'Value');
                set(handles.text_status,'String','Status: saving session')
                drawnow
                save_common_data_format(session_path,file_name_tag,overwrite,num_files,behaviour_on,session,im_session,session_ca);
                set(handles.text_status,'String','Status: waiting')
                image_processing_gui_toggle_enable(handles,'on',[1 2])
                set(handles.pushbutton_data_dir,'enable','on')
                set(handles.togglebutton_gen_text,'enable','on')
                set(handles.pushbutton_prepare_spark,'enable','on')
                set(hObject,'Value',0);
                drawnow
            catch
                 set(handles.text_status,'String','Status: canceled')
                 image_processing_gui_toggle_enable(handles,'on',[1 2])
                 set(handles.pushbutton_data_dir,'enable','on')
                 set(handles.togglebutton_gen_text,'enable','on')
                 set(handles.pushbutton_prepare_spark,'enable','on')
                 set(hObject,'Value',0);
                 drawnow
            end
            
        else
            set(hObject,'Value',0);
            display('No files for CaTSA');
        end
    end
else
    if ~isfield(im_session,'reg')
        fprintf('(text)  first register images\n');
    end
    set(hObject,'Value',0);
    set(handles.text_status,'String','Status: waiting')
    image_processing_gui_toggle_enable(handles,'on',[1 2])
    set(handles.pushbutton_data_dir,'enable','on')
    drawnow
end


% --- Executes on button press in togglebutton_gen_text.
function togglebutton_gen_text_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_gen_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(hObject,'Value');
global im_session;
imaging_on = 1;

if value && isfield(im_session,'reg')
    
    num_files = length(im_session.reg.nFrames);
    % Check if behaviour mode on
    behaviour_on = get(handles.checkbox_behaviour,'Value');
    if behaviour_on
        global session;
        num_files = min(num_files,numel(session.data));
    end
    
    analyze_chan = str2num(get(handles.edit_analyze_chan,'string'));
    down_sample = str2double(get(handles.edit_downsample,'String'));
    use_cluser = get(handles.checkbox_use_cluster,'Value');
    
    save_path = fileparts(im_session.basic_info.data_dir);
    save_path = fullfile(save_path,'session');
    
    if exist(save_path) ~= 7
        mkdir(save_path);
    end
    
    
    
    %save_path_im = fullfile(save_path,['Text_images_p01_c01.txt']);
    save_path_bv = fullfile(save_path,['Text_behaviour.mat']);
    overwrite = get(handles.checkbox_overwrite,'Value');
    if overwrite ~= 1 && exist(save_path_bv) == 2
        behaviour_on = 0;
        fprintf('(text)  behaviour EXISTS\n');
    end
    
    save_path_im = fullfile(save_path,['Text_images_p01_c01.txt']);
    overwrite = get(handles.checkbox_overwrite,'Value');
    if overwrite ~= 1 && exist(save_path_im) == 2
        imaging_on = 0;
        fprintf('(text)  images EXIST\n');
    else
        if use_cluser
            imaging_on = 0;
        end
    end
    
    image_processing_gui_toggle_enable(handles,'off',[1 2])
    set(handles.pushbutton_data_dir,'enable','off')
    set(handles.togglebutton_register,'enable','off')
    set(handles.text_status,'enable','on')
    set(handles.text_registered_trials,'enable','on')
    set(handles.togglebutton_gen_catsa,'enable','off')
    set(handles.pushbutton_prepare_spark,'enable','off')
    
    if behaviour_on || imaging_on
        if num_files > 0
            cur_status = get(handles.text_status,'String');
            set(handles.text_status,'String','Status: extracting text')
            drawnow
            save_session_im_text(save_path,num_files,analyze_chan,down_sample,imaging_on,behaviour_on,handles);
            set(handles.text_status,'String',cur_status)
        end
        set(handles.text_status,'String','Status: waiting')
    end
    
    if overwrite ~= 1 && exist(save_path_im) == 2
    else
        if use_cluser
            fprintf('(text)  images DO NOT EXIST\n');
            evalScript = prepare_text_cluster(num_files,analyze_chan,down_sample);
        end
    end
    
    image_processing_gui_toggle_enable(handles,'on',[1 2])
    set(handles.pushbutton_data_dir,'enable','on')
    set(handles.togglebutton_gen_catsa,'enable','on')
    set(handles.pushbutton_prepare_spark,'enable','on')
    set(hObject,'Value',0);
    drawnow
    
else
    if ~isfield(im_session,'reg')
        fprintf('(text) register images before generating text \n');
    end
    set(hObject,'Value',0);
    set(handles.text_status,'String','Status: waiting')
    image_processing_gui_toggle_enable(handles,'on',[1 2])
    set(handles.pushbutton_data_dir,'enable','on')
    drawnow
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


% --- Executes on button press in pushbutton_prepare_spark.
function pushbutton_prepare_spark_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_prepare_spark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

overwrite = get(handles.checkbox_overwrite,'Value');
behaviour_on = get(handles.checkbox_behaviour,'Value');


global im_session;
save_path = fileparts(im_session.basic_info.data_dir);
save_path = fullfile(save_path,'session');
save_path_bv = fullfile(save_path,['Text_behaviour.mat']);

if behaviour_on && exist(save_path_bv) ~= 2
    fprintf('(spark) no behaviour matrix present please make\n');
else
    prepare_spark(save_path,behaviour_on,overwrite)
end
