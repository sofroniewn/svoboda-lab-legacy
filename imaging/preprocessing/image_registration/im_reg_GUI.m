function varargout = im_reg_GUI(varargin)
% IM_REG_GUI MATLAB code for im_reg_GUI.fig
%      IM_REG_GUI, by itself, creates a new IM_REG_GUI or raises the existing
%      singleton*.
%
%      H = IM_REG_GUI returns the handle to a new IM_REG_GUI or the handle to
%      the existing singleton*.
%
%      IM_REG_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IM_REG_GUI.M with the given input arguments.
%
%      IM_REG_GUI('Property','Value',...) creates a new IM_REG_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before im_reg_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to im_reg_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help im_reg_GUI

% Last Modified by GUIDE v2.5 01-Apr-2014 13:55:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @im_reg_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @im_reg_GUI_OutputFcn, ...
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


% --- Executes just before im_reg_GUI is made visible.
function im_reg_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to im_reg_GUI (see VARARGIN)

% Choose default command line output for im_reg_GUI
set(hObject,'HandleVisibility','on')
handles.output = hObject;

handles.datastr = pwd;

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);
handles.pathstr = pathstr;

plot_list = dir(fullfile(handles.pathstr,'accessory_fns','plot_functions','*.m'));
plot_names = cell(numel(plot_list),1);
for ij = 1:numel(plot_list)
    plot_names{ij} = plot_list(ij).name;
end
set(handles.popupmenu_list_plots,'string',plot_names)
set(handles.popupmenu_list_plots,'value',4)

handles.jTcpObj = [];

% disable gui buttons that should not be used
im_gui_toggle_enable(handles,'off',[1 3 4 5 6])
set(handles.pushbutton_draw_rois,'enable','off')
set(handles.pushbutton_save_rois,'enable','off')
set(handles.pushbutton_import_rois,'enable','off')
set(handles.pushbutton_load_rois,'enable','off')
set(handles.edit_rois_name,'enable','off')
set(handles.text_rois_name,'enable','off')
set(handles.pushbutton_gen_catsa,'enable','off')
set(handles.pushbutton_gen_text,'enable','off')
set(handles.pushbutton_save_session,'enable','off')
set(handles.checkbox_behaviour,'Value',1)
set(handles.togglebutton_TCP,'Enable','off') 

set(handles.text_status,'String','Status: offline')


axes(handles.axes_images)
set(handles.axes_images,'HandleVisibility','on')
imshow(zeros(512,512))


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
set(handles.axes_shifts,'visible','off')

axes(handles.axes_x_hist)
set(handles.axes_x_hist,'HandleVisibility','on')
handles.plot_x_hist = plot(edges_lateral_displacements,zeros(size(edges_lateral_displacements)),'r','LineWidth',2);
ylim([0 1])
set(gca,'ytick',[])
set(gca,'xtick',[-size_lateral_displacements:size_lateral_displacements/2:size_lateral_displacements])
set(gca,'box','off')
ylabel('x','FontSize',14)

axes(handles.axes_y_hist)
set(handles.axes_y_hist,'HandleVisibility','on')
handles.plot_y_hist = plot(zeros(size(edges_lateral_displacements)),edges_lateral_displacements,'r','LineWidth',2);
xlim([0 1])
set(gca,'xtick',[])
set(gca,'ytick',[-size_lateral_displacements:size_lateral_displacements/2:size_lateral_displacements])
set(gca,'box','off')
xlabel('y','FontSize',14)

axes(handles.axes_z_hist)
set(handles.axes_z_hist,'HandleVisibility','on')
handles.plot_z_hist = plot(zeros(size(edges_axial_displacements)),edges_axial_displacements,'r','LineWidth',2);
xlim([0 1])
set(gca,'xtick',[])
set(gca,'ytick',[-size_axial_displacements:size_axial_displacements/2:size_axial_displacements])
set(gca,'box','off')
xlabel('z','FontSize',14)

