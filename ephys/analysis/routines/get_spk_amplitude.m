function AMPLITUDES = get_spk_amplitude(spike_amps,spike_trials,trial_times,trial_range)
% normalize amplitude values and create trial by trial firing rate histograms

trial_range = [min(trial_range) max(trial_range)];

% remove spikes not from trial range
spike_amps = spike_amps(ismember(spike_trials,trial_range(1):trial_range(2)));
spike_trials = spike_trials(ismember(spike_trials,trial_range(1):trial_range(2)));

[trial_num_spikes trial_vals] = hist(spike_trials,trial_range(1):trial_range(2));

AMPLITUDES.trial_range = trial_range;
AMPLITUDES.trial_firing_rate = trial_num_spikes./trial_times;

spike_amps = spike_amps-min(spike_amps);
AMPLITUDES.norm_vals = (spike_amps/max(spike_amps)+1.2)*max(AMPLITUDES.trial_firing_rate);
AMPLITUDES.trial_spks = spike_trials;

end
