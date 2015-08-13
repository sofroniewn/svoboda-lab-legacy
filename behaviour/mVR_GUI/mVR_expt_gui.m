function varargout = mVR_expt_gui(varargin)
% MVR_EXPT_GUI MATLAB code for mVR_expt_gui.fig
%      MVR_EXPT_GUI, by itself, creates a new MVR_EXPT_GUI or raises the existing
%      singleton*.
%
%      H = MVR_EXPT_GUI returns the handle to a new MVR_EXPT_GUI or the handle to
%      the existing singleton*.
%
%      MVR_EXPT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MVR_EXPT_GUI.M with the given input arguments.
%
%      MVR_EXPT_GUI('Property','Value',...) creates a new MVR_EXPT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mVR_expt_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mVR_expt_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mVR_expt_gui

% Last Modified by GUIDE v2.5 17-Apr-2015 14:59:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mVR_expt_gui_OpeningFcn, ...
    'gui_OutputFcn',  @mVR_expt_gui_OutputFcn, ...
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


% --- Executes just before mVR_expt_gui is made visible.
function mVR_expt_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mVR_expt_gui (see VARARGIN)

% Choose default command line output for mVR_expt_gui
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
handles.trial_mat_names = {'xSpeed','ySpeed','corPos','corWidth','xMazeCord','yMazeCord', ...
    'screenOn','rEnd','lEnd','lickState','trialWater','extWater', ...
    'trialID','itiPeriod','scimState','scimLogging','curBranchDist','curBranchId'};
handles.iti_ind = find(strcmp(handles.trial_mat_names,'itiPeriod'));

% Load trial configuration file
load_maze_config_Callback(handles.load_maze_config, eventdata, handles);
maze_all = get(handles.maze_config_str,'UserData');
maze_config = maze_all{1};
maze_array = maze_all{2};



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
set(gca,'FontSize',12)
xlabel('Time (s)','FontSize',12)
ylabel('Speed (cm/s) and Cor Pos (mm)','FontSize',12)
hold on

zero_init = zeros(2501,1);
x_axis = -5+[0:.002:5];

handles.branch_pos_plot = plot(x_axis,zero_init,'Color',[.4 0 .8],'LineWidth',3);
handles.cor_width_plot = plot(x_axis,zero_init,'Color',[.4 .4 .4],'LineWidth',3);
handles.screen_on_plot = plot(x_axis,zero_init,'Marker','.','MarkerSize',10,'LineStyle','none','MarkerEdgeColor',[1 .5 0]);
handles.speed_plot = plot(x_axis,zero_init,'r','LineWidth',3);
handles.speed_dot = plot(x_axis(end),0,'Marker','.','MarkerSize',18,'LineStyle','none','MarkerEdgeColor','b');
handles.trial_period_plot = plot(x_axis,zero_init,'Marker','.','MarkerSize',10,'LineStyle','none','MarkerEdgeColor','m');
handles.water_plot = plot(x_axis,zero_init,'Marker','.','MarkerSize',12,'LineStyle','none','MarkerEdgeColor',[0 .8 .8]);
handles.water_ext_plot = plot(x_axis,zero_init,'Marker','.','MarkerSize',12,'LineStyle','none','MarkerEdgeColor',[.3 .3 .6]);
handles.lick_plot = plot(x_axis,zero_init,'Marker','.','MarkerSize',10,'LineStyle','none','MarkerEdgeColor','b');
handles.cor_pos_plot = plot(x_axis,zero_init,'g','LineWidth',3);
handles.lEnd_plot = plot(x_axis,zero_init,'Marker','.','MarkerSize',10,'LineStyle','none','MarkerEdgeColor',[0 0 0]);
handles.rEnd_plot = plot(x_axis,zero_init,'Marker','.','MarkerSize',10,'LineStyle','none','MarkerEdgeColor',[0 0 0]);

xlim([-5 0])
ylim([0 80])


% Setup Pos Figure
axes(handles.axes_maze)
hold on
set(handles.axes_maze,'color',[0 0 0])
set(handles.axes_maze,'xtick',[])
set(handles.axes_maze,'ytick',[])
set(handles.axes_maze,'userdata',[]);
colormap('gray')

