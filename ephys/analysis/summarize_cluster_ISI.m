function spike_times_cluster = summarize_cluster_ISI(all_clust_ids,sorted_spikes,session,exp_type,trial_range_start,trial_range_end,layer_4,run_thresh,plot_on)


trial_range_full = [min(trial_range_start):min(max(trial_range_end),numel(session.data))];

ephys_sampling_rate = 20833.33;
num_chan = 32;


trial_inds = session.trial_info.inds;
id_type_base = 'base';
[group_ids groups] = define_group_ids(exp_type,id_type_base,trial_inds);

max_length_trial = 2001;


spike_times_cluster = cell(length(all_clust_ids),1);

for ij = 1:length(all_clust_ids)

        % get cluster id information
    clust_id = all_clust_ids(ij);

    trial_range = [trial_range_start(clust_id):min(trial_range_end(clust_id),numel(session.data))];

    spike_times = sorted_spikes{clust_id}.session_time/ephys_sampling_rate;
    mean_spike_amp = sorted_spikes{clust_id}.mean_spike_amp(1:num_chan);
    spike_wave_detect = sorted_spikes{clust_id}.spike_waves;
    spike_trials = sorted_spikes{clust_id}.trial_num;
    spike_amps = sorted_spikes{clust_id}.spike_amp;
    trial_times = session.trial_info.time(min(trial_range):max(trial_range))';
    spike_times_ephys = sorted_spikes{clust_id}.ephys_time;
    
    spike_times(~ismember(spike_trials,trial_range)) = [];
    spike_amps(~ismember(spike_trials,trial_range)) = [];
    spike_times_ephys(~ismember(spike_trials,trial_range)) = [];
    spike_wave_detect(~ismember(spike_trials,trial_range),:) = [];
    spike_trials(~ismember(spike_trials,trial_range)) = [];
    
    spike_times_cluster{ij}.spike_times = spike_times;
    spike_times_cluster{ij}.spike_times_ephys = spike_times_ephys;
    spike_times_cluster{ij}.spike_trials = spike_trials;

    [peak_channel interp_amp] = get_peak_channel(mean_spike_amp,[]);
    spike_times_cluster{ij}.mean_spike_amp = mean_spike_amp;
    spike_times_cluster{ij}.interp_amp = interp_amp;
    spike_times_cluster{ij}.peak_channel = peak_channel;

end