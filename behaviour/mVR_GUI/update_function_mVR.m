function update_function_mVR(obj,event,handles)

%%% GET LOGGED VALUES
numVarLog = get(obj,'UserData');
start_no = handles.init_numVarLog+numVarLog+1;
end_no = GetVarLogCounter(handles.sm);
varLog = GetVarLog(handles.sm,start_no,end_no);
varLog = cell2mat(varLog(:,3));
set(obj,'UserData',numVarLog+length(varLog));

%%% WRITE LOGGED VALUES TO FILE
checkbox_log_value = get(handles.checkbox_log,'Value');
if checkbox_log_value == 1
    fprintf(handles.fid,'%d ',varLog);
else
end

update_display_on = 1;
num_log_items = 4;

%%% CHECK IF RTFSM STOPPED
if isempty(varLog) == 0 && update_display_on == 1

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % EXTRACT DATA FROM VARLOG
    num_samples = length(varLog)/num_log_items;
    trial_mat_names = handles.trial_mat_names;
    trial_mat = zeros(numel(trial_mat_names),num_samples);
    
    ball_motion = varLog(2:num_log_items:end);
    cam_vel_step = zeros(num_samples,4);
    zz = ball_motion;
    
    % Convert to Camera Steps
    cam_vel_step(:,4) = round(zz/36^3);
    zz = zz - cam_vel_step(:,4)*36^3;
    cam_vel_step(:,3) = round(zz/36^2);
    zz = zz - cam_vel_step(:,3)*36^2;
    cam_vel_step(:,2) = round(zz/36^1);
    zz = zz - cam_vel_step(:,2)*36^1;
    cam_vel_step(:,1) = round(zz);
    % Convert to ball roation
    d_ball_pos = cam_vel_step*handles.A_inv';
    
    %handles.trial_mat_names = {'xSpeed','ySpeed','corPos','corWidth','forMazeCord','latMazeCord', ...
    %'screenOn','rEnd','lEnd','lickState','trialWater','extWater', ...
    %'trialID','itiPeriod','scimState','scimLogging','curBranchDist','curBranchId'};

    trial_mat(1,:) = d_ball_pos(:,1);
    trial_mat(2,:) = d_ball_pos(:,2);
    
    trial_mat(3,:) = mod(varLog(3:num_log_items:end),1000)/10; % corPos
    trial_mat(4,:) = floor(varLog(3:num_log_items:end)/1000)/10; % corWidth

    trial_mat(17,:) = mod(varLog(1:num_log_items:end),1000)/20; % branch forward position
    trial_mat(18,:) = 1+mod(floor(varLog(1:num_log_items:end)/1000),100); % branch id;


    log_cur_state = varLog(4:num_log_items:end);
    trial_mat(13,:) = 1 + mod(log_cur_state,100); % trialID
    log_state_a = mod(floor(log_cur_state/100),10);
    log_state_b = mod(floor(log_cur_state/1000),10);
    log_state_c = mod(floor(log_cur_state/10000),10);
    
    trial_mat(14,:) = mod(floor(log_state_a/4),2); % ITI
    trial_mat(10,:) = mod(floor(log_state_a/2),2); % lick state
    trial_mat(11,:) = mod(log_state_a,2); % trial water
    trial_mat(7,:) = mod(floor(log_state_b/4),2); % screen on
    trial_mat(9,:) = mod(floor(log_state_b/2),2); % left dead end
    trial_mat(15,:) = mod(log_state_b,2); % scim state
    trial_mat(12,:) = mod(floor(log_state_c/4),2); % ext water
    trial_mat(16,:) = mod(floor(log_state_c/2),2); % scim logging
    trial_mat(8,:) = mod(log_state_c,2); % right dead end
    
    maze_all = get(handles.maze_config_str,'UserData');
    maze_config = maze_all{1};

    idx = sub2ind(size(maze_config.branch_for_start), trial_mat(13,:), trial_mat(18,:));
    branch_start_for = maze_config.branch_for_start(idx);
    branch_r_lat_start = maze_config.branch_r_lat_start(idx);
    right_angle = maze_config.branch_right_angle(idx);

    gain_val = maze_config.maze_wall_gain(trial_mat(13,:))';
    if ~isrow(gain_val)
        gain_val = gain_val';
    end

    trial_mat(5,:) = branch_start_for + trial_mat(17,:); % forMaze coordinate

    trial_mat(6,:) = branch_r_lat_start + gain_val.*trial_mat(17,:).*tand(right_angle) - trial_mat(3,:); % latMaze coordinate

    % if in iti set them to 0
    trial_mat(5,find(trial_mat(14,:))) = NaN;
    trial_mat(6,find(trial_mat(14,:))) = NaN;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Check if new trial - if so chunck and save data
    trial_info = get(handles.text_num_trials,'UserData');
    iti_vect = [trial_info.iti_end trial_mat(handles.iti_ind,:)];
    iti_diff = diff(iti_vect);
    ind = find(iti_diff == 1,1,'first');
    trial_num = trial_info.trial_num;
    if isempty(ind) == 1 % no new trial found
        trial_info.trial_mat = [trial_info.trial_mat trial_mat];
    else % new trial found at first ind
        trial_matrix = [trial_info.trial_mat trial_mat(:,1:ind-1)];
        trial_info.trial_mat = trial_mat(:,ind:end);
        if checkbox_log_value
            save([handles.fname_base sprintf('trial_%04d.mat',trial_num)],'trial_matrix','trial_mat_names','trial_num');
        end
        if get(handles.checkbox_stream_behaviour,'Value');
           save([handles.stream_fname_base sprintf('trial_%04d.mat',trial_num)],'trial_matrix','trial_mat_names','trial_num');
        end
        
        trial_num = trial_num+1;
        % clear plot
        to_delete = get(handles.axes_maze,'userdata');
        delete(to_delete)
        set(handles.axes_maze,'userdata',[]);

        rewarded = any(trial_matrix(11,:));
        dead_end = any(trial_matrix(8,:)) || any(trial_matrix(9,:));
        timeout = ~rewarded && ~dead_end;
        if rewarded
            ind_c = find(trial_matrix(11,:),1,'first');
            correct = ~any(trial_matrix(8,1:ind_c)) && ~any(trial_matrix(9,1:ind_c));
        else
            correct = 0;
        end

        cur_trial = trial_matrix(13,1);
        perf_data = get(handles.axes_performance,'UserData');

        perf_data.num_trials(cur_trial) = perf_data.num_trials(cur_trial) + 1;
        perf_data.timeout(cur_trial) = perf_data.timeout(cur_trial) + timeout;
        perf_data.correct(cur_trial) = perf_data.correct(cur_trial) + correct;
        perf_data.rewarded(cur_trial) = perf_data.rewarded(cur_trial) + rewarded;
        set(handles.axes_performance,'UserData',perf_data);

        set(handles.plot_frac_timeout,'ydata',perf_data.timeout./perf_data.num_trials);
        set(handles.plot_frac_rewarded,'ydata',perf_data.rewarded./(perf_data.num_trials - perf_data.timeout));
        set(handles.plot_frac_correct,'ydata',perf_data.correct./(perf_data.num_trials - perf_data.timeout));
        
        p_t = sum(perf_data.timeout)/sum(perf_data.num_trials);
        p_r = sum(perf_data.rewarded)/sum(perf_data.num_trials - perf_data.timeout);
        p_c = sum(perf_data.correct)/sum(perf_data.num_trials - perf_data.timeout);
        se_t = p_t*(1-p_t)/sqrt(sum(perf_data.num_trials));
        se_r = p_r*(1-p_r)/sqrt(sum(perf_data.num_trials - perf_data.timeout));
        se_c = p_c*(1-p_c)/sqrt(sum(perf_data.num_trials - perf_data.timeout));
        
        set(handles.plot_all_frac_timeout,'ydata',p_t);
        set(handles.plot_all_frac_rewarded,'ydata',p_r);
        set(handles.plot_all_frac_correct,'ydata',p_c);

        set(handles.plot_all_frac_timeout_SE,'ydata',p_t + [-se_t se_t]);
        set(handles.plot_all_frac_rewarded_SE,'ydata',p_r + [-se_r se_r]);
        set(handles.plot_all_frac_correct_SE,'ydata',p_c + [-se_c se_c]);

    end
    trial_info.trial_num = trial_num;
    trial_info.iti_end = trial_mat(handles.iti_ind,end);
    set(handles.text_num_trials,'UserData',trial_info);

    speed_vect =  sqrt(trial_mat(1,:).^2 +  trial_mat(2,:).^2)*500;
    