maze_x_lim = NaN(maze_config.num_mazes,1);
maze_y_lim = NaN(maze_config.num_mazes,1);
for ij = 1:maze_config.num_mazes
    maze_x_lim(ij) = maze_array{ij,1}.x_lim(2);
    maze_y_lim(ij) = maze_array{ij,1}.y_lim(2);
end
ylim([-20 max(maze_y_lim)])
xlim([-max(maze_x_lim) max(maze_x_lim)])
handles.tail_length = (max(maze_y_lim)+20)/35;

x_pos = zeros(5001,1);
y_pos = zeros(5001,1)-100;
handles.pos_plot =  plot(x_pos, y_pos,'Marker','.','MarkerSize',15,'LineStyle','none','MarkerEdgeColor',[.8 .8 .8]);

init_x = 0;
init_y = -100;
handles.tail_length = (max(maze_y_lim)+20)/35;
%handles.plot_tail = plot([init_x init_x],[init_y init_y-handles.tail_length],'Color',[0.2 0.2 0.2],'LineWidth',4);
handles.plot_body = plot(init_x,init_y,'.','MarkerSize',70,'MarkerEdgeColor',[1 1 1],'MarkerFaceColor',[1 1 1],'LineWidth',1);



% Setup Wall Pos Figure
corridor_width = 1;
axes(handles.axes_wall_hist)
hold on
set(gca,'FontSize',12)
xlabel('Corridor position (frac)','FontSize',12)
edges = [0:.01:corridor_width]';
totavg = zeros(size(edges));
count = zeros(size(edges));
handles.wall_pos_hist = plot(edges,totavg,'Color','b','LineWidth',4);
set(handles.wall_pos_hist,'UserData',count);
xlim([0 corridor_width])
set(gca,'xtick',[0:.2:corridor_width])
xlim([0 corridor_width])
ylim([0 .25])

% Disable water buttons
set(handles.pushbutton_water,'Enable','off')
set(handles.speed_thresh_up,'Enable','off')
set(handles.speed_thresh_down,'Enable','off')
set(gca,'FontSize',12)

% Setup Performance Figure
axes(handles.axes_performance)
hold on
set(gca,'FontSize',12)
frac_timeout = zeros(maze_config.num_mazes,1);
frac_rewarded = zeros(maze_config.num_mazes,1);
frac_correct = zeros(maze_config.num_mazes,1);

handles.plot_frac_timeout = bar([1:3:3*maze_config.num_mazes]/3,frac_timeout,0.28);
set(handles.plot_frac_timeout,'EdgeColor',[.8 0 .8])
set(handles.plot_frac_timeout,'FaceColor',[.8 0 .8])
handles.plot_frac_rewarded = bar(([1:3:3*maze_config.num_mazes]+1)/3,frac_rewarded,0.28);
set(handles.plot_frac_rewarded,'EdgeColor',[0 0 .8])
set(handles.plot_frac_rewarded,'FaceColor',[0 0 .8])
handles.plot_frac_correct = bar(([1:3:3*maze_config.num_mazes]+2)/3,frac_correct,0.28);
set(handles.plot_frac_correct,'EdgeColor',[.1 .1 .1])
set(handles.plot_frac_correct,'FaceColor',[.1 .1 .1])
ylim([0 1])
xlim([0 maze_config.num_mazes+1/3])
ylabel('Maze performance','FontSize',12)

