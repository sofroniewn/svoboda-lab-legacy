function varargout = WGNR_expt_gui(varargin)
% WGNR_EXPT_GUI MATLAB code for WGNR_expt_gui.fig
%      WGNR_EXPT_GUI, by itself, creates a new WGNR_EXPT_GUI or raises the existing
%      singleton*.
%
%      H = WGNR_EXPT_GUI returns the handle to a new WGNR_EXPT_GUI or the handle to
%      the existing singleton*.
%
%      WGNR_EXPT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WGNR_EXPT_GUI.M with the given input arguments.
%
%      WGNR_EXPT_GUI('Property','Value',...) creates a new WGNR_EXPT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WGNR_expt_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WGNR_expt_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WGNR_expt_gui

% Last Modified by GUIDE v2.5 28-Feb-2014 12:49:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @WGNR_expt_gui_OpeningFcn, ...
    'gui_OutputFcn',  @WGNR_expt_gui_OutputFcn, ...
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


% --- Executes just before WGNR_expt_gui is made visible.
function WGNR_expt_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WGNR_expt_gui (see VARARGIN)

% Choose default command line output for WGNR_expt_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);
handles.pathstr = pathstr;

% Load rig configuration file
[FileName,PathName,FilterIndex] = uigetfile(fullfile(pathstr,'Rig_configs','*.m'));
set(handles.rig_calib_file,'String',FileName);
run([PathName,FileName]);
set(hObject,'UserData',rig_config);

cd(rig_config.base_dir)
% addpath(fullfile('.','accessory_fns'));
% addpath(fullfile('.','accessory_fns','plot_functions'));
% addpath(fullfile('.','accessory_fns','plot_functions','time_series_plots'));
% addpath(fullfile('.','accessory_fns','plot_functions','histogram_plots'));

handles.A_inv = rig_config.A_inv;
handles.trial_mat_names = {'x_vel','y_vel','cor_pos','cor_width','laser_power','x_mirror_pos','y_mirror_pos', ...
    'trial_num','inter_trial_trig','lick_state','water_earned','running_ind', ...
    'masking_flash_on','scim_state','external_water','scim_logging','test_val'};
handles.iti_ind = find(strcmp(handles.trial_mat_names,'inter_trial_trig'));

% Load trial configuration file
load_trial_config_Callback(handles.load_trial_config, eventdata, handles);
trial_config = get(handles.trial_config_str,'UserData');


% Configure Ball Tracker
if strcmp(rig_config.rig_name,'Laptop') ~= 1 && strcmp(rig_config.rig_name,'Desktop') ~= 1
    vi = configure_ball_tracker(rig_config.treadmill_str);
    camera_metrics= start_ball_tracker(vi);
    % Display camera metrics
    str = sprintf('SQUAL 0 = %.2f', camera_metrics(2));
    set(handles.text_squal0,'String',str);
    str = sprintf('Shut 0 = %.0f us', 1000*camera_metrics(1));
    set(handles.text_f0,'String',str);
    str = sprintf('SQUAL 1 = %.2f', camera_metrics(4));
    set(handles.text_squal1,'String',str);
    str = sprintf('Shut 1 = %.0f us', 1000*camera_metrics(3));
    set(handles.text_f1,'String',str);
end

% Setup logged values
cur_date = datevec(date);
str_date = sprintf('%u%02u%02u',mod(cur_date(1),2000),cur_date(2),cur_date(3));
set(handles.edit_date,'String',str_date);

set(handles.text_num_water,'String',num2str(0));
set(handles.text_num_licks,'String',num2str(0));
set(handles.speed_thresh_str,'UserData',200);
set(handles.speed_thresh_str,'String','Off');
set(handles.text_run_time,'String',sprintf('%.2f s',0));

set(handles.text_num_trials,'String',num2str(0));
set(handles.text_cur_trial_num,'String',num2str(0));
set(handles.text_cur_cor_pos,'String',num2str(0));
set(handles.text_cur_cor_width,'String',num2str(0));
set(handles.text_cur_mf,'String',num2str(0));
set(handles.text_cur_ps_power,'String',num2str(0));
set(handles.text_cur_y_mirr_pos,'String',num2str(0));
set(handles.text_cur_x_mirr_pos,'String',num2str(0));


% Setup Speed Figure
axes(handles.axes_speed)
str = sprintf('Ball Speed');
title(str,'FontSize',14)
set(gca,'FontSize',12)
xlabel('Time (s)','FontSize',12)
ylabel('Speed (cm/s) and Cor Pos (mm)','FontSize',12)
hold on