clear global im_session;
global im_session;
clear global session_ca;
global session_ca;
clear global session;
global session;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes im_reg_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = im_reg_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu_list_plots.
function popupmenu_list_plots_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_list_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_list_plots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_list_plots

plot_im_gui(handles,1);



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



% CLEAR AXES
axes(handles.axes_images)
cla;
imshow(zeros(512,512))

%cla(handles.axes1)

% disable gui buttons that should not be used
im_gui_toggle_enable(handles,'off',[1 3 4 5 6])
set(handles.pushbutton_draw_rois,'enable','off')
set(handles.pushbutton_save_rois,'enable','off')
set(handles.pushbutton_import_rois,'enable','off')
set(handles.pushbutton_load_rois,'enable','off')
set(handles.edit_rois_name,'enable','off')
set(handles.text_rois_name,'enable','off')
set(handles.pushbutton_gen_catsa,'enable','off')
set(handles.pushbutton_gen_text,'enable','off')
set(handles.pushbutton_save_session,'enable','off')

set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(0)]);

set(handles.text_frac_registered,'String',sprintf('Registered %d/%d',0,0))
set(handles.text_status,'String','Status: offline')

set(handles.edit_trial_num,'String',num2str(0))
set(handles.popupmenu_list_plots,'Value',4)


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
    set(handles.text_frac_registered,'Enable','on')
    
    set(handles.text_anm,'String',im_session.basic_info.anm_str)
    set(handles.text_date,'String',im_session.basic_info.date_str)
    set(handles.text_run,'String',im_session.basic_info.run_str)
    set(handles.text_frac_registered,'String',sprintf('Registered 0/%d',numel(im_session.basic_info.cur_files)))
    
    type_name = 'text';
    handles.text_path = fullfile(im_session.basic_info.data_dir,type_name);

    set(handles.pushbutton_load_ref,'enable','on')
    guidata(hObject, handles);

    ref_files = dir(fullfile(handles.data_dir,'ref_images_*.mat'));
    if numel(ref_files) > 0
        handles.ref_images_startup = ref_files(1).name;
        pushbutton_load_ref_Callback(hObject, eventdata, handles)
    else
        handles.ref_images_startup = [];
    end
else
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
set(handles.togglebutton_online_mode,'enable','off')
set(handles.togglebutton_realtime_mode,'enable','off')


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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_load_ref.
function pushbutton_load_ref_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.ref_images_startup)
    start_path = fullfile(handles.base_path,'scanimage','*.*');
    [FileName,PathName,FilterIndex] = uigetfile(start_path);
else
    PathName = handles.data_dir;
    FileName = handles.ref_images_startup;
    handles.ref_images_startup = [];
end

