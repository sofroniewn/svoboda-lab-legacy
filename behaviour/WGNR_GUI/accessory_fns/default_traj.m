function [x_axis traj] = default_traj(trial_config,trial_ind)

% traj will be straight until there is a turn, then turn at that angle.
num_samples = 800;
x_axis = linspace(0,1,num_samples);
traj = zeros(1,num_samples);

turn_pos = trial_config.processed_dat.vals.trial_turn_pos(trial_ind,:);
turn_vals = trial_config.processed_dat.vals.trial_turn_vals(trial_ind,:);
trial_dur = trial_config.processed_dat.vals.trial_dur(trial_ind);
start_val = 0;
start_ind = 1;
for ij = 1:length(turn_pos)-1
    stop_ind = floor(turn_pos(ij+1)*num_samples);
    turn_angle = turn_vals(ij);
    traj(start_ind:stop_ind) = start_val - sind(turn_angle)*[1:(stop_ind - start_ind)+1]/num_samples*trial_dur;
    start_val = traj(stop_ind);
    start_ind = stop_ind+1;
end


end