zero_init = zeros(2501,1);
x_axis = -5+[0:.002:5];

handles.cor_width_plot = plot(x_axis,zero_init,'Color',[.4 .4 .4],'LineWidth',3);
handles.laser_power_plot = plot(x_axis,zero_init,'Color',[1 .5 0],'LineWidth',3);
handles.speed_plot =  plot(x_axis,zero_init,'r','LineWidth',3);
handles.speed_dot =   plot(x_axis(end),0,'Marker','.','MarkerSize',18,'LineStyle','none','MarkerEdgeColor','b');
handles.trial_period_plot = plot(x_axis,zero_init,'Marker','.','MarkerSize',10,'LineStyle','none','MarkerEdgeColor','m');
handles.water_plot = plot(x_axis,zero_init,'Marker','.','MarkerSize',10,'LineStyle','none','MarkerEdgeColor','c');
handles.water_ext_plot = plot(x_axis,zero_init,'Marker','.','MarkerSize',10,'LineStyle','none','MarkerEdgeColor',[.3 .3 .6]);
handles.lick_plot = plot(x_axis,zero_init,'Marker','.','MarkerSize',10,'LineStyle','none','MarkerEdgeColor','b');
handles.cor_pos_plot = plot(x_axis,zero_init,'g','LineWidth',3);

xlim([-5 0])
ylim([0 80])


% Setup Pos Figure
axes(handles.axes_position)
str = sprintf('x and y position');
title(str,'FontSize',14)
set(gca,'FontSize',12)
xlabel('x pos (m)','FontSize',12)
ylabel('y pos (m)','FontSize',12)
hold on
x_pos = zeros(2501,1);
y_pos = zeros(2501,1);
handles.pos_plot =  plot(x_pos, y_pos,'Marker','.','MarkerSize',25,'LineStyle','none','MarkerEdgeColor','b');
grid('on')
xlim([-200 200]/100)
ylim([-50 50]/100)


% Setup Wall Pos Figure
corridor_width = 1;
axes(handles.axes_wall_hist)
str = sprintf('Wall position histogram');
title(str,'FontSize',14)
set(gca,'FontSize',12)
xlabel('Corridor position (frac)','FontSize',12)
edges = [0:.01:corridor_width]';
totavg = zeros(size(edges));
count = zeros(size(edges));
handles.wall_pos_hist = plot(edges,totavg,'Color','b','LineWidth',4);
set(handles.wall_pos_hist,'UserData',count);
xlim([0 corridor_width])
set(gca,'xtick',[0:.1:corridor_width])
xlim([0 corridor_width])
ylim([0 .25])

% Disable water buttons
set(handles.pushbutton_water,'Enable','off')
set(handles.speed_thresh_up,'Enable','off')
set(handles.speed_thresh_down,'Enable','off')

handles.TCP_IP_address = rig_config.TCP_IP_address;
handles.jTcpObj = [];
% Check whether to disable TCP
if isempty(handles.TCP_IP_address) == 1
    set(handles.togglebutton_TCP,'Enable','off')