% Setup Performance Figure
axes(handles.axes_all_perf)
hold on
set(gca,'FontSize',12)
handles.plot_all_frac_timeout = bar(1/3,0,0.28);
set(handles.plot_all_frac_timeout,'EdgeColor',[.8 0 .8])
set(handles.plot_all_frac_timeout,'FaceColor',[.8 0 .8])
handles.plot_all_frac_timeout_SE = plot([1/3 1/3],[0 0],'LineWidth',2,'Color',[0.5 0.5 0.5]);
handles.plot_all_frac_rewarded = bar(2/3,0,0.28);
set(handles.plot_all_frac_rewarded,'EdgeColor',[0 0 .8])
set(handles.plot_all_frac_rewarded,'FaceColor',[0 0 .8])
handles.plot_all_frac_rewarded_SE = plot([2/3 2/3],[0 0],'LineWidth',2,'Color',[0.5 0.5 0.5]);
handles.plot_all_frac_correct = bar(1,0,0.28);
set(handles.plot_all_frac_correct,'EdgeColor',[.1 .1 .1])
set(handles.plot_all_frac_correct,'FaceColor',[.1 .1 .1])
handles.plot_all_frac_correct_SE = plot([1 1],[0 0],'LineWidth',2,'Color',[0.5 0.5 0.5]);
ylim([0 1])
xlim([0 4/3])
ylabel('Maze performance','FontSize',12)
set(gca,'xticklabel',[])
%set(gca,'visible','off')
       
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


        % Enable log buttons
        set(handles.checkbox_log,'Enable','on')
        set(handles.edit_run_number,'Enable','on')
        set(handles.edit_animal_number,'Enable','on')
        set(handles.edit_date,'Enable','on')
        set(handles.load_maze_config,'Enable','on')
        set(handles.checkbox_stream_behaviour,'Enable','on')

        % Disable water buttons
        set(handles.pushbutton_water,'Enable','off')
        set(handles.speed_thresh_up,'Enable','off')
        set(handles.speed_thresh_down,'Enable','off')

    case 1 %Start RTLSM
        maze_all = get(handles.maze_config_str,'UserData');
        maze_config = maze_all{1};
        maze_array = maze_all{2};
        trial_vars = maze_all{3};

        rig_config = get(handles.figure1,'UserData');
        checkbox_log_value = get(handles.checkbox_log,'Value');
        str_animal_number = get(handles.edit_animal_number,'String');
        
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
        set(handles.rEnd_plot,'Ydata',zero_init);
        set(handles.lEnd_plot,'Ydata',zero_init);
        set(handles.lick_plot,'Ydata',zero_init);
        set(handles.screen_on_plot,'Ydata',zero_init);
        set(handles.cor_width_plot,'Ydata',zero_init);
        set(handles.branch_pos_plot,'Ydata',zero_init);

        x_pos = zeros(5001,1);
        y_pos = zeros(5001,1) - 100;
        set(handles.pos_plot,'Xdata',x_pos);
        set(handles.pos_plot,'Ydata',y_pos);
        
        maze_x_lim = NaN(maze_config.num_mazes,1);
        maze_y_lim = NaN(maze_config.num_mazes,1);
        for ij = 1:maze_config.num_mazes
            maze_x_lim(ij) = maze_array{ij,1}.x_lim(2);
            maze_y_lim(ij) = maze_array{ij,1}.y_lim(2);
        end
        axes(handles.axes_maze)
        ylim([-20 max(maze_y_lim)])
        xlim([-max(maze_x_lim) max(maze_x_lim)])
        
        init_x = 0;
        init_y = -100;
        %set(handles.plot_tail,'Xdata',[init_x init_x]);
        %set(handles.plot_tail,'Ydata',[init_y init_y-handles.tail_length]);
        set(handles.plot_body,'Xdata',init_x);
        set(handles.plot_body,'Ydata',init_y);
        to_delete = get(handles.axes_maze,'userdata');
        if ~isempty(to_delete)
            delete(to_delete)
        end
        set(handles.axes_maze,'userdata',[]);

        % pefromance axis setup
        axes(handles.axes_performance)
        frac_rewarded = zeros(maze_config.num_mazes,1);
        frac_dead_end = zeros(maze_config.num_mazes,1);
        set(handles.plot_frac_timeout,'xdata',[1:3:3*maze_config.num_mazes]/3)
        set(handles.plot_frac_timeout,'ydata',frac_rewarded)
        set(handles.plot_frac_rewarded,'xdata',([1:3:3*maze_config.num_mazes]+1)/3)
        set(handles.plot_frac_rewarded,'ydata',frac_rewarded)
        set(handles.plot_frac_correct,'xdata',([1:3:3*maze_config.num_mazes]+2)/3)
        set(handles.plot_frac_correct,'ydata',frac_dead_end)
        xlim([0 maze_config.num_mazes+1/3])

        
        perf_data.num_trials = zeros(maze_config.num_mazes,1);
        perf_data.timeout = zeros(maze_config.num_mazes,1);
        perf_data.correct = zeros(maze_config.num_mazes,1);
        perf_data.rewarded = zeros(maze_config.num_mazes,1);
        set(handles.axes_performance,'UserData',perf_data);

        set(handles.plot_all_frac_timeout,'ydata',0)
        set(handles.plot_all_frac_rewarded,'ydata',0)
        set(handles.plot_all_frac_correct,'ydata',0)
        set(handles.plot_all_frac_timeout_SE,'ydata',[0 0]);
        set(handles.plot_all_frac_rewarded_SE,'ydata',[0 0]);
        set(handles.plot_all_frac_correct_SE,'ydata',[0 0]);
  
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
        set(handles.load_maze_config,'Enable','off')
        set(handles.checkbox_stream_behaviour,'Enable','off')


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
                   
        % Get globals file name
        fileIn = fullfile('.','globals',rig_config.globals_name);
        fileOut = fullfile('.','globals',[rig_config.globals_name(1:end-2) '_used.c']);
        text_replacer_mVR(maze_config,rig_config,fileIn,fileOut);
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
            save([fname_base 'trial_config.mat'],'maze_config','maze_array','trial_vars');
            fid = fopen(fname_log,'w'); % Open text file on Windows Machine for saving values
            if fid == -1
                error('File Not Created')
            else
            end
            handles.fid = fid;
        else
        end
        
        % If streaming behaviour to non local source 
        if get(handles.checkbox_stream_behaviour,'Value')
            stream_folder_name = fullfile(rig_config.accesory_path,['anm_0' str_animal_number],['20' str_date(1:2) '_' str_date(3:4) '_' str_date(5:6)],['run_' str_run_number],'behaviour');
            stream_fname_base = fullfile(stream_folder_name,file_id_name);
            if exist(stream_folder_name) ~= 7
                mkdir(stream_folder_name);
            end
            stream_fname_globals = [stream_fname_base rig_config.globals_name];
            handles.stream_fname_base = stream_fname_base;
            copyfile(fileOut,stream_fname_globals);
            save([stream_fname_base 'rig_config.mat'],'rig_config');
            save([stream_fname_base 'trial_config.mat'],'maze_config','maze_array','trial_vars');
        end




        % Setup timer
        handles.obj_t = timer('TimerFcn',{@update_function_mVR,handles});
        set(handles.obj_t,'ExecutionMode','fixedRate');
        set(handles.obj_t,'Period', .15);
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