if FileName ~= 0
    im_gui_toggle_enable(handles,'off',[1 3 4 5 6])
    set(handles.pushbutton_data_dir,'enable','off')
    set(handles.pushbutton_load_ref,'enable','off')
    set(handles.pushbutton_cluster_path,'enable','off')
    set(handles.text_status,'String','Status: loading reference')
    set(handles.text_status,'Enable','on')
    set(handles.text_anm,'Enable','on')
    set(handles.text_date,'Enable','on')
    set(handles.text_run,'Enable','on')
    set(handles.text_frac_registered,'Enable','off')
    set(handles.togglebutton_TCP,'Enable','off') 
    drawnow
    overwrite = get(handles.checkbox_overwrite,'Value');

    global im_session
    [pathstr,name,ext] = fileparts(FileName);
    if strcmp(ext,'.mat') == 1
      load(fullfile(PathName,FileName));
    elseif strcmp(ext,'.tif') == 1
        [pathstr,name,ext] = fileparts(FileName);
        if exist(fullfile(PathName,['ref_images_' name '.mat'])) == 2 && overwrite == 0
            load(fullfile(PathName,['ref_images_' name '.mat']));
        else
            align_chan = str2num(get(handles.edit_align_channel,'string'));
            ref = generate_reference(fullfile(PathName,FileName),align_chan,1);
        end
    else
      error('Wrong file type for reference')
    end
    
    if strcmp(name(1:11),'ref_images_')
        name = name(12:end);
    end

    im_session.ref = ref;
    im_session.ref.path_name = PathName;
    im_session.ref.file_name = name;

    roi_file_names = dir(fullfile(PathName,['ROIs_*_' name '.mat']));
    if numel(roi_file_names) > 0 
        if exist(fullfile(PathName,['ROIs_cells_' name '.mat'])) == 2
            load(fullfile(PathName,['ROIs_cells_' name '.mat']));
            set(handles.edit_rois_name,'String','cells');
        else
            load(fullfile(PathName,roi_file_names(1).name))
            file_name_tag = roi_file_names(1).name(6:end);
            roi_tag_end = strfind(file_name_tag,'_');
            file_name_tag = file_name_tag(1:roi_tag_end-1);
            set(handles.edit_rois_name,'String',file_name_tag);
        end
        im_session.ref.roi_array = roi_array;
    end

    set(handles.text_num_planes,'String',sprintf('Num planes %d',im_session.ref.im_props.numPlanes))
    set(handles.text_num_chan,'String',sprintf('Num channels %d',im_session.ref.im_props.nchans))

    im_gui_toggle_enable(handles,'on',[1 3 4 5 6])
    if get(handles.checkbox_behaviour,'value') == 0
       set(handles.text_num_behaviour,'enable','off')
    end
    set(handles.pushbutton_data_dir,'enable','on')
    set(handles.pushbutton_load_ref,'enable','on')
    set(handles.togglebutton_TCP,'Enable','on') 
    set(handles.slider_trial_num,'enable','off')
    set(handles.edit_trial_num,'enable','off')
    set(handles.pushbutton_cluster_path,'enable','on')
    set(handles.pushbutton_draw_rois,'enable','on')
    set(handles.pushbutton_import_rois,'enable','on')
    set(handles.pushbutton_load_rois,'enable','on')
    set(handles.edit_rois_name,'enable','on')
    set(handles.text_rois_name,'enable','on')
    set(handles.pushbutton_gen_catsa,'enable','on')
    set(handles.pushbutton_gen_text,'enable','on')
    set(handles.pushbutton_save_session,'enable','on')
    
    %set(handles.togglebutton_online_mode,'enable','off')
    %set(handles.togglebutton_realtime_mode,'enable','off')
    set(handles.text_time,'enable','off')
    plot_im_gui(handles,1);
    set(handles.text_status,'String','Status: offline')
    drawnow
else
end

% --- Executes on button press in pushbutton_register_im.
function pushbutton_register_im_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_register_im (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

use_cluser = get(handles.checkbox_use_cluster,'Value');

if use_cluser
    evalScript = prepare_register_cluster;
else

save_opts.overwrite = get(handles.checkbox_overwrite,'Value');
save_opts.aligned = get(handles.checkbox_save_aligned,'Value');
save_opts.text = get(handles.checkbox_save_text,'Value');

align_chan = eval(get(handles.edit_align_channel,'string'));
start_trial = 1;

im_gui_toggle_enable(handles,'off',[1 2])
set(handles.pushbutton_data_dir,'enable','off')
%set(handles.text_anm,'enable','on')
%set(handles.text_date,'enable','on')
%set(handles.text_run,'enable','on')
%set(handles.text_status,'enable','on')
%set(handles.text_frac_registered,'enable','on')
drawnow

global im_session;
num_files_im = numel(im_session.basic_info.cur_files);
num_files = numel(im_session.basic_info.cur_files);
% Check if behaviour mode on
val = get(handles.checkbox_behaviour,'Value');
if val == 1
    set(handles.text_status,'String','Status: loading behaviour')
    drawnow
    base_path_behaviour = fullfile(handles.base_path, 'behaviour');
    global session;
    session = [];
    session = load_session_data(base_path_behaviour);
    session = parse_session_data(1,session);

    num_files = min(num_files_im,numel(session.data));
    % match scim behaviour trial numbers (assume one to one)
    im_session.ref.behaviour_scim_trial_align = [1:numel(session.data)];
    
    % initialize global variables for scim alignment
    global remove_first;
    remove_first = 0;
    set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(session.data))]);
    set(handles.text_status,'String','Status: waiting')
    drawnow
