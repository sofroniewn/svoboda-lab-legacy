function [x_axis traj] = default_gain_traj(trial_config,trial_ind)

% traj will be straight until there is a turn, then turn at that angle.
num_samples = 800;
x_axis = linspace(0,1,num_samples);
traj = zeros(1,num_samples);

change_pos = trial_config.processed_dat.vals.trial_gain_pos(trial_ind,:);
gain_vals = trial_config.processed_dat.vals.trial_gain_vals(trial_ind,:);
start_ind = 1;
for ij = 1:length(change_pos)-1
    stop_ind = floor(change_pos(ij+1)*num_samples);
    traj(start_ind:stop_ind) = gain_vals(ij);
    start_ind = stop_ind+1;
end


end