%[trial_mat(3:4,:);trial_mat(3,:) + trial_mat(4,:)]

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Update plots
    speed = get(handles.speed_plot,'Ydata')';
    speed = [speed(num_samples+1:end);speed_vect'];
    cor_pos = get(handles.cor_pos_plot,'Ydata')';
    cor_pos = [cor_pos(num_samples+1:end);trial_mat(3,:)'];
    cor_width = get(handles.cor_width_plot,'Ydata')';
    cor_width = [cor_width(num_samples+1:end);trial_mat(4,:)'];
    branch_pos = get(handles.branch_pos_plot,'Ydata')';
    branch_pos = [branch_pos(num_samples+1:end);trial_mat(17,:)'];
    

    rEnd = get(handles.rEnd_plot,'Ydata')';
    rEnd = [rEnd(num_samples+1:end);72*trial_mat(9,:)'];
    lEnd = get(handles.lEnd_plot,'Ydata')';
    lEnd = [lEnd(num_samples+1:end);72*trial_mat(8,:)'];

    screen_on = get(handles.screen_on_plot,'Ydata')';
    screen_on = [screen_on(num_samples+1:end);76*trial_mat(7,:)'];

    water = get(handles.water_plot,'Ydata')';
    trans = diff([round((water(end))/20);trial_mat(11,:)']);
    trans = sum(trans==1);
    num_rewards = str2num(get(handles.text_num_water,'String')) + trans;
    set(handles.text_num_water,'String',num2str(num_rewards));
    water = [water(num_samples+1:end);20*trial_mat(11,:)'];
    
    water_ext = get(handles.water_ext_plot,'Ydata')';
    trans = diff([round((water_ext(end))/22);trial_mat(12,:)']);
    trans = sum(trans==1);
    water_ext = [water_ext(num_samples+1:end);22*trial_mat(12,:)'];
  
    licks = get(handles.lick_plot,'Ydata')';
    trans = diff([round((licks(end))/35);trial_mat(10,:)']);
    trans = sum(trans==1);
    num_licks = str2num(get(handles.text_num_licks,'String')) + trans;
    set(handles.text_num_licks,'String',num2str(num_licks));
    licks = [licks(num_samples+1:end);35*trial_mat(10,:)'];
    
    set(handles.text_num_trials,'String',num2str(trial_num));

    trial_period = get(handles.trial_period_plot,'Ydata')';
    trial_period = [trial_period(num_samples+1:end);74*trial_mat(14,:)'];
    
    % Update strings
    set(handles.speed_plot,'Ydata',speed);
    set(handles.speed_dot,'Ydata',speed(end));
    set(handles.cor_pos_plot,'Ydata',cor_pos);
    set(handles.water_plot,'Ydata',water);
    set(handles.water_ext_plot,'Ydata',water_ext);
    set(handles.cor_width_plot,'Ydata',cor_width);
    set(handles.lEnd_plot,'Ydata',lEnd);
    set(handles.rEnd_plot,'Ydata',rEnd);
    set(handles.screen_on_plot,'Ydata',screen_on);
    set(handles.lick_plot,'Ydata',licks);
    set(handles.trial_period_plot,'Ydata',trial_period);
    set(handles.branch_pos_plot,'Ydata',branch_pos);

    set(handles.text_cur_trial_num,'String',num2str(trial_mat(13,end)));
    set(handles.text_cur_cor_pos,'String',num2str(mean(trial_mat(4,:))));
    set(handles.text_cur_cor_width,'String',num2str(mean(trial_mat(4,:) + trial_mat(3,:))));
    
    % set(handles.text_cur_mf,'String',num2str(trial_mat(13,end)));
    % set(handles.text_cur_ps_power,'String',num2str(trial_mat(5,end)));
    % set(handles.text_cur_y_mirr_pos,'String',num2str(trial_mat(7,end)));
    % set(handles.text_cur_x_mirr_pos,'String',num2str(trial_mat(6,end)));
    
    % wall pos hist
    corridor_width = 1;
    edges = [0:.01:corridor_width]';
    cur_totavg = get(handles.wall_pos_hist,'YData');
    cur_totavg = cur_totavg';
    cur_count = get(handles.wall_pos_hist,'UserData');
    cur_totsum = cur_totavg; %.*cur_count;
    ind_ss = speed_vect > 5 & ~trial_mat(14,:);
    x = trial_mat(3,ind_ss)./trial_mat(4,ind_ss);
    val = speed_vect(ind_ss);
    [count bin] = histc(x,edges);
    totsum = count; %accumarray(bin,val,size(edges));
    if isrow(count) == 1
        count = count';
    else
    end
    if isrow(totsum) == 1
        totsum = totsum';
    else
    end
    totsum = cur_totsum + totsum;
    count = count + cur_count;
    totavg = totsum; %./count;
    totavg(isnan(totavg)) = 0;
    set(handles.wall_pos_hist,'YData',totavg);
    set(handles.wall_pos_hist,'UserData',count);
    y_lim_max = 1.2*max(totavg([5:end-5]));
    if y_lim_max <= 0
        y_lim_max = 0.1;
    else
    end
    if isnan(y_lim_max) == 1
        y_lim_max = 0.1;
    else
    end
    if isempty(y_lim_max) == 1
        y_lim_max = 0.1;
    else
    end
    set(handles.axes_wall_hist,'Ylim',[0 y_lim_max]);
    
    prev_samples = get(handles.text_run_time,'UserData');
    tot_num_samples = num_samples + prev_samples;
    set(handles.text_run_time,'UserData',tot_num_samples);
    set(handles.text_run_time,'String',sprintf('%.2f s',tot_num_samples/500));


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isempty(get(handles.axes_maze,'userdata')) && ~trial_mat(14,end)
        %axes(handles.axes_maze)
        %hold on
        %hm = plot(handles.axes_maze,[0 200*rand],[0 100*rand],'r','linewidth',5);
        %hd = plot(handles.axes_maze,[0 200*rand],[0 -100*rand],'g','linewidth',5);
        %drawnow
        maze_all = get(handles.maze_config_str,'UserData');
        maze_config = maze_all{1};
        maze_array = maze_all{2};
        maze = maze_array{trial_mat(13,end),1};
        h_all = plot_maze(handles.axes_maze,maze,0,0,0);
        set(handles.axes_maze,'UserData',h_all);
        uistack(handles.pos_plot, 'top');
        uistack(handles.plot_body, 'top');
    end

    if ~trial_mat(14,end) && isempty(ind)
        init_x = trial_mat(6,end);
        init_y = trial_mat(5,end);

        x_pos = get(handles.pos_plot,'Xdata')';
        y_pos = get(handles.pos_plot,'Ydata')';
         ds_x_pos = trial_mat(6,1:5:end);
         ds_y_pos = trial_mat(5,1:5:end);
         x_pos = [x_pos(length(ds_x_pos)+1:end);ds_x_pos'];
         y_pos = [y_pos(length(ds_y_pos)+1:end);ds_y_pos'];
     else
         init_x = 0;
         init_y = -100;
         x_pos = zeros(5001,1);
         y_pos = zeros(5001,1) - 100;
    end

     %set(handles.plot_tail,'Xdata',[init_x init_x]);
     %set(handles.plot_tail,'Ydata',[init_y init_y-handles.tail_length]);
     set(handles.plot_body,'Xdata',init_x);
     set(handles.plot_body,'Ydata',init_y);
     set(handles.pos_plot,'Xdata',x_pos);
     set(handles.pos_plot,'Ydata',y_pos);    
end







