function varargout = image_viewer_GUI(varargin)
% IMAGE_VIEWER_GUI MATLAB code for image_viewer_GUI.fig
%      IMAGE_VIEWER_GUI, by itself, creates a new IMAGE_VIEWER_GUI or raises the existing
%      singleton*.
%
%      H = IMAGE_VIEWER_GUI returns the handle to a new IMAGE_VIEWER_GUI or the handle to
%      the existing singleton*.
%
%      IMAGE_VIEWER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_VIEWER_GUI.M with the given input arguments.
%
%      IMAGE_VIEWER_GUI('Property','Value',...) creates a new IMAGE_VIEWER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before image_viewer_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to image_viewer_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help image_viewer_GUI

% Last Modified by GUIDE v2.5 09-May-2014 13:25:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @image_viewer_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @image_viewer_GUI_OutputFcn, ...
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


% --- Executes just before image_viewer_GUI is made visible.
function image_viewer_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to image_viewer_GUI (see VARARGIN)

% Choose default command line output for image_viewer_GUI
set(hObject,'HandleVisibility','on')
handles.output = hObject;
handles.datastr = pwd;

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);
handles.pathstr = pathstr;

% List plot function options
plot_list = dir(fullfile(handles.pathstr,'accessory_fns','plot_functions','*.m'));
plot_names = cell(numel(plot_list),1);
ref_val = 1;
for ij = 1:numel(plot_list)
    plot_names{ij} = plot_list(ij).name;
    if strcmp(plot_names{ij},'plot_ref_images.m')
        ref_val = ij;
    end
end
set(handles.popupmenu_list_plots,'string',plot_names)
set(handles.popupmenu_list_plots,'value',ref_val)
set(handles.popupmenu_list_plots,'UserData',ref_val);

% Prepare global variables
clear global im_session;
global im_session;

% Setup spark analysis output
[stim_types range_array] = setupReg_spark;
set(handles.popupmenu_spark_regressors,'string',stim_types)
ref_val = 1;
set(handles.popupmenu_spark_regressors,'value',ref_val)
set(handles.popupmenu_spark_regressors,'UserData',ref_val);

im_session.spark_output.mean = [];
im_session.spark_output.localcorr = [];
im_session.spark_output.regressor.names = stim_types;
im_session.spark_output.regressor.stats = cell(numel(stim_types),1);
im_session.spark_output.regressor.tune = cell(numel(stim_types),1);
im_session.spark_output.regressor.range = range_array;
im_session.spark_output.regressor.cur_ind = ref_val;
im_session.spark_output.streaming.tune = [];
im_session.spark_output.streaming.stats = [];

% Disable buttons
image_viewer_gui_toggle_enable(handles,'off',[1 3 4 5 6 7])

% Setup axes
axes(handles.axes_images)
set(handles.axes_images,'HandleVisibility','on')
imshow(zeros(512,512))
handles.cbar_axes = [];

size_lateral_displacements = 20;
edges_lateral_displacements= [-size_lateral_displacements:size_lateral_displacements];
handles.edges_lateral_displacements = edges_lateral_displacements;

size_axial_displacements = 20;
edges_axial_displacements= [-size_axial_displacements:size_axial_displacements];
handles.edges_axial_displacements = edges_axial_displacements;

axes(handles.axes_shifts)
set(handles.axes_shifts,'HandleVisibility','on')
hold on
imagesc([-size_lateral_displacements size_lateral_displacements],[-size_lateral_displacements size_lateral_displacements],ones(2*size_lateral_displacements,2*size_lateral_displacements),[0 1])
plot([0,0],[-size_lateral_displacements size_lateral_displacements],'k','LineWidth',2);
plot([-size_lateral_displacements size_lateral_displacements],[0,0],'k','LineWidth',2);
handles.plot_shift_up = plot([0,0],[-size_lateral_displacements size_lateral_displacements],'r','LineWidth',2);
handles.plot_shift_across = plot([-size_lateral_displacements size_lateral_displacements],[0,0],'r','LineWidth',2);
xlim([-size_lateral_displacements size_lateral_displacements])
ylim([-size_lateral_displacements size_lateral_displacements])
set(gca,'xtick',[])
set(gca,'ytick',[])
axis equal