% --- Executes on button press in load_maze_config.
function load_maze_config_Callback(hObject, eventdata, handles)
% hObject    handle to load_maze_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,FilterIndex] = uigetfile(fullfile(handles.pathstr,'maze_configs','*.mat'));
set(handles.maze_config_str,'String',FileName);
load_dat = load([PathName,FileName]);
maze_config = maze_dat_parser(load_dat);

maze_array = cell(size(load_dat.maze_names,1),3);
for ij = 1:size(load_dat.maze_names,1)
    [maze dat] = create_maze(load_dat.dat_array{ij},str2double(load_dat.start_branch_array{ij}));
    maze_array{ij,1} = maze;
    maze_array{ij,2} = dat;
    maze_array{ij,3} = load_dat.start_branch_array{ij};
    maze_array{ij,4} = load_dat.maze_names{ij};
end
trial_vars = load_dat.trial_vars;
set(handles.maze_config_str,'UserData',{maze_config, maze_array, trial_vars});
%full_name = [PathName,FileName];
%WGNR_trial_viewer_gui({full_name});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Outputs from this function are returned to the command line.
function varargout = mVR_expt_gui_OutputFcn(hObject, eventdata, handles)
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


% --- Executes on button press in checkbox_stream_behaviour.
function checkbox_stream_behaviour_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_stream_behaviour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_stream_behaviour
