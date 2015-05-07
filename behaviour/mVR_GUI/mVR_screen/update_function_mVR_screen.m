function update_function_mVR_screen(obj,event,handles)
try
	% read data
	data = fscanf(handles.s,'%s');
    data = eval(['[' data ']']);
if length(data) ~= 4
	warning('Data wrong length')
else
    
	screenOn = data(1);
%	curTrialNum = 1+floor(100*data(2)/1024);
    curTrialNum = 1+round(data(2)/50);
    init_y = data(3)/1024*100 - 2 - 0.0117;
	init_x = data(4)/1024*100 - 50 + 0.0977;
    
    init_y = init_y/2;
    init_x = init_x/2;

    init_x = round(init_x*5)/5;
    init_y = round(init_y*5)/5;
    
    if ~screenOn && ~isempty(get(handles.axes_maze,'userdata'))
        dat = get(handles.axes_maze,'userdata');
        to_delete = dat{1};
        delete(to_delete);
        set(handles.axes_maze,'userdata',{[],[],0});
    end

    dat = get(handles.axes_maze,'userdata');
    if isempty(dat{1}) && screenOn
        maze_all = get(handles.maze_config_str,'UserData');
        maze_config = maze_all{1};
        maze_array = maze_all{2};
        maze = maze_array{curTrialNum};
        [h_all reward_params] = plot_maze(handles.axes_maze,maze,0,0,0);
        set(handles.axes_maze,'UserData',{h_all,reward_params,0});
        set(handles.text_cur_trial_num,'String',num2str(curTrialNum));
        uistack(handles.plot_body, 'top');
    end

    if screenOn
        if  get(handles.checkbox_path,'value')
            x_pos = get(handles.pos_plot,'Xdata')';
            y_pos = get(handles.pos_plot,'Ydata')';
            ds_x_pos = init_x;
            ds_y_pos = init_y;
            x_pos = [x_pos(length(ds_x_pos)+1:end);ds_x_pos'];
            y_pos = [y_pos(length(ds_y_pos)+1:end);ds_y_pos'];
            set(handles.pos_plot,'Xdata',x_pos);
            set(handles.pos_plot,'Ydata',y_pos); 
        end

        if ~isempty(dat{2}.h)
            for ij = 1:length(dat{2}.h)
                phase = dat{3};
                phase = phase - 5/100*2*pi;
                phase = mod(phase,2*pi);
                dat{3} = phase;
                tform = dat{2}.tform{ij};
                [gclipped xdata ydata] = make_reward_patch(squeeze(dat{2}.end_vals(:,1,ij)),squeeze(dat{2}.end_vals(:,2,ij)),dat{2}.scale(ij),phase,tform);
                set(dat{2}.h(ij),'CData',gclipped);
                set(handles.axes_maze,'UserData',dat);
            end
        end
    else
         init_x = 0;
         init_y = -100;
         x_pos = zeros(2501,1);
         y_pos = zeros(2501,1) - 100;
    end

     %set(handles.plot_tail,'Xdata',[init_x init_x]);
     %set(handles.plot_tail,'Ydata',[init_y init_y-handles.tail_length]);
     set(handles.plot_body,'Xdata',init_x);
     set(handles.plot_body,'Ydata',init_y);          
end

catch
    	warning('Data could not evaluate')
end
elapsed_time = toc;
set(handles.text_run_time,'String',sprintf('%.2f s',elapsed_time));

drawnow