axes(handles.axes_x_hist)
set(handles.axes_x_hist,'HandleVisibility','on')
handles.plot_x_hist = plot(edges_lateral_displacements,zeros(size(edges_lateral_displacements)),'r','LineWidth',2);
ylim([0 1])
set(gca,'ytick',[])
set(gca,'xtick',[-size_lateral_displacements:size_lateral_displacements/2:size_lateral_displacements])
set(gca,'box','off')
ylabel('x')

axes(handles.axes_y_hist)
set(handles.axes_y_hist,'HandleVisibility','on')
handles.plot_y_hist = plot(zeros(size(edges_lateral_displacements)),edges_lateral_displacements,'r','LineWidth',2);
xlim([0 1])
set(gca,'xtick',[])
set(gca,'ytick',[-size_lateral_displacements:size_lateral_displacements/2:size_lateral_displacements])
set(gca,'box','off')
xlabel('y')

axes(handles.axes_z_hist)
set(handles.axes_z_hist,'HandleVisibility','on')
handles.plot_z_hist = plot(zeros(size(edges_axial_displacements)),edges_axial_displacements,'r','LineWidth',2);
xlim([0 1])
set(gca,'xtick',[])
set(gca,'ytick',[-size_axial_displacements:size_axial_displacements/2:size_axial_displacements])
set(gca,'box','off')
xlabel('z')


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes image_viewer_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = image_viewer_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
cur_pos = get(handles.figure1,'Position');
cur_pos(1) = 7;
cur_pos(2) = 138;
set(handles.figure1,'Position',cur_pos)

% --- Executes on selection change in popupmenu_list_plots.
function popupmenu_list_plots_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_list_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_list_plots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_list_plots

plot_im_gui(handles,0);

% --- Executes during object creation, after setting all properties.
function popupmenu_list_plots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_list_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_data_dir.
function pushbutton_data_dir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_data_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start_path = handles.datastr;
folder_name = uigetdir(start_path);

if folder_name ~= 0
    % CLEAR AXES
    axes(handles.axes_images)
    cla;
    imshow(zeros(512,512))
    
    %cla(handles.axes1)
    
    % disable gui buttons that should not be used
    image_viewer_gui_toggle_enable(handles,'off',[1 3 4 5 6 7])
    set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(0)]);
    set(handles.text_registered_trials,'String',['Registered trials ' num2str(0)]);
    set(handles.text_imaging_trials,'String',['Imaging trials ' num2str(0)]);
    
    set(handles.edit_trial_num,'String',num2str(0))
    set(handles.slider_trial_num,'max',1)
    set(handles.slider_trial_num,'SliderStep',[1 1])
    set(handles.slider_trial_num,'Value',0);
    
    ref_val = get(handles.popupmenu_list_plots,'UserData');
    set(handles.popupmenu_list_plots,'Value',ref_val)
    
    ref_val = get(handles.popupmenu_spark_regressors,'UserData');
    set(handles.popupmenu_spark_regressors,'Value',ref_val)
    
    % Prepare global variables
    clear global im_session
    global im_session;
    
    handles.base_path = folder_name;
    handles.data_dir = fullfile(handles.base_path, 'scanimage');
    
    handles.output_dir = fullfile(handles.base_path, 'session');
    
    % Load in im_session
    im_session = load_im_session_data(handles.data_dir);
    
    [stim_types range_array] = setupReg_spark;
    im_session.spark_output.mean = [];
    im_session.spark_output.localcorr = [];
    im_session.spark_output.regressor.names = stim_types;
    im_session.spark_output.regressor.stats = cell(numel(stim_types),1);
    im_session.spark_output.regressor.tune = cell(numel(stim_types),1);
    im_session.spark_output.regressor.range = range_array;
    im_session.spark_output.regressor.cur_ind = get(handles.popupmenu_spark_regressors,'UserData');
    im_session.spark_output.streaming.tune = [];
    im_session.spark_output.streaming.stats = [];
    
    set(handles.text_anm,'Enable','on')
    set(handles.text_date,'Enable','on')
    set(handles.text_run,'Enable','on')
    set(handles.text_imaging_trials,'Enable','on')
    
    set(handles.text_anm,'String',im_session.basic_info.anm_str)
    set(handles.text_date,'String',im_session.basic_info.date_str)
    set(handles.text_run,'String',im_session.basic_info.run_str)
    set(handles.text_imaging_trials,'String',['Imaging trials ' num2str(numel(im_session.basic_info.cur_files))]);
    
    type_name = 'text';
    handles.text_path = fullfile(im_session.basic_info.data_dir,type_name);
    
    set(handles.pushbutton_load_ref,'enable','on')
    set(handles.pushbutton_previous_ref,'enable','on')
    guidata(hObject, handles);
    
    
    % Load in reference image if there (take first one)
    ref_files = dir(fullfile(handles.data_dir,'ref_images_*.mat'));
    if numel(ref_files) > 0
        ref_images_startup = ref_files(1).name;
        pushbutton_load_ref_Callback(hObject, eventdata, handles,ref_images_startup)
        % Load in spark
        load_spark_maps(handles.output_dir,1);
    end
    
    % Update behaviour trials
    cur_file = dir(fullfile(handles.base_path,'behaviour','*_rig_config.mat'));
    if numel(cur_file)>0
        cur_bv_files = dir(fullfile(handles.base_path,'behaviour','*_trial_*.mat'));
        set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(cur_bv_files)-1)]);
        set(handles.text_num_behaviour,'UserData',numel(cur_bv_files)-1)
    else
        set(handles.text_num_behaviour,'String',['Behaviour trials ' 'off']);
        set(handles.text_num_behaviour,'UserData',-1)
    end
