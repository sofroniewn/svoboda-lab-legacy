function update_function_mVR_screen(obj,event,handles)

try
	% read data
	data = fscanf(handles.s,'%s');
    data = eval(['[' data ']']);
if length(data) ~= 4
	warning('Data wrong length')
else
    
	screenOn = data(1);
	curTrialNum = 1+floor(100*data(2)/1024);
	init_x = (data(3)/1024*1000)-500;
	init_y = (data(4)/1024*1000);
    
    curTrialNum = 1;
    
    if ~screenOn && ~isempty(get(handles.axes_maze,'userdata'))
        to_delete = get(handles.axes_maze,'userdata');
        delete(to_delete)
        set(handles.axes_maze,'userdata',[]);
    end

    if isempty(get(handles.axes_maze,'userdata')) && screenOn
        maze_all = get(handles.maze_config_str,'UserData');
        maze_config = maze_all{1};
        maze_array = maze_all{2};
        maze = maze_array{curTrialNum};
        h_all = plot_maze(handles.axes_maze,maze,0,0,0);
        set(handles.axes_maze,'UserData',h_all);
        set(handles.text_cur_trial_num,'String',num2str(curTrialNum));
    end

    if screenOn
         x_pos = get(handles.pos_plot,'Xdata')';
         y_pos = get(handles.pos_plot,'Ydata')';
         ds_x_pos = init_x;
         ds_y_pos = init_y;
         x_pos = [x_pos(length(ds_x_pos)+1:end);ds_x_pos'];
         y_pos = [y_pos(length(ds_y_pos)+1:end);ds_y_pos'];
     else
         init_x = 0;
         init_y = -100;
         x_pos = zeros(5001,1);
         y_pos = zeros(5001,1) - 100;
    end
     init_y = data(3)/40;
     init_x = 20;

     set(handles.plot_tail,'Xdata',[init_x init_x]);
     set(handles.plot_tail,'Ydata',[init_y init_y-handles.tail_length]);
     set(handles.plot_body,'Xdata',init_x);
     set(handles.plot_body,'Ydata',init_y);
     if get(handles.checkbox_path,'value')
        set(handles.pos_plot,'Xdata',x_pos);
        set(handles.pos_plot,'Ydata',y_pos);  
     end  
end

catch
    	warning('Data could not evaluate')
end
elapsed_time = toc;
set(handles.text_run_time,'String',sprintf('%.2f s',elapsed_time));

drawnow




