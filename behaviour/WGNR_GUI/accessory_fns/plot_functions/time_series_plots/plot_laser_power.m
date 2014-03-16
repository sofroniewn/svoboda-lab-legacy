function plot_laser_power(axes_handle,session,setup,keep_trial_types,keep_inds,col_mat)

if setup == 1
    set(axes_handle,'xlim',[0 1])
    set(axes_handle,'ylim',[0 50])
end

for ij = keep_inds'
    plot(axes_handle,session.data{ij}.processed_matrix(4,:),session.data{ij}.trial_matrix(5,:),'LineWidth',2,'Color',col_mat(session.trial_info.inds(ij),:));
end

end