function hist_speed(axes_handle,session,setup,frac_range,keep_trial_types,keep_inds,col_mat)

edges = [0:1:50];

if setup == 1
    plot_handle = zeros(size(col_mat,1),1);
    for ij = 1:size(col_mat,1)
        plot_handle(ij) = plot(axes_handle,edges,zeros(1,length(edges)),'LineWidth',2,'Color',col_mat(ij,:));
        set(plot_handle(ij),'userdata',0);
    end
    set(axes_handle,'xlim',[0 50]);
else
    plot_handle = get(axes_handle,'Children');
    plot_handle = flipdim(plot_handle,1);
end


hist_mat = zeros(size(col_mat,1),length(edges));
hist_nums = zeros(size(col_mat,1),1);

for ij = 1:size(col_mat,1)
    hist_mat(ij,:) =  get(plot_handle(ij),'ydata');
    hist_nums(ij,:) =  get(plot_handle(ij),'userdata');
end


for ij = keep_inds'
    speed = session.data{ij}.processed_matrix(5,:);
    frac = session.data{ij}.processed_matrix(4,:);
    keep_range = frac >= frac_range(1) & frac <= frac_range(2);
    if any(keep_range) == 1
        hist_vals = hist(speed(keep_range),edges);
        hist_vals = hist_vals/sum(hist_vals);
        hist_mat(session.trial_info.inds(ij),:) = (hist_vals + hist_mat(session.trial_info.inds(ij),:)*hist_nums(session.trial_info.inds(ij)))/(hist_nums(session.trial_info.inds(ij))+1);
        hist_nums(session.trial_info.inds(ij)) = hist_nums(session.trial_info.inds(ij))+1;
    end
end

for ij = 1:length(keep_trial_types)
    set(plot_handle(keep_trial_types(ij)),'ydata',hist_mat(keep_trial_types(ij),:));
    set(plot_handle(keep_trial_types(ij)),'userdata',hist_nums(keep_trial_types(ij),:));
end

hist_mat_max = hist_mat(:,5:end);
hist_mat_max = max(hist_mat_max(:));
set(axes_handle,'ylim',[0 ceil((hist_mat_max+.01)*20)/20]);

end