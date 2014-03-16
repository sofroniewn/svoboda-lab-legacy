function [x_axis traj_ol] = default_cor_ol_traj(trial_config,trial_ind)

% traj will be straight until there is a widening, not do open loop yet.
num_samples = 800;
x_axis = linspace(0,1,num_samples);
traj_ol = zeros(1,num_samples);

% Deal with corridor width changes
pos = trial_config.processed_dat.vals.trial_ol_pos(trial_ind,:);
vals = trial_config.processed_dat.vals.trial_ol_vals(trial_ind,:);
start_ind = 1;
start_ol = vals(1);
for ij = 1:length(pos)-1
    stop_ind = floor(pos(ij+1)*num_samples);
    stop_ol = vals(ij+1);
    traj_ol(start_ind:stop_ind) = start_ol + (stop_ol - start_ol)*[1:(stop_ind - start_ind)+1]/(stop_ind - start_ind);
    start_ol = traj_ol(stop_ind);
    start_ind = stop_ind+1;
end

end