end
        
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in togglebutton_start_RTLSM.
function togglebutton_start_RTLSM_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_start_RTLSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject,'value')
    case 0 %Stop Acquisition
        set(handles.togglebutton_start_RTLSM,'Enable','off')
        set(handles.togglebutton_start_RTLSM,'backgroundcolor','b','string','Resetting RTFSM');
        pause(.1);
        ForceState(handles.sm,4);
        pause(1);
        Halt(handles.sm);
        pause(2);
        stop(handles.obj_t)
        delete(handles.obj_t);
        disp(sprintf('Run Stopped by User\n'));
        %Close log file if open
        checkbox_log_value = get(handles.checkbox_log,'Value');
        if checkbox_log_value == 1
            fclose(handles.fid);
        else
        end
        % Enable log buttons
        pause(.5);
        set(handles.togglebutton_start_RTLSM,'backgroundcolor','r','string','Start RTFSM');
        set(handles.text_run_time,'backgroundcolor','r');
        set(handles.togglebutton_start_RTLSM,'Enable','on')

        if get(handles.togglebutton_TCP,'Value') == 1
            jtcp('write',handles.jTcpObj,{'Stop run'});
        end

        % Enable TCP/IP
        if isempty(handles.TCP_IP_address) ~= 1
            set(handles.togglebutton_TCP,'Enable','on')
        end

        % Enable log buttons
        set(handles.checkbox_log,'Enable','on')
        set(handles.edit_run_number,'Enable','on')
        set(handles.edit_animal_number,'Enable','on')
        set(handles.edit_date,'Enable','on')
        set(handles.load_trial_config,'Enable','on')

        % Disable water buttons
        set(handles.pushbutton_water,'Enable','off')
        set(handles.speed_thresh_up,'Enable','off')
        set(handles.speed_thresh_down,'Enable','off')

    case 1 %Start RTLSM
        trial_config = get(handles.trial_config_str,'UserData');
        rig_config = get(handles.figure1,'UserData');
        checkbox_log_value = get(handles.checkbox_log,'Value');
        
        % Load ps_sites file
        str_animal_number = get(handles.edit_animal_number,'String');
        ps_file_name = fullfile(rig_config.data_dir,['anm_0' str_animal_number],'ISI','photostim_sites.m');
        if exist(ps_file_name) == 2
            run(ps_file_name);
        else
            ps_file_name_default = fullfile(handles.pathstr,'Rig_configs','DEFAULT_PS','photostim_sites.m');
            run(ps_file_name_default);
            if checkbox_log_value == 1
                mkdir(fullfile(rig_config.data_dir,['anm_0' str_animal_number],'ISI'));
                copyfile(ps_file_name_default,ps_file_name);
            end
        end
        
        
        
        % Reset GUI for logging
        trial_info.trial_num = 1;
        trial_info.iti_end = 1;
        trial_info.trial_mat = [];
        set(handles.text_num_trials,'UserData',trial_info);
        
        % Reset strings
        
        set(handles.text_num_water,'String',num2str(0));
        set(handles.text_num_licks,'String',num2str(0));
        set(handles.speed_thresh_str,'UserData',200);
        set(handles.speed_thresh_str,'String','Off');
        set(handles.text_run_time,'String',sprintf('%.2f s',0));
        
        set(handles.text_num_trials,'String',num2str(0));
        set(handles.text_cur_trial_num,'String',num2str(0));
        set(handles.text_cur_cor_pos,'String',num2str(0));
        set(handles.text_cur_cor_width,'String',num2str(0));
        set(handles.text_cur_mf,'String',num2str(0));
        set(handles.text_cur_ps_power,'String',num2str(0));
        set(handles.text_cur_y_mirr_pos,'String',num2str(0));
        set(handles.text_cur_x_mirr_pos,'String',num2str(0));
        set(handles.text_run_time,'UserData',0);
        
        % Reset figures
        zero_init = zeros(2501,1);
        x_axis = -5+[0:.002:5];
        set(handles.speed_plot,'Ydata',zero_init);
        set(handles.speed_dot,'Ydata',0);
        set(handles.cor_pos_plot,'Ydata',zero_init);
        set(handles.trial_period_plot,'Ydata',zero_init);
        set(handles.water_plot,'Ydata',zero_init);
        set(handles.water_ext_plot,'Ydata',zero_init);
        set(handles.lick_plot,'Ydata',zero_init);
        set(handles.laser_power_plot,'Ydata',zero_init);
        set(handles.cor_width_plot,'Ydata',zero_init);
        
        x_pos = zeros(2501,1);
        y_pos = zeros(2501,1);
        set(handles.pos_plot,'Xdata',x_pos);
        set(handles.pos_plot,'Ydata',y_pos);
        
        corridor_width = 1;
        edges = [0:.01:corridor_width]';
        totavg = zeros(size(edges));
        count = zeros(size(edges));
        set(handles.wall_pos_hist,'Ydata',totavg);
        set(handles.wall_pos_hist,'UserData',count);
        
        % Enable water buttons
        set(handles.pushbutton_water,'Enable','on')
        set(handles.speed_thresh_up,'Enable','on')
        set(handles.speed_thresh_down,'Enable','on')

        % Disable logging options
        set(handles.checkbox_log,'Enable','off')
        set(handles.edit_run_number,'Enable','off')
        set(handles.edit_animal_number,'Enable','off')
        set(handles.edit_date,'Enable','off')
        set(handles.load_trial_config,'Enable','off')

        % Create folder names
        str_date = get(handles.edit_date,'String');
        str_animal_number = get(handles.edit_animal_number,'String');
        str_run_number = get(handles.edit_run_number,'String');
        folder_name = fullfile(rig_config.data_dir,['anm_0' str_animal_number],['20' str_date(1:2) '_' str_date(3:4) '_' str_date(5:6)],['run_' str_run_number],'behaviour');
        file_id_name = ['anm_0',str_animal_number,'_20' str_date(1:2) 'x' str_date(3:4) 'x' str_date(5:6) '_run_',str_run_number,'_'];
        fname_base = fullfile(folder_name,file_id_name);
        fname_log = [fname_base 'log.txt'];
        fname_globals = [fname_base rig_config.globals_name];
        handles.fname_base = fname_base;
           
        % Disable TCP/IP
        set(handles.togglebutton_TCP,'Enable','off')

        % Start TCP/IP communication
        if get(handles.togglebutton_TCP,'Value') == 1
            jtcp('write',handles.jTcpObj,{'Prepare run'});
            jtcp('write',handles.jTcpObj,{'file_id_name',file_id_name});
            mssg = tcp_struct_parser(rig_config,'rig_config',1);
            jtcp('write',handles.jTcpObj,mssg);
            mssg = tcp_struct_parser(trial_config,'trial_config',1);
            jtcp('write',handles.jTcpObj,mssg);
            jtcp('write',handles.jTcpObj,{'trial_mat_names',handles.trial_mat_names});
            mssg = tcp_struct_parser(ps_sites,'ps_sites',1);
            jtcp('write',handles.jTcpObj,mssg);
            jtcp('write',handles.jTcpObj,{'Start run'});
        end


        % Get globals file name
        fileIn = fullfile('.','globals',rig_config.globals_name);
        fileOut = fullfile('.','globals',[rig_config.globals_name(1:end-2) '_used.c']);
        text_replacer(trial_config,rig_config,ps_sites,fileIn,fileOut);
        G = wrap_c_file_in_string(fileOut);
        
        % Setup RTLSM
        sm = RTLSM(rig_config.comp_ip_address,3333,2);
        sm = SetInputEvents(sm, [0], 'ai');
        sm = SetOutputRouting(sm, {struct('type', 'dout','data', '0-15')});
        
        % Setup State Matrix
        M = [0 0 9999   0; ...
            1  0 .003  0; ...
            2  0 .003  0; ...
            3  0 .003  0; ...
            4  0 .003  0; ...
            ];
        
        entry_funcs = cell(5,2);
        entry_funcs{1,1} = 0;
        entry_funcs{1,2} = 'default_state';
        entry_funcs{2,1} = 1;
        entry_funcs{2,2} = 'give_water';
        entry_funcs{3,1} = 2;
        entry_funcs{3,2} = 'raise_dist_thresh';
        entry_funcs{4,1} = 3;
        entry_funcs{4,2} = 'lower_dist_thresh';
        entry_funcs{5,1} = 4;
        entry_funcs{5,2} = 'stop_state';
        
        % Prepare RTLSM
        Halt(sm);
        sm = SetStateProgram(sm,'matrix',M,'globals',G,'tickfunc','tick_func','initfunc','init_func','cleanupfunc','cleanupfunc','entryfuncs',entry_funcs);
        ForceState(sm,0);
        handles.sm = sm;
        
        % Setup EmbdC Log
        handles.init_numVarLog = GetVarLogCounter(sm);
        numVarLog = 0;
        
        % Creat File for logging if checkbox_log = 1
        if checkbox_log_value == 1
            if exist(folder_name) ~= 7
                mkdir(folder_name);
            else
                error('Folder already exists - do not overwrite')
            end
            copyfile(fileOut,fname_globals);
            % delete(fileOut);
            save([fname_base 'rig_config.mat'],'rig_config');
            save([fname_base 'trial_config.mat'],'trial_config');
            save([fname_base 'ps_sites.mat'],'ps_sites');
            fid = fopen(fname_log,'w'); % Open text file on Windows Machine for saving values
            if fid == -1
                error('File Not Created')
            else
            end
            handles.fid = fid;
        else
        end
        
        % Setup timer
        handles.obj_t = timer('TimerFcn',{@update_function,handles});
        set(handles.obj_t,'ExecutionMode','fixedRate');
        set(handles.obj_t,'Period', .25);
        set(handles.obj_t,'BusyMode','queue');
        set(handles.obj_t,'ErrorFcn',@(obj,event)disp('Timing Error'));
        set(handles.obj_t,'UserData',numVarLog);
        
        % Update handles structure
        guidata(hObject, handles);
        
        % Start RTLSM
        set(hObject,'backgroundcolor','g','string','RTLSM Running');
        set(handles.text_run_time,'backgroundcolor','g');
        Run(sm);
        disp(sprintf('\nStarting RTLSM'))
        
        % Start Timer
        start(handles.obj_t)
        
