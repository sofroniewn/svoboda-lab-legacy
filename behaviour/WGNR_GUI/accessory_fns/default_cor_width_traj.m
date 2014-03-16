function [x_axis traj_width] = default_cor_width_traj(trial_config,trial_ind)

% traj will be straight until there is a widening, not do open loop yet.
num_samples = 800;
x_axis = linspace(0,1,num_samples);
traj_width = zeros(1,num_samples);

% Deal with corridor width changes
pos = trial_config.processed_dat.vals.trial_cor_width_pos(trial_ind,:);
vals = trial_config.processed_dat.vals.trial_cor_widths_vals(trial_ind,:);
start_ind = 1;
start_width = vals(1);
for ij = 1:length(pos)-1
    stop_ind = floor(pos(ij+1)*num_samples);
    stop_width = vals(ij+1);
    traj_width(start_ind:stop_ind) = start_width + (stop_width - start_width)*[1:(stop_ind - start_ind)+1]/(stop_ind - start_ind);
    start_width = traj_width(stop_ind);
    start_ind = stop_ind+1;
end

end