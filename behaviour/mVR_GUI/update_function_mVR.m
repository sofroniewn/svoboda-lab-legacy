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

    num_samples = length(varLog)/num_log_items;
    trial_mat_names = handles.trial_mat_names;
    trial_mat = zeros(numel(trial_mat_names),num_samples);
    
    % EXTRACT DATA FROM VARLOG
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
    trial_mat(1,:) = d_ball_pos(:,1);
    trial_mat(2,:) = d_ball_pos(:,2);
    
    trial_mat(3,:) = mod(varLog(3:num_log_items:end),1000)/10;
    trial_mat(4,:) = floor(varLog(3:num_log_items:end)/1000)/10;
    trial_mat(5,:) = floor(varLog(1:num_log_items:end)/10000)/10;
    trial_mat(6,:) = floor(mod(varLog(1:num_log_items:end),10000)/100)/10 - 5;
    trial_mat(7,:) = floor(mod(varLog(1:num_log_items:end),100))/10 - 5;

    log_cur_state = varLog(4:num_log_items:end);
    trial_mat(8,:) = 1 + mod(log_cur_state,100);
    log_state_a = mod(floor(log_cur_state/100),10);
    log_state_b = mod(floor(log_cur_state/1000),10);
    log_state_c = mod(floor(log_cur_state/10000),10);
    
    trial_mat(9,:) = mod(floor(log_state_a/4),2);
    trial_mat(10,:) = mod(floor(log_state_a/2),2);
    trial_mat(11,:) = mod(log_state_a,2);
    trial_mat(12,:) = mod(floor(log_state_b/4),2);
    trial_mat(13,:) = mod(floor(log_state_b/2),2);
    trial_mat(14,:) = mod(log_state_b,2);
    trial_mat(15,:) = mod(floor(log_state_c/4),2);
    trial_mat(16,:) = mod(floor(log_state_c/2),2);
    trial_mat(17,:) = mod(log_state_c,2);
    
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
        if get(handles.togglebutton_TCP,'Value')
            try 
                jtcp('write',handles.jTcpObj,{'trial_data', trial_num, trial_matrix});
            catch
            end
        end
        trial_num = trial_num+1;
    end
    trial_info.trial_num = trial_num;
    trial_info.iti_end = trial_mat(handles.iti_ind,end);
    set(handles.text_num_trials,'UserData',trial_info);

    speed_vect =  sqrt(trial_mat(1,:).^2 +  trial_mat(2,:).^2)*500;
    
    % Update plots
    speed = get(handles.speed_plot,'Ydata')';
    speed = [speed(num_samples+1:end);speed_vect'];
    cor_pos = get(handles.cor_pos_plot,'Ydata')';
    cor_pos = [cor_pos(num_samples+1:end);trial_mat(3,:)'];
    cor_width = get(handles.cor_width_plot,'Ydata')';
    cor_width = [cor_width(num_samples+1:end);trial_mat(4,:)'];

    laser_power = get(handles.laser_power_plot,'Ydata')';
    laser_power = [laser_power(num_samples+1:end);10*trial_mat(5,:)'];

    water = get(handles.water_plot,'Ydata')';
    trans = diff([round((water(end))/20);trial_mat(11,:)']);
    trans = sum(trans==1);
    num_rewards = str2num(get(handles.text_num_water,'String')) + trans;
    set(handles.text_num_water,'String',num2str(num_rewards));
    water = [water(num_samples+1:end);20*trial_mat(11,:)'];
    
    water_ext = get(handles.water_ext_plot,'Ydata')';
    trans = diff([round((water_ext(end))/21);trial_mat(11,:)']);
    trans = sum(trans==1);
    water_ext = [water_ext(num_samples+1:end);21*trial_mat(15,:)'];

    
    licks = get(handles.lick_plot,'Ydata')';
    trans = diff([round((licks(end))/35);trial_mat(10,:)']);
    trans = sum(trans==1);
    num_licks = str2num(get(handles.text_num_licks,'String')) + trans;
    set(handles.text_num_licks,'String',num2str(num_licks));
    licks = [licks(num_samples+1:end);35*trial_mat(10,:)'];
    
    set(handles.text_num_trials,'String',num2str(trial_num));

    trial_period = get(handles.trial_period_plot,'Ydata')';
    trial_period = [trial_period(num_samples+1:end);50*trial_mat(9,:)'];
    
    % Update strings
    set(handles.speed_plot,'Ydata',speed);
    set(handles.speed_dot,'Ydata',speed(end));
    set(handles.cor_pos_plot,'Ydata',cor_pos);
    set(handles.water_plot,'Ydata',water);
    set(handles.water_ext_plot,'Ydata',water_ext);
    set(handles.cor_width_plot,'Ydata',cor_width);
    set(handles.laser_power_plot,'Ydata',laser_power);
    set(handles.lick_plot,'Ydata',licks);
    set(handles.trial_period_plot,'Ydata',trial_period);

    set(handles.text_cur_trial_num,'String',num2str(trial_mat(8,end)));
    set(handles.text_cur_cor_pos,'String',num2str(mean(trial_mat(3,:))));
    set(handles.text_cur_cor_width,'String',num2str(mean(trial_mat(4,:))));
    
    set(handles.text_cur_mf,'String',num2str(trial_mat(13,end)));
    set(handles.text_cur_ps_power,'String',num2str(trial_mat(5,end)));
    set(handles.text_cur_y_mirr_pos,'String',num2str(trial_mat(7,end)));
    set(handles.text_cur_x_mirr_pos,'String',num2str(trial_mat(6,end)));
    
    
    d_ball_pos = trial_mat(1:2,:)';
    x_pos = get(handles.pos_plot,'Xdata')';
    y_pos = get(handles.pos_plot,'Ydata')';
    xy_vel_cum = repmat([x_pos(end) y_pos(end)],length(d_ball_pos(:,1)),1) + cumsum(d_ball_pos(:,1:2)/100);
    xy_vel_cum_ds = xy_vel_cum(1:10:end,:);
    x_pos = [x_pos(length(xy_vel_cum_ds(:,1))+1:end);xy_vel_cum_ds(:,1)];
    y_pos = [y_pos(length(xy_vel_cum_ds(:,2))+1:end);xy_vel_cum_ds(:,2)];
    
    corridor_width = 1;
    % wall pos hist
    edges = [0:.01:corridor_width]';
    cur_totavg = get(handles.wall_pos_hist,'YData');
    cur_totavg = cur_totavg';
    cur_count = get(handles.wall_pos_hist,'UserData');
    cur_totsum = cur_totavg; %.*cur_count;
    ind_ss = speed_vect > 5 & trial_mat(9,:) == 0;
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
    set(handles.pos_plot,'Xdata',x_pos);
    set(handles.pos_plot,'Ydata',y_pos);
    set(handles.axes_position,'Xlim',[3*round(x_pos(end)/3)-3 3*round(x_pos(end)/3)+3])
    set(handles.axes_position,'Ylim',[.5*round(y_pos(end)/.5)-.5 .5*round(y_pos(end)/.5)+.5])
end







