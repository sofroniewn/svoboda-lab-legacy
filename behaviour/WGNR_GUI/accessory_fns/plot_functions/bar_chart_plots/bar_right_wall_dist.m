function bar_right_wall_dist(axes_handle,session,setup,frac_range,keep_trial_types,keep_inds,col_mat)

max_width = ceil(max(session.trial_config.processed_dat.vals.trial_cor_widths_vals(:)));    
num_trials = size(col_mat,1);
if setup == 1
    plot_handle = zeros(2*num_trials,1);
    for ij = 1:num_trials
        plot_handle(2*(ij-1)+1) = bar(axes_handle,ij,0);
        set(plot_handle(2*(ij-1)+1),'FaceColor',col_mat(ij,:));
        set(plot_handle(2*(ij-1)+1),'EdgeColor',col_mat(ij,:));
        set(plot_handle(2*(ij-1)+1),'BarWidth',.5);
        set(plot_handle(2*(ij-1)+1),'userdata',0);
        plot_handle(2*(ij-1)+2) = plot(axes_handle,[ij ij],[0 0],'LineWidth',2,'Color',[0 0 0]);
    end
    set(axes_handle,'xlim',[.5 num_trials+.5])
    set(axes_handle,'xtick',[1:num_trials])
    set(axes_handle,'ylim',[0 max_width])
else
    plot_handle = get(axes_handle,'Children');
    plot_handle = flipdim(plot_handle,1);
end


cur_avg = zeros(num_trials,1);
cur_std = zeros(num_trials,1);
cur_nums = zeros(num_trials,1);


for ij = 1:num_trials
    cur_avg(ij) =  get(plot_handle(2*(ij-1)+1),'ydata');
    tmp =  get(plot_handle(2*(ij-1)+2),'ydata');
    cur_std(ij) = tmp(2) - cur_avg(ij);
    cur_nums(ij) =  get(plot_handle(2*(ij-1)+1),'userdata');
end
cur_var = (cur_std.^2).*(cur_nums);

for ij = keep_inds'
    vals = session.data{ij}.trial_matrix(3,:);
    frac = session.data{ij}.processed_matrix(4,:);
    speed = session.data{ij}.processed_matrix(5,:);
    keep_range = frac >= frac_range(1) & frac <= frac_range(2) & speed > 5;
    if any(keep_range) == 1
        mean_vals = mean(vals(keep_range));
        old_avg = cur_avg(session.trial_info.inds(ij));
        cur_avg(session.trial_info.inds(ij)) = cur_avg(session.trial_info.inds(ij)) + (mean_vals - cur_avg(session.trial_info.inds(ij)))/(cur_nums(session.trial_info.inds(ij))+1);
        cur_nums(session.trial_info.inds(ij)) = cur_nums(session.trial_info.inds(ij))+1;
        cur_var(session.trial_info.inds(ij)) = cur_var(session.trial_info.inds(ij)) + (mean_vals - old_avg)*(mean_vals - cur_avg(session.trial_info.inds(ij)));
    end
end
cur_std = (cur_var./cur_nums).^(0.5);

for ij = 1:num_trials
    set(plot_handle(2*(ij-1)+1),'ydata',cur_avg(ij))
    set(plot_handle(2*(ij-1)+1),'userdata',cur_nums(ij))
    set(plot_handle(2*(ij-1)+2),'ydata',cur_avg(ij) + [-cur_std(ij) cur_std(ij)])
end

end