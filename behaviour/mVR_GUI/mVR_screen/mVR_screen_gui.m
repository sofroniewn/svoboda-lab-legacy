function varargout = mVR_screen_gui(varargin)
% MVR_SCREEN_GUI MATLAB code for mVR_screen_gui.fig
%      MVR_SCREEN_GUI, by itself, creates a new MVR_SCREEN_GUI or raises the existing
%      singleton*.
%
%      H = MVR_SCREEN_GUI returns the handle to a new MVR_SCREEN_GUI or the handle to
%      the existing singleton*.
%
%      MVR_SCREEN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MVR_SCREEN_GUI.M with the given input arguments.
%
%      MVR_SCREEN_GUI('Property','Value',...) creates a new MVR_SCREEN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mVR_screen_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mVR_screen_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mVR_screen_gui

% Last Modified by GUIDE v2.5 22-Apr-2015 11:12:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mVR_screen_gui_OpeningFcn, ...
    'gui_OutputFcn',  @mVR_screen_gui_OutputFcn, ...
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


% --- Executes just before mVR_screen_gui is made visible.
function mVR_screen_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mVR_screen_gui (see VARARGIN)

% Choose default command line output for mVR_screen_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

p = mfilename('fullpath');
[pathstr, name, ext] = fileparts(p);
[pathstr, name, ext] = fileparts(pathstr);
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
    'trialID','itiPeriod','scim_state','scim_logging'};
handles.iti_ind = find(strcmp(handles.trial_mat_names,'itiPeriod'));

% Load trial configuration file
load_maze_config_Callback(handles.load_maze_config, eventdata, handles);
maze_all = get(handles.maze_config_str,'UserData');
maze_config = maze_all{1};
maze_array = maze_all{2};

set(handles.text_cur_trial_num,'String',num2str(0));
set(handles.text_run_time,'UserData',0);
set(handles.text_run_time,'String',sprintf('%.2f s',0));
        

% Setup Pos Figure
handles.figure_maze = figure(287);
set(gcf,'Position',[440   142   416   656])
set(gcf, 'MenuBar', 'None')
handles.axes_maze = gca;
set(handles.axes_maze,'Position',[0   0   1   1])
axes(handles.axes_maze)
hold on
set(handles.axes_maze,'color',[0 0 0])
set(handles.axes_maze,'xtick',[])
set(handles.axes_maze,'ytick',[])
set(handles.axes_maze,'userdata',{[],[],0});


maze_x_lim = NaN(maze_config.num_mazes,1);
maze_y_lim = NaN(maze_config.num_mazes,1);
for ij = 1:maze_config.num_mazes
    maze_x_lim(ij) = maze_array{ij}.x_lim(2);
    maze_y_lim(ij) = maze_array{ij}.y_lim(2);
end
ylim([-20 max(maze_y_lim)])
xlim([-max(maze_x_lim) max(maze_x_lim)])

x_pos = zeros(2501,1);
y_pos = zeros(2501,1)-100;
handles.pos_plot =  plot(x_pos, y_pos,'Marker','.','MarkerSize',20,'LineStyle','none','MarkerEdgeColor',[.7 .7 .7]);

init_x = 0;
init_y = 100;
%handles.tail_length = (max(maze_y_lim)+20)/25;
%handles.plot_tail = plot([init_x init_x],[init_y init_y-handles.tail_length],'Color',[0.2 0.2 0.2],'LineWidth',5);
handles.plot_body = plot(init_x,init_y,'.','MarkerSize',100,'MarkerEdgeColor',.99*[1 1 1],'MarkerFaceColor',.99*[1 1 1],'LineWidth',1);