end
  
set(handles.slider_trial_num,'enable','on')
set(handles.edit_trial_num,'enable','on')

% Setup registration
setup_im_reg(handles);
% Register directory
register_directory(start_trial,num_files,num_files_im,align_chan,save_opts,handles)

im_gui_toggle_enable(handles,'on',[1 2])

set(handles.text_time,'enable','off')
set(handles.pushbutton_data_dir,'enable','on')
set(handles.text_status,'String','Status: offline')
end

% --- Executes on button press in togglebutton_online_mode.
function togglebutton_online_mode_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_online_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(hObject,'Value');

if value == 1
  tic;
  im_gui_toggle_enable(handles,'off',[1 2])
  set(handles.slider_trial_num,'enable','on')
  set(handles.edit_trial_num,'enable','on')
  set(handles.pushbutton_data_dir,'enable','off')
  set(handles.togglebutton_online_mode,'enable','on')
  set(handles.text_anm,'Enable','on')
  set(handles.text_date,'Enable','on')
  set(handles.text_run,'Enable','on')
  set(handles.text_status,'enable','on')
  set(handles.text_frac_registered,'enable','on')
  set(handles.text_time,'Enable','on')
  set(handles.text_status,'String','Status: waiting')

  % Setup timer
  handles.obj_t = timer('TimerFcn',{@update_im_reg,handles});
  set(handles.obj_t,'ExecutionMode','fixedSpacing');
  set(handles.obj_t,'Period', .5);
  set(handles.obj_t,'BusyMode','drop');
  set(handles.obj_t,'ErrorFcn',@(obj,event)disp('Timing Error'));
  set(handles.obj_t,'UserData',0);
    
  global im_session;
  im_session.basic_info.cur_files = [];
  set(handles.text_frac_registered,'String',sprintf('Registered 0/%d',numel(im_session.basic_info.cur_files)))

  % set(handles.text_elapsed_time,'Enable','on')
   
start_flag = 1;

% Check if behaviour mode on
  val = get(handles.checkbox_behaviour,'Value');
  if val == 1
    % match scim behaviour trial numbers (assume one to one)
    %global behaviour_scim_trial_align;
    %behaviour_scim_trial_align = [1:numel(session.data)];
    % initialize global variables for scim alignment
    global prev_num_trigs_behaviour;
    prev_num_trigs_behaviour = 0;
    global extra_frame_behaviour;
    extra_frame_behaviour = 0;
    if get(handles.togglebutton_TCP,'value') == 0
       set(handles.togglebutton_TCP,'value',1);
       togglebutton_TCP_Callback(handles.togglebutton_TCP, eventdata, handles);
       start_flag = get(handles.togglebutton_TCP,'value');
    end
    %global session;
    %num_files = numel(im_session.basic_info.cur_files);
    %num_behaviour = numel(session.data);
    %if num_files > num_behaviour
    %start_flag = 0;
    %end
  end
    % Update handles structure
    guidata(hObject, handles);
    
  if start_flag == 1
    % Setup registration
    setup_im_reg(handles);
    %start_trial = 1;
    %align_chan = eval(get(handles.edit_align_channel,'string'));
    %save_opts.overwrite = get(handles.checkbox_overwrite,'Value');
    %save_opts.aligned = get(handles.checkbox_save_aligned,'Value');
    %save_opts.text = get(handles.checkbox_save_text,'Value');
    %global im_session;
    %num_files = numel(im_session.basic_info.cur_files);
    %register_directory(start_trial,num_files,num_files,align_chan,save_opts,handles)
    % Start Timer
    start(handles.obj_t)
  else
    set(handles.togglebutton_online_mode,'value',0);
    togglebutton_online_mode_Callback(handles.togglebutton_online_mode, eventdata, handles)
  end

