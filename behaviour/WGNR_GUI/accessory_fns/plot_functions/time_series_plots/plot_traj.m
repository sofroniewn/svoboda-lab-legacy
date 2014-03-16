function plot_traj(axes_handle,session,setup,keep_trial_types,keep_inds,col_mat)

if setup == 1
    for ij = 1:length(keep_trial_types)
        [x_axis traj] = default_traj(session.trial_config,keep_trial_types(ij));
        
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
                if water_range_type == 2
                    water_range = [min_water_range(ik) max_water_range(ik)];
                    plot(axes_handle,[water_pos(ik) water_pos(ik)],water_range,'LineWidth',4,'Color',[.5 .5 1])
                end
            end
        end
        
        plot(axes_handle,x_axis,traj,'LineWidth',8,'Color','k')
    end
    set(axes_handle,'xlim',[0 1])
    set(axes_handle,'ylim',[-20 20])
end

for ij = keep_inds'
    plot(axes_handle,session.data{ij}.processed_matrix(4,:),session.data{ij}.processed_matrix(3,:),'LineWidth',2,'Color',col_mat(session.trial_info.inds(ij),:));
end


end