end


% --- Executes on button press in pushbutton_water.
function pushbutton_water_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_water (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ForceState(handles.sm,1);


% --- Executes on button press in speed_thresh_up.
function speed_thresh_up_Callback(hObject, eventdata, handles)
% hObject    handle to speed_thresh_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ForceState(handles.sm,2);
num = get(handles.speed_thresh_str,'UserData');
num = num + 20;
set(handles.speed_thresh_str,'UserData',num);
if num < 200
    set(handles.speed_thresh_str,'String',num2str(num));
else
    set(handles.speed_thresh_str,'String','Off');
end

% --- Executes on button press in speed_thresh_down.
function speed_thresh_down_Callback(hObject, eventdata, handles)
% hObject    handle to speed_thresh_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ForceState(handles.sm,3);
num = get(handles.speed_thresh_str,'UserData');
num = num - 20;
set(handles.speed_thresh_str,'UserData',num);
if num < 200
    set(handles.speed_thresh_str,'String',num2str(num));
else
    set(handles.speed_thresh_str,'String','Off');
end

% --- Executes on button press in load_trial_config.
function load_trial_config_Callback(hObject, eventdata, handles)
% hObject    handle to load_trial_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,FilterIndex] = uigetfile(fullfile(handles.pathstr,'Trial_configs','*.mat'));
set(handles.trial_config_str,'String',FileName);
load([PathName,FileName]);
set(handles.trial_config_str,'UserData',trial_config);
%full_name = [PathName,FileName];
%WGNR_trial_viewer_gui({full_name});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Outputs from this function are returned to the command line.
function varargout = WGNR_expt_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox_log.
function checkbox_log_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_log