else
    stop(handles.obj_t);
    delete(handles.obj_t);
    
  im_gui_toggle_enable(handles,'on',[1 2])
  set(handles.pushbutton_load_ref,'enable','on')
  set(handles.pushbutton_data_dir,'enable','on')

   time_elapsed_str = sprintf('Time online %.1f s',0);
   set(handles.text_time,'String',time_elapsed_str)
   set(handles.text_time,'Enable','off')
   set(handles.text_status,'String','Status: offline')

   
    
end


% --- Executes on button press in togglebutton_realtime_mode.
function togglebutton_realtime_mode_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_realtime_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(hObject,'Value');

if value == 1
  tic;
  im_gui_toggle_enable(handles,'off',[1 2])
  set(handles.slider_trial_num,'enable','on')
  set(handles.edit_trial_num,'enable','on')
  set(handles.pushbutton_data_dir,'enable','off')
  set(handles.togglebutton_realtime_mode,'enable','on')
  set(handles.text_anm,'Enable','on')
  set(handles.text_date,'Enable','on')
  set(handles.text_run,'Enable','on')
  set(handles.text_status,'enable','on')
  set(handles.text_frac_registered,'enable','on')
  set(handles.text_time,'Enable','on')
  set(handles.text_status,'String','Status: realtime')

  % Setup timer
  handles.obj_t_realtime = timer('TimerFcn',{@update_im_realtime,handles});
  set(handles.obj_t_realtime,'ExecutionMode','fixedSpacing');
  set(handles.obj_t_realtime,'Period', .05);
  set(handles.obj_t_realtime,'BusyMode','drop');
  set(handles.obj_t_realtime,'ErrorFcn',@(obj,event)disp('Realtime timing Error'));
  set(handles.obj_t_realtime,'UserData',0);
    
  % set(handles.text_elapsed_time,'Enable','on')

  global im_session;
  % setup memory map
  filename = fullfile(handles.data_dir,'memmap.dat');
  % Create the communications file if it is not already there.
  [f, msg] = fopen(filename, 'wb');
  if f ~= -1
      fwrite(f, zeros(im_session.ref.im_props.height*im_session.ref.im_props.width*im_session.ref.im_props.numPlanes+1,1,'int16'), 'int16');
      fclose(f);
  else
      error('MATLAB:demo:send:cannotOpenFile', ...
            'Cannot open file "%s": %s.', filename, msg);
  end
  
  global mmap_data;
  mmap_data = memmapfile(filename, 'Writable', true, ...
        'Format', 'int16');
  global old_mmap_frame_num
  old_mmap_frame_num = 0;

  im_session.realtime.im_raw = zeros(im_session.ref.im_props.height,im_session.ref.im_props.width,im_session.ref.im_props.numPlanes,10);
  im_session.realtime.ind = 1;
  im_session.realtime.start = 0;
  
  update_im = get(handles.checkbox_plot_images,'value');
  contents = cellstr(get(handles.popupmenu_list_plots,'String'));
  plot_str = contents{get(handles.popupmenu_list_plots,'Value')};

  if update_im == 1 && strcmp(plot_str,'plot_realtime_raw.m') == 1
    im_data = plot_im_gui(handles,0);
    im_plot = get(handles.axes_images,'Children');
    set(im_plot,'CData',im_data)
  end

    % Update handles structure
    guidata(hObject, handles);
    
    % Start Timer
    start(handles.obj_t_realtime)