end

guidata(hObject, handles);



% --- Executes on button press in checkbox_plot_shifts.
function checkbox_plot_shifts_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_plot_shifts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_plot_shifts


% --- Executes on button press in checkbox_plot_images.
function checkbox_plot_images_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_plot_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_plot_images



function edit_align_channel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_align_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_align_channel as text
%        str2double(get(hObject,'String')) returns contents of edit_align_channel as a double


% --- Executes during object creation, after setting all properties.
function edit_align_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_align_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_display_chan_Callback(hObject, eventdata, handles)
% hObject    handle to edit_display_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_display_chan as text
%        str2double(get(hObject,'String')) returns contents of edit_display_chan as a double


% --- Executes during object creation, after setting all properties.
function edit_display_chan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_display_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_load_ref.
function pushbutton_load_ref_Callback(hObject, eventdata, handles,varargin)
% hObject    handle to pushbutton_load_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if nargin == 3
    start_path = fullfile(handles.base_path,'scanimage','*.*');
    [FileName,PathName,FilterIndex] = uigetfile(start_path);
    prev_ref = 0;
elseif nargin == 4
    PathName = handles.data_dir;
    FileName = varargin{1};
    prev_ref = 0;
elseif nargin == 5
    FileName = varargin{1};
    PathName = varargin{2};
    prev_ref = 1;
end

