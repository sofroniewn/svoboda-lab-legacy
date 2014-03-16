function plot_corridor_position(axes_handle,session,setup,keep_trial_types,keep_inds,col_mat)

if setup == 1
    min_range = 0;
    max_range = 0;
    for ij = 1:length(keep_trial_types)
        [x_axis traj_left traj_right] = default_cor_traj(session.trial_config,keep_trial_types(ij));
        [x_axis traj] = default_traj(session.trial_config,keep_trial_types(ij));
        gain_factor = -session.rig_config.wall_ball_gain*10;
        traj = traj*gain_factor;
        traj_left = traj_left + traj;
        traj_right = traj_right + traj;
        
        water_pos = session.trial_config.processed_dat.vals.trial_water_pos(keep_trial_types(ij),:);
        min_water_range = session.trial_config.processed_dat.vals.trial_water_range_min(keep_trial_types(ij),:);
        max_water_range = session.trial_config.processed_dat.vals.trial_water_range_max(keep_trial_types(ij),:);
        water_enabled = session.trial_config.processed_dat.vals.trial_water(keep_trial_types(ij),:);
        water_range_type = session.trial_config.processed_dat.vals.trial_water_range_type(keep_trial_types(ij),:);
        
        if water_enabled == 1
            for ik = 1:length(water_pos)
                ind = ceil(water_pos(ik)*800);
                ind(ind<=0) = 1;
                ind(ind>800) = 800;
                if water_range_type == 0
                    water_range = traj_right(ind)+[min_water_range(ik) max_water_range(ik)];
                    plot(axes_handle,[water_pos(ik) water_pos(ik)],water_range,'LineWidth',4,'Color',[.5 .5 1])
                elseif water_range_type == 1
                    water_range = traj_right(ind)+[min_water_range(ik) max_water_range(ik)]*(traj_right(ind) - traj_left(ind));
                    plot(axes_handle,[water_pos(ik) water_pos(ik)],water_range,'LineWidth',4,'Color',[.5 .5 1])
                else
                end
            end
        end
        
        plot(axes_handle,x_axis,traj_left,'LineWidth',4,'Color','k')
        plot(axes_handle,x_axis,traj_right,'LineWidth',4,'Color','k')
        min_range = min(min_range,min(traj_right));
        max_range = max(max_range,max(traj_left));
    end
    set(axes_handle,'xlim',[0 1])
    set(axes_handle,'ylim',round(5*[min_range max_range])/5+[-1 1])
end

for ij = keep_inds'
    cor_pos_adj = session.data{ij}.trial_matrix(3,:) - session.data{ij}.trial_matrix(4,:)/2;
    frac = session.data{ij}.processed_matrix(4,:);
    [x_axis traj] = default_traj(session.trial_config,session.trial_info.inds(ij));
    ind = ceil(frac*800);
    ind(ind<=0) = 1;
    ind(ind>800) = 800;
    gain_factor = -session.rig_config.wall_ball_gain*10;
    % start_val = session.trial_config.processed_dat.vals.trial_ol_vals(session.trial_info.inds(ij),1);
    % start_width = session.trial_config.processed_dat.vals.trial_cor_widths_vals(session.trial_info.inds(ij),1);
    [x_axis gain_traj] = default_gain_traj(session.trial_config,session.trial_info.inds(ij));
    traj = traj*gain_factor.*gain_traj;
    traj_time = traj(ind);
    [x_axis traj_ol] = default_cor_ol_traj(session.trial_config,session.trial_info.inds(ij));
    traj_ol_start = traj_ol(1);
    traj_ol = traj_ol(ind);
    cor_pos_adj = cor_pos_adj + traj_time + traj_ol - traj_ol_start;
    plot(axes_handle,frac,cor_pos_adj,'LineWidth',2,'Color',col_mat(session.trial_info.inds(ij),:));
end

end