else
    stop(handles.obj_t_realtime);
    delete(handles.obj_t_realtime);
    
    im_gui_toggle_enable(handles,'on',[1 2])
    set(handles.pushbutton_load_ref,'enable','on')
    set(handles.pushbutton_data_dir,'enable','on')

   time_elapsed_str = sprintf('Time online %.1f s',0);
   set(handles.text_time,'String',time_elapsed_str)
   set(handles.text_time,'Enable','off')
   set(handles.text_status,'String','Status: offline')

   
    
end


% --- Executes on button press in checkbox_save_text.
function checkbox_save_text_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_save_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_save_text

%set(handles.togglebutton_online_mode,'enable','off')
%set(handles.togglebutton_realtime_mode,'enable','off')


% --- Executes on button press in checkbox_save_aligned.
function checkbox_save_aligned_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_save_aligned (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_save_aligned

%set(handles.togglebutton_online_mode,'enable','off')
%set(handles.togglebutton_realtime_mode,'enable','off')


% --- Executes on button press in checkbox_overwrite.
function checkbox_overwrite_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_overwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_overwrite

%set(handles.togglebutton_online_mode,'enable','off')
%set(handles.togglebutton_realtime_mode,'enable','off')


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
plot_im_gui(handles,1);

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
plot_im_gui(handles,1);


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

plot_im_gui(handles,1);


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
set(handles.slider_trial_num,'Value',val);
set(handles.edit_trial_num,'String',num2str(val));
plot_im_gui(handles,1);

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


% --- Executes on button press in pushbutton_cluster_path.
function pushbutton_cluster_path_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cluster_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.togglebutton_online_mode,'enable','off')
set(handles.togglebutton_realtime_mode,'enable','off')


start_path = handles.datastr;
folder_name = uigetdir(start_path);

if folder_name ~= 0
  handles.text_path = folder_name;
else
  type_name = 'text';
  handles.text_path = fullfile(im_session.basic_info.data_dir,type_name);
end
guidata(hObject, handles);



function edit_analyze_chan_Callback(hObject, eventdata, handles)
% hObject    handle to edit_analyze_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_analyze_chan as text
%        str2double(get(hObject,'String')) returns contents of edit_analyze_chan as a double

%set(handles.togglebutton_online_mode,'enable','off')
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


% --- Executes on button press in togglebutton_TCP.
function togglebutton_TCP_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_TCP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_TCP
switch get(hObject,'value')
    case 0 %Delete TCP/IP
        set(handles.togglebutton_TCP,'String','Setup TCP')
        set(handles.text_TCP_status,'String','off')
        set(handles.text_TCP_status,'BackgroundColor',[1 0 0])
        jtcp('close',handles.jTcpObj);
        stop(handles.obj_tcp_t);
        delete(handles.obj_tcp_t);
    case 1
        set(handles.togglebutton_TCP,'String','Stop TCP')
        set(handles.text_TCP_status,'String','waiting')
        set(handles.text_TCP_status,'BackgroundColor',[0 0 1])
        set(handles.togglebutton_TCP,'Enable','off') 
        base_path_behaviour = fullfile(handles.base_path, 'behaviour');
          if exist(base_path_behaviour) ~= 7
            mkdir(base_path_behaviour);
          end

        global session;
        session = [];
        session.data = [];
        set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(session.data))]);
        drawnow
        
        try
            handles.jTcpObj = jtcp('accept',21566,'timeout',5000);

            % Create tcp buffer
            set(handles.text_TCP_status,'String','waiting')
            set(handles.text_TCP_status,'BackgroundColor',[0 1 0])
            set(handles.checkbox_behaviour,'Value',1);
            checkbox_behaviour_Callback(handles.checkbox_behaviour, eventdata, handles);       

            % Setup timer
            handles.obj_tcp_t = timer('TimerFcn',{@update_tcp_buffer,handles});
            set(handles.obj_tcp_t,'ExecutionMode','fixedSpacing');
            set(handles.obj_tcp_t,'Period', .1);
            set(handles.obj_tcp_t,'BusyMode','drop');
            set(handles.obj_tcp_t,'ErrorFcn',@(obj,event)disp('TCP Timing Error'));
    
           % Update handles structure
           guidata(hObject, handles);
  
          % Start Timer
          start(handles.obj_tcp_t)

        catch
            set(handles.text_TCP_status,'String','FAILED')
            set(handles.text_TCP_status,'BackgroundColor',[1 0 0])
            set(handles.togglebutton_TCP,'Value',0) 
            set(handles.togglebutton_TCP,'String','Setup TCP')
        end
        set(handles.togglebutton_TCP,'Enable','on') 
