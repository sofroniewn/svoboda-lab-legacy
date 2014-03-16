function plot_speed(axes_handle,session,setup,keep_trial_types,keep_inds,col_mat)

if setup == 1
    set(axes_handle,'xlim',[0 1])
    set(axes_handle,'ylim',[0 60])
end

for ij = keep_inds'
    speed = 500*sqrt(session.data{ij}.trial_matrix(1,:).^2 + session.data{ij}.trial_matrix(2,:).^2);
    frac = session.data{ij}.processed_matrix(4,:);
    plot(axes_handle,frac,speed,'LineWidth',2,'Color',col_mat(session.trial_info.inds(ij),:));
end


end