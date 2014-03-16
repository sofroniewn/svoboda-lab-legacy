function [x_axis traj_left traj_right] = default_cor_traj(trial_config,trial_ind)

[x_axis traj_width] = default_cor_width_traj(trial_config,trial_ind);
[x_axis traj_ol] = default_cor_ol_traj(trial_config,trial_ind);

traj_left = traj_width/2 + traj_ol - traj_ol(1);
traj_right = - traj_width/2 + traj_ol - traj_ol(1);

end