% Prepare serial communication
handles.s = serial(rig_config.screenComPort);
set(handles.s,'DataBits',8);
set(handles.s,'StopBits',1);
set(handles.s,'BaudRate',115200);
set(handles.s,'Parity','none');
set(handles.s,'inputbuffersize',1024);
set(handles.s,'terminator','LF');
set(handles.s,'BytesAvailableFcnMode','terminator');
set(handles.s,'bytesavailablefcn',{@update_function_mVR_screen,handles});
       
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in togglebutton_start.
function togglebutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject,'value')
    case 0 %Stop Acquisition
        
        set(handles.togglebutton_start,'Enable','off')
        set(handles.togglebutton_start,'backgroundcolor','b','string','Resetting screen');        
        %stop(handles.obj_t)
        %delete(handles.obj_t);
    
        % Close serial
        fclose(handles.s);

 
        disp(sprintf('Screen Stopped by User\n'));
        % Enable buttons
        set(handles.checkbox_path,'Enable','on')
        set(handles.togglebutton_start,'backgroundcolor','r','string','Start screen');
        set(handles.text_run_time,'backgroundcolor','r');
        set(handles.togglebutton_start,'Enable','on')
        set(handles.load_maze_config,'Enable','on')

    case 1 %Start RTLSM
        maze_all = get(handles.maze_config_str,'UserData');
        maze_config = maze_all{1};
        maze_array = maze_all{2};
        rig_config = get(handles.figure1,'UserData');

        
        % Reset strings
        set(handles.text_cur_trial_num,'String',num2str(0));
        set(handles.text_run_time,'UserData',0);
        set(handles.text_run_time,'String',sprintf('%.2f s',0));
        
        % Reset figures
        x_pos = zeros(2501,1);
        y_pos = zeros(2501,1) - 100;
        set(handles.pos_plot,'Xdata',x_pos);
        set(handles.pos_plot,'Ydata',y_pos);
        
        maze_x_lim = NaN(maze_config.num_mazes,1);
        maze_y_lim = NaN(maze_config.num_mazes,1);
        for ij = 1:maze_config.num_mazes
            maze_x_lim(ij) = maze_array{ij}.x_lim(2);
            maze_y_lim(ij) = maze_array{ij}.y_lim(2);
        end
        axes(handles.axes_maze)
        ylim([-20 max(maze_y_lim)])
        xlim([-max(maze_x_lim) max(maze_x_lim)])
        handles.tail_length = (max(maze_y_lim)+20)/30;

        init_x = 0;
        init_y = -100;
        %set(handles.plot_tail,'Xdata',[init_x init_x]);
        %set(handles.plot_tail,'Ydata',[init_y init_y-handles.tail_length]);
        set(handles.plot_body,'Xdata',init_x);
        set(handles.plot_body,'Ydata',init_y);
        dat = get(handles.axes_maze,'userdata');
        to_delete = dat{1};
        if ~isempty(to_delete)
            delete(to_delete)
        end
        set(handles.axes_maze,'userdata',{[],[],0});

        cur_pos = get(gcf,'Position');
        set(handles.plot_body,'MarkerSize',cur_pos(3)/6);
        

        % Disable logging options
        set(handles.checkbox_path,'Enable','off')
        set(handles.load_maze_config,'Enable','off')

        drawnow

        % Setup timer
        % handles.obj_t = timer('TimerFcn',{@update_function_mVR_screen,handles});
        % set(handles.obj_t,'ExecutionMode','fixedRate');
        % set(handles.obj_t,'Period', .1);
        % set(handles.obj_t,'BusyMode','queue');
        % set(handles.obj_t,'ErrorFcn',@(obj,event)disp('Timing Error'));
        
        % Update handles structure
        guidata(hObject, handles);
        
        % Start RTLSM
        set(hObject,'backgroundcolor','g','string','Screen Running');
        set(handles.text_run_time,'backgroundcolor','g');
        disp(sprintf('\nStarting screen'))
        
        tic;

        % Open serial
        fopen(handles.s);
        fscanf(handles.s,'%s');

        % Start Timer
        % start(handles.obj_t)
        
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

maze_array = cell(size(load_dat.maze_names,1),1);
for ij = 1:size(load_dat.maze_names,1)
    [maze dat] = create_maze(load_dat.dat_array{ij},str2double(load_dat.start_branch_array{ij}));
    maze_array{ij} = maze;
end
set(handles.maze_config_str,'UserData',{maze_config, maze_array});
%full_name = [PathName,FileName];
%WGNR_trial_viewer_gui({full_name});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Outputs from this function are returned to the command line.
function varargout = mVR_screen_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox_stream_behaviour.
function checkbox_path_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_stream_behaviour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_stream_behaviour