function edit_run_number_Callback(hObject, eventdata, handles)
% hObject    handle to edit_run_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_run_number as text
%        str2double(get(hObject,'String')) returns contents of edit_run_number as a double


% --- Executes during object creation, after setting all properties.
function edit_run_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_run_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_calibration_matrix_Callback(hObject, eventdata, handles)
% hObject    handle to edit_calibration_matrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_calibration_matrix as text
%        str2double(get(hObject,'String')) returns contents of edit_calibration_matrix as a double


% --- Executes during object creation, after setting all properties.
function edit_calibration_matrix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_calibration_matrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_animal_number_Callback(hObject, eventdata, handles)
% hObject    handle to edit_animal_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_animal_number as text
%        str2double(get(hObject,'String')) returns contents of edit_animal_number as a double


% --- Executes during object creation, after setting all properties.
function edit_animal_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_animal_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_date_Callback(hObject, eventdata, handles)
% hObject    handle to edit_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_date as text
%        str2double(get(hObject,'String')) returns contents of edit_date as a double


% --- Executes during object creation, after setting all properties.
function edit_date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_globals_Callback(hObject, eventdata, handles)
% hObject    handle to edit_globals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_globals as text
%        str2double(get(hObject,'String')) returns contents of edit_globals as a double


% --- Executes during object creation, after setting all properties.
function edit_globals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_globals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_globals.
function popupmenu_globals_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_globals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_globals contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_globals


% --- Executes during object creation, after setting all properties.
function popupmenu_globals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_globals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
        jtcp('write',handles.jTcpObj,{'Stop connection'});
        jtcp('close',handles.jTcpObj);
    case 1
        set(handles.togglebutton_TCP,'String','Stop TCP')
        set(handles.text_TCP_status,'String','connecting')
        set(handles.text_TCP_status,'BackgroundColor',[0 0 1])
        try
            handles.jTcpObj = jtcp('request',handles.TCP_IP_address,21566,'timeout',2000);
            % Update handles structure
            guidata(hObject, handles);
            jtcp('write',handles.jTcpObj,{'Start connection'});
            set(handles.text_TCP_status,'String','on')
            set(handles.text_TCP_status,'BackgroundColor',[0 1 0])
        catch
            set(handles.text_TCP_status,'String','FAILED')
            set(handles.text_TCP_status,'BackgroundColor',[1 0 0])
            set(handles.togglebutton_TCP,'Value',0) 
            set(handles.togglebutton_TCP,'String','Setup TCP')
        end
end