end


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

%val_pop = get(handles.popupmenu_behaviour_mode,'Value');
%if val_pop == 3
%  val_tcp = get(handles.togglebutton_TCP,'Value');
%  if val_tcp == 0
%    set(handles.togglebutton_TCP,'Value',1)
%    togglebutton_TCP_Callback(handles.togglebutton_TCP, eventdata, handles)
%  end
%end


% --- Executes on button press in pushbutton_draw_rois.
function pushbutton_draw_rois_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_draw_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pushbutton_save_rois,'enable','on')
overwrite = get(handles.checkbox_overwrite,'Value');
c_lim = zeros(1,2);
c_lim(1) = round(get(handles.slider_look_up_table_black,'Value'));
c_lim(2) = round(get(handles.slider_look_up_table,'Value'));
plot_planes_str = get(handles.edit_display_planes,'string');
plot_planes = eval(plot_planes_str);
draw_rois(plot_planes(1),overwrite,c_lim);


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
    file_name_tag = FileName(6:end);
    roi_tag_end = strfind(file_name_tag,'_');
    file_name_tag = file_name_tag(1:roi_tag_end-1);
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
val = get(handles.checkbox_behaviour,'Value');
if val == 1
    global session;
    num_files = min(num_files,numel(session.data));
end

num_files = min(num_files,length(im_session.reg.nFrames));

signalChannels = str2num(get(handles.edit_analyze_chan,'string'));
overwrite = get(handles.checkbox_overwrite,'Value');
file_name_tag = get(handles.edit_rois_name,'String');
global session_ca;
session_ca = [];
if num_files > 0
    cur_status = get(handles.text_status,'String');
    set(handles.text_status,'String','Status: extracting CaTSA')
    drawnow
    save_path = fileparts(im_session.basic_info.data_dir);
    file_name_tag = get(handles.edit_rois_name,'String');
    session_path = fullfile(save_path,'session');

    if exist(session_path) ~= 7
        mkdir(session_path);
    end

    caTSA_file_name = fullfile(session_path,['session_ca_data_' file_name_tag '.mat']);
    session_ca = get_session_ca(caTSA_file_name,num_files,neuropilDilationRange,signalChannels,neuropilSubSF,file_name_tag,overwrite);
    set(handles.text_status,'String',cur_status)

    pushbutton_save_session_Callback(handles.pushbutton_save_session, eventdata, handles);
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
file_name_tag = get(handles.edit_rois_name,'String');
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

% --- Executes on button press in pushbutton_save_session.
function pushbutton_save_session_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global im_session;
global session_ca;
global session;
num_files = min(numel(im_session.basic_info.cur_files),numel(session.data));
behaviour_on = get(handles.checkbox_behaviour,'Value');

save_path = fileparts(im_session.basic_info.data_dir);
file_name_tag = get(handles.edit_rois_name,'String');
session_path = fullfile(save_path,'session');

if exist(session_path) ~= 7
    mkdir(session_path);
end

overwrite = get(handles.checkbox_overwrite,'Value');
cur_status = get(handles.text_status,'String');
set(handles.text_status,'String','Status: saving session')
drawnow
save_common_data_format(session_path,file_name_tag,overwrite,num_files,behaviour_on,session,im_session,session_ca);
set(handles.text_status,'String',cur_status)

 


% --- Executes on button press in checkbox_use_cluster.
function checkbox_use_cluster_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_use_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_use_cluster