if FileName ~= 0
    image_viewer_gui_toggle_enable(handles,'off',[1 3 4 5 6 7])
    set(handles.pushbutton_data_dir,'enable','off')
    set(handles.pushbutton_load_ref,'enable','off')
    set(handles.pushbutton_previous_ref,'enable','off')
    set(handles.text_anm,'Enable','on')
    set(handles.text_date,'Enable','on')
    set(handles.text_run,'Enable','on')
    set(handles.text_imaging_trials,'Enable','off')
    drawnow
    overwrite = 0;
    
    global im_session
    [pathstr,name,ext] = fileparts(FileName);
    if strcmp(ext,'.mat') == 1
        load(fullfile(PathName,FileName));
        if ~strcmp(PathName,fullfile(handles.base_path,'scanimage')) && ~prev_ref
            save(fullfile(handles.base_path,'scanimage',FileName),'ref');
        end
    elseif strcmp(ext,'.tif') == 1
        [pathstr,name,ext] = fileparts(FileName);
        if exist(fullfile(PathName,['ref_images_' name '.mat'])) == 2 && overwrite == 0
            load(fullfile(PathName,['ref_images_' name '.mat']));
            if ~strcmp(PathName,fullfile(handles.base_path,'scanimage')) && ~prev_ref
                save(fullfile(handles.base_path,'scanimage',['ref_images_' name '.mat']),'ref');
            end
        else
            align_chan = str2num(get(handles.edit_align_channel,'string'));
            ref = generate_reference(fullfile(PathName,FileName),align_chan,1);
            if ~strcmp(PathName,fullfile(handles.base_path,'scanimage')) && ~prev_ref
                [pathstr,name,ext] = fileparts(FileName);
                save(fullfile(handles.base_path,'scanimage',['ref_images_' name '.mat']),'ref');
            end
        end
    else
        error('Wrong file type for reference')
    end
    
    if strcmp(name(1:11),'ref_images_')
        name = name(12:end);
    end
    ref = post_process_ref_fft(ref);
    ref.path_name = PathName;
    ref.file_name = name;
    ref = add_ref_accesory_images(PathName,ref);
    
    im_session.realtime.num_avg = 10;
    im_session.realtime.im_raw = zeros(ref.im_props.height,ref.im_props.width,ref.im_props.numPlanes,im_session.realtime.num_avg,'uint16');
    im_session.realtime.im_adj = zeros(ref.im_props.height,ref.im_props.width,ref.im_props.numPlanes,im_session.realtime.num_avg,'uint16');
    im_session.realtime.corr_vals = zeros(length(handles.edges_lateral_displacements),length(handles.edges_lateral_displacements),ref.im_props.numPlanes,im_session.realtime.num_avg,'single');
    im_session.realtime.shifts = zeros(2,ref.im_props.numPlanes,im_session.realtime.num_avg,'single');
    im_session.realtime.ind = 1;
    im_session.realtime.start = 0;
    
    roi_file_names = dir(fullfile(PathName,['ROIs_*.mat']));
    if numel(roi_file_names) > 0
        if exist(fullfile(PathName,['ROIs_cells.mat'])) == 2
            load(fullfile(PathName,['ROIs_cells.mat']));
            set(handles.edit_rois_name,'String','cells');
        else
            load(fullfile(PathName,roi_file_names(1).name))
            file_name_tag = roi_file_names(1).name(6:end-4);
            set(handles.edit_rois_name,'String',file_name_tag);
        end
        ref.roi_array = roi_array;
    end
    
    %set(handles.text_registered_trials,'String',['Registered trials ' num2str(0)]);
    %  set(handles.slider_trial_num,'max',1)
    %  set(handles.slider_trial_num,'SliderStep',[1 1])
    set(handles.edit_trial_num,'String',num2str(0))
    set(handles.slider_trial_num,'Value',0);
    set(handles.text_num_planes,'String',sprintf('Num planes %d',ref.im_props.numPlanes))
    set(handles.text_num_chan,'String',sprintf('Num channels %d',ref.im_props.nchans))
    
    if prev_ref
        im_session.prev_ref = ref;
        set(handles.popupmenu_ref_selector,'value',2)
    else
        im_session.ref = ref;
        set(handles.popupmenu_ref_selector,'value',1)
    end
    image_viewer_gui_toggle_enable(handles,'on',[1 3 4 5 6 7])
    set(handles.pushbutton_data_dir,'enable','on')
    set(handles.pushbutton_load_ref,'enable','on')
    set(handles.pushbutton_previous_ref,'enable','on')
    set(handles.slider_trial_num,'enable','on')
    set(handles.edit_trial_num,'enable','on')
    
    %set(handles.togglebutton_online_mode,'enable','off')
    %set(handles.togglebutton_realtime_mode,'enable','off')
    set(handles.text_time,'enable','off')
    plot_im_gui(handles,1);
    drawnow
end


% --- Executes on button press in togglebutton_online_mode.
function togglebutton_online_mode_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_online_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(hObject,'Value');

if value == 1
    tic;
    
    image_viewer_gui_toggle_enable(handles,'off',[7])
    set(handles.pushbutton_load_ref,'enable','off')
    set(handles.pushbutton_previous_ref,'enable','off')
    set(handles.pushbutton_data_dir,'enable','off')
    set(handles.togglebutton_realtime_mode,'enable','off')
    
    % Setup timer
    set(handles.text_time,'Enable','on')
    handles.obj_t = timer('TimerFcn',{@update_image_viewer,handles});
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
    
    image_viewer_gui_toggle_enable(handles,'on',[7])
    set(handles.pushbutton_load_ref,'enable','on')
    set(handles.pushbutton_previous_ref,'enable','on')
    set(handles.pushbutton_data_dir,'enable','on')
    set(handles.togglebutton_realtime_mode,'enable','on')
    
    
    time_elapsed_str = sprintf('Time online %.1f s',0);
    set(handles.text_time,'String',time_elapsed_str)
    set(handles.text_time,'Enable','off')
