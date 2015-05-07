function h_traj = plot_mVR_maze_traj(axes_handle,session,keep_trials,rand_col)

keep_trials = find(keep_trials);
h_traj = zeros(length(keep_trials),1);
ind = 0;
if ~isempty(keep_trials)
    for ij = keep_trials'
        if rand_col
            col_mat = rand(1,3);
        else
            col_mat = [0 0 .8];
        end
        ind = ind + 1;
        h_traj(ind) = plot(axes_handle,session.data{ij}.trial_matrix(6,:),session.data{ij}.trial_matrix(5,:),'LineWidth',2,'Color',col_mat);
    end
end