end


% --- Executes on button press in togglebutton_realtime_mode.
function togglebutton_realtime_mode_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_realtime_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(hObject,'Value');

if value == 1
    tic;
    image_viewer_gui_toggle_enable(handles,'off',[1 2])
    %  set(handles.slider_trial_num,'enable','on')
    %  set(handles.edit_trial_num,'enable','on')
    set(handles.pushbutton_set_output_dir,'enable','off')
    set(handles.pushbutton_data_dir,'enable','off')
    set(handles.pushbutton_load_ref,'enable','off')
    set(handles.pushbutton_previous_ref,'enable','off')
    set(handles.togglebutton_realtime_mode,'enable','on')
    %   set(handles.text_anm,'Enable','on')
    %   set(handles.text_date,'Enable','on')
    %   set(handles.text_run,'Enable','on')
    %   set(handles.text_imaging_trials,'enable','on')
    set(handles.text_time,'Enable','on')
    
    % Setup timer
    handles.obj_t_realtime = timer('TimerFcn',{@update_im_realtime,handles});
    set(handles.obj_t_realtime,'ExecutionMode','fixedSpacing');
    set(handles.obj_t_realtime,'Period', .01);
    set(handles.obj_t_realtime,'BusyMode','drop');
    set(handles.obj_t_realtime,'ErrorFcn',@(obj,event)disp('Realtime timing Error'));
    set(handles.obj_t_realtime,'UserData',0);
    
    % set(handles.text_elapsed_time,'Enable','on')
    
    global im_session;
    prev_ref = get(handles.popupmenu_ref_selector,'Value')-1;
    if prev_ref
        ref = im_session.prev_ref;
    else
        ref = im_session.ref;
    end
    
    % setup memory map
    filename = fullfile(handles.data_dir,'memmap.dat');
    % Create the communications file if it is not already there.
    if exist(filename)~= 2
        [f, msg] = fopen(filename, 'wb');
        if f ~= -1
            fwrite(f, zeros(ref.im_props.height*ref.im_props.width*ref.im_props.numPlanes+1,1,'uint16'), 'uint16');
            fclose(f);
        else
            error('MATLAB:demo:send:cannotOpenFile', ...
                'Cannot open file "%s": %s.', filename, msg);
        end
    end
    
    global mmap_data;
    mmap_data = memmapfile(filename, 'Writable', true, ...
        'Format', 'uint16');
    global old_mmap_frame_num
    old_mmap_frame_num = 0;
    
    im_session.realtime.num_avg = 10;
    im_session.realtime.im_raw = zeros(ref.im_props.height,ref.im_props.width,ref.im_props.numPlanes,im_session.realtime.num_avg,'uint16');
    im_session.realtime.im_adj = zeros(ref.im_props.height,ref.im_props.width,ref.im_props.numPlanes,im_session.realtime.num_avg,'uint16');
    im_session.realtime.corr_vals = zeros(length(handles.edges_lateral_displacements),length(handles.edges_lateral_displacements),ref.im_props.numPlanes,im_session.realtime.num_avg,'single');
    im_session.realtime.shifts = zeros(2,ref.im_props.numPlanes,im_session.realtime.num_avg,'single');
    im_session.realtime.ind = 1;
    im_session.realtime.start = 0;
    
    update_im = get(handles.checkbox_plot_images,'value');
    contents = cellstr(get(handles.popupmenu_list_plots,'String'));
    plot_str = contents{get(handles.popupmenu_list_plots,'Value')};
    
    if update_im == 1 && strcmp(plot_str,'plot_realtime_raw.m') == 1
        plot_im_gui(handles,0);
    end
    
    % Update handles structure
    guidata(hObject, handles);
    
    % Start Timer
    start(handles.obj_t_realtime)
    
else
    stop(handles.obj_t_realtime);
    delete(handles.obj_t_realtime);
    
    image_viewer_gui_toggle_enable(handles,'on',[1 2])
    set(handles.pushbutton_load_ref,'enable','on')
    set(handles.pushbutton_previous_ref,'enable','on')
    set(handles.pushbutton_data_dir,'enable','on')
    set(handles.pushbutton_set_output_dir,'enable','on')
    
    time_elapsed_str = sprintf('Time online %.1f s',0);
    set(handles.text_time,'String',time_elapsed_str)
    set(handles.text_time,'Enable','off')
end


% --- Executes on slider movement.
function slider_look_up_table_Callback(hObject, eventdata, handles)
% hObject    handle to slider_look_up_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

c_lim_2 = round(get(handles.slider_look_up_table,'Value'));
if c_lim_2 > 4096
    c_lim_2 = 4096;
    set(handles.slider_look_up_table,'Value',c_lim_2)
end

c_lim_1 = round(get(handles.slider_look_up_table_black,'Value'));
if c_lim_2 < c_lim_1 + 1
    c_lim_2 = c_lim_1 + 1;
    set(handles.slider_look_up_table,'Value',c_lim_2)
end

set(handles.edit_look_up_table,'String',num2str(c_lim_2));
plot_im_gui(handles,0);


% --- Executes during object creation, after setting all properties.
function slider_look_up_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_look_up_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edit_look_up_table_Callback(hObject, eventdata, handles)
% hObject    handle to edit_look_up_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_look_up_table as text
%        str2double(get(hObject,'String')) returns contents of edit_look_up_table as a double

val = str2double(get(hObject,'String'));
set(handles.slider_look_up_table,'Value',val);
slider_look_up_table_Callback(handles.slider_look_up_table,eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_look_up_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_look_up_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_display_planes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_display_planes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_display_planes as text
%        str2double(get(hObject,'String')) returns contents of edit_display_planes as a double

%c_lim = round(get(handles.slider_look_up_table_black,'Value'));
%set(handles.edit_look_up_table_black,'String',num2str(c_lim);
roi_draw_mode = get(handles.togglebutton_draw_rois,'Value');
if roi_draw_mode
    plot_planes_str = get(handles.edit_display_planes,'string');
    plot_planes = eval(plot_planes_str);
    if length(plot_planes) > 1;
        plot_planes = plot_planes(1);
        set(handles.edit_display_planes,'string',num2str(plot_planes))
        fprintf('Can only select a single plane when roi draw mode on')
    end
end
plot_im_gui(handles,1);
if roi_draw_mode
    set(handles.togglebutton_draw_rois,'Value',1);
    togglebutton_draw_rois_Callback(handles.togglebutton_draw_rois, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function edit_display_planes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_display_planes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_look_up_table_black_Callback(hObject, eventdata, handles)
% hObject    handle to slider_look_up_table_black (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

c_lim_1 = round(get(handles.slider_look_up_table_black,'Value'));
if c_lim_1 < 0
    c_lim_1 = 0;
    set(handles.slider_look_up_table_black,'Value',c_lim_1)
end

c_lim_2 = round(get(handles.slider_look_up_table,'Value'));
if c_lim_1 > c_lim_2 - 1
    c_lim_1 = c_lim_2 - 1;
    set(handles.slider_look_up_table_black,'Value',c_lim_1)
end

set(handles.edit_look_up_table_black,'String',num2str(c_lim_1));

plot_im_gui(handles,0);


% --- Executes during object creation, after setting all properties.
function slider_look_up_table_black_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_look_up_table_black (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edit_look_up_table_black_Callback(hObject, eventdata, handles)
% hObject    handle to edit_look_up_table_black (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_look_up_table_black as text
%        str2double(get(hObject,'String')) returns contents of edit_look_up_table_black as a double

val = str2double(get(hObject,'String'));
set(handles.slider_look_up_table_black,'Value',val);
slider_look_up_table_Callback(handles.slider_look_up_table_black,eventdata, handles);


% --- Executes during object creation, after setting all properties.
function edit_look_up_table_black_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_look_up_table_black (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_trial_num_Callback(hObject, eventdata, handles)
% hObject    handle to slider_trial_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = get(hObject,'Value');
val = round(val);
global im_session
if isempty(im_session.reg.nFrames)
    val = 0;
end
set(handles.slider_trial_num,'Value',val);
set(handles.edit_trial_num,'String',num2str(val));

plot_im_gui(handles,0);


% --- Executes during object creation, after setting all properties.
function slider_trial_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_trial_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_trial_num_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trial_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trial_num as text
%        str2double(get(hObject,'String')) returns contents of edit_trial_num as a double

val = str2double(get(hObject,'String'));
global im_session
if isempty(im_session.reg.nFrames)
    val = 0;
end
set(handles.slider_trial_num,'Value',val);
slider_trial_num_Callback(handles.slider_trial_num,eventdata, handles);



% --- Executes during object creation, after setting all properties.
function edit_trial_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trial_num (see GCBO)
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


% --- Executes on button press in togglebutton_draw_rois.
function togglebutton_draw_rois_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_draw_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

roi_draw_mode = get(handles.togglebutton_draw_rois,'Value');
plot_planes_str = get(handles.edit_display_planes,'string');
plot_planes = eval(plot_planes_str);
if length(plot_planes) > 1;
    plot_planes = plot_planes(1);
    set(handles.edit_display_planes,'string',num2str(plot_planes))
    fprintf('Can only select a single plane when roi draw mode on')
end

global im_session

if roi_draw_mode
    overwrite = 0;
    draw_rois(overwrite);
    set(handles.pushbutton_save_rois,'enable','on')
    plot_im_gui(handles,0);
else
    if isfield(im_session,'prev_ref')
        if isfield(im_session.prev_ref,'roi_array')
            for ik = 1:im_session.prev_ref.im_props.numPlanes
                if sum(im_session.prev_ref.roi_array{ik}.guiHandles)>0
                    im_session.prev_ref.roi_array{ik}.closeGui;
                end
            end
        end
    end
    if isfield(im_session.ref,'roi_array')
        for ik = 1:im_session.ref.im_props.numPlanes
            if sum(im_session.ref.roi_array{ik}.guiHandles)>0
                im_session.ref.roi_array{ik}.closeGui;
            end
        end
    end
    plot_im_gui(handles,0);
end

% --- Executes on button press in pushbutton_save_rois.
function pushbutton_save_rois_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

file_name_tag = get(handles.edit_rois_name,'String');
save_rois(file_name_tag)

% --- Executes on button press in pushbutton_import_rois.
function pushbutton_import_rois_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_import_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start_path = fullfile(handles.data_dir,'ROIs_*.mat');
[FileName,PathName,FilterIndex] = uigetfile(start_path);

if FileName ~= 0
    set(handles.pushbutton_save_rois,'enable','on')
    global im_session;
    load(fullfile(PathName,FileName));
    for ik = 1:numel(roi_array)
        roi_array{ik}.idStr = ['Source' num2str(ik)];
    end
    im_session.ref.roi_array_source = roi_array;
    
    im_session.ref.roi_array = cell(im_session.ref.im_props.numPlanes,1);
    for ij = 1:im_session.ref.im_props.numPlanes
        roi_new = roi.roiArray();
        roi_new.masterImage = im_session.ref.base_images{ij};
        roi.roiArray.findMatchingRoisInNewImage(im_session.ref.roi_array_source{ij},roi_new);
        im_session.ref.roi_array{ij} = roi_new;
    end
    plot_im_gui(handles,1);
end

% --- Executes on button press in pushbutton_load_rois.
function pushbutton_load_rois_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start_path = fullfile(handles.data_dir,'ROIs_*.mat');
[FileName,PathName,FilterIndex] = uigetfile(start_path);

if FileName ~= 0
    global im_session;
    load(fullfile(PathName,FileName));
    file_name_tag = FileName(6:end-4);
    set(handles.edit_rois_name,'String',file_name_tag);
    im_session.ref.roi_array = roi_array;
    plot_im_gui(handles,1);
end

function edit_rois_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rois_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rois_name as text
%        str2double(get(hObject,'String')) returns contents of edit_rois_name as a double


% --- Executes during object creation, after setting all properties.
function edit_rois_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rois_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_set_output_dir.
function pushbutton_set_output_dir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_set_output_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start_path = handles.output_dir;
folder_name = uigetdir(start_path);

if folder_name ~= 0
    handles.output_dir = folder_name;
    load_spark_maps(handles.output_dir,1);
end
guidata(hObject, handles);


% --- Executes on selection change in popupmenu_spark_regressors.
function popupmenu_spark_regressors_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_spark_regressors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_spark_regressors contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_spark_regressors

cur_ind = get(hObject,'Value');
global im_session
im_session.spark_output.regressor.cur_ind = cur_ind;
plot_im_gui(handles,0);

global handles_roi_ts;
if ~isempty(handles_roi_ts)
    if ishandle(handles_roi_ts.axes)
        bv_name_list = cellstr(get(hObject,'String'));
        bv_name = bv_name_list{cur_ind};
        plot_bv_ts(bv_name);
        figure(handles.figure1);
    end
end

% --- Executes during object creation, after setting all properties.
function popupmenu_spark_regressors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_spark_regressors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uitoggletool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject,'State')
    case 'off'
        colorbar('off')
    case 'on'
        plot_im_gui(handles,0);
end


% --- Executes on button press in pushbutton_previous_ref.
function pushbutton_previous_ref_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_previous_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start_path = fullfile(handles.base_path,'scanimage','*.*');
[FileName,PathName,FilterIndex] = uigetfile(start_path);

if FileName ~= 0
    pushbutton_load_ref_Callback(hObject, eventdata, handles,FileName,PathName)
end
% --- Executes on selection change in popupmenu_ref_selector.
function popupmenu_ref_selector_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ref_selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ref_selector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ref_selector

prev_ref = get(hObject,'Value')-1;
global im_session
if prev_ref
    if ~isfield(im_session,'prev_ref')
        set(hObject,'value',1)
        return
    end
else
    if ~isfield(im_session,'ref')
        set(hObject,'value',2)
        return
    end
end

plot_im_gui(handles,0);

% --- Executes during object creation, after setting all properties.
function popupmenu_ref_selector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ref_selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_overlay_Callback(hObject, eventdata, handles)
% hObject    handle to slider_overlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

c_lim_2 = round(get(handles.slider_overlay,'Value'));
if c_lim_2 > 4096
    c_lim_2 = 4096;
    set(handles.slider_overlay,'Value',c_lim_2)
end

c_lim_1 = round(get(handles.slider_look_up_table_black,'Value'));
if c_lim_2 < c_lim_1 + 1
    c_lim_2 = c_lim_1 + 1;
    set(handles.slider_overlay,'Value',c_lim_2)
end

set(handles.edit_overlay_level,'String',num2str(c_lim_2));
plot_im_gui(handles,0);


% --- Executes during object creation, after setting all properties.
function slider_overlay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_overlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_overlay_level_Callback(hObject, eventdata, handles)
% hObject    handle to edit_overlay_level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_overlay_level as text
%        str2double(get(hObject,'String')) returns contents of edit_overlay_level as a double

val = str2double(get(hObject,'String'));
set(handles.slider_overlay,'Value',val);
slider_overlay_Callback(handles.slider_overlay,eventdata, handles);



% --- Executes during object creation, after setting all properties.
function edit_overlay_level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_overlay_level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes_images_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_load_ts.
function pushbutton_load_ts_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im_session

roi_names =  get(handles.edit_rois_name,'string');
session_path = fullfile(fileparts(im_session.basic_info.data_dir),'session');

f_names_ca = fullfile(session_path,['session_ca_data_' roi_names '.mat']);
f_names_bv = fullfile(session_path,['session_behaviour_' roi_names '.mat']);

if exist(f_names_ca) == 2 && exist(f_names_bv) == 2
    global session_ca;
    global session_bv;
    load(f_names_ca)
    load(f_names_bv)
    im_session.ref.roi_array = session_ca.im_session.ref.roi_array;
    cur_pos = get(handles.figure1,'Position');
    cur_pos(1) = 5;
    cur_pos(2) = 0;
    set(handles.figure1,'Position',cur_pos)
 
    global handles_roi_ts;
    handles_roi_ts.fig = figure(1);
    clf(1);
    set(handles_roi_ts.fig,'Position',[0 629 1432 177])
    set(handles_roi_ts.fig,'Name','ROI Time Series')
    handles_roi_ts.axes = gca;
    hold on
    handles_roi_ts.plot_bv = plot(session_ca.time,zeros(length(session_ca.time),1),'k');
    handles_roi_ts.plot_roi = plot(session_ca.time,zeros(length(session_ca.time),1),'b');    
    xlabel('Time (s)')
    figure(handles.figure1);
    popupmenu_spark_regressors_Callback(handles.popupmenu_spark_regressors, eventdata, handles)

else
    display('No session behaviour and calcium objects')
end
