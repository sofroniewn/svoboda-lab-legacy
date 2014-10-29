function spike_times_cluster = get_all_LFP_hist(spike_times_cluster,lfp_data,d,keep_name,exp_type,id_type,time_range,trial_range,run_thresh)

constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);

u_ind = find(strcmp(d.u_labels,'trial_num'));
raw_trial_nums = d.u_ck(u_ind,:);
keep_trials = raw_trial_nums(keep_trials);

for clust_id = 1:numel(spike_times_cluster)
	[clust_id numel(spike_times_cluster)]

    spike_trials = spike_times_cluster{clust_id}.spike_trials(ismember(spike_times_cluster{clust_id}.spike_trials,keep_trials)&spike_times_cluster{clust_id}.spike_times_ephys>=time_range(1)&spike_times_cluster{clust_id}.spike_times_ephys<=time_range(2));
    spike_times_ephys = spike_times_cluster{clust_id}.spike_times_ephys(ismember(spike_times_cluster{clust_id}.spike_trials,keep_trials)&spike_times_cluster{clust_id}.spike_times_ephys>=time_range(1)&spike_times_cluster{clust_id}.spike_times_ephys<=time_range(2));

	SPK_LFP = get_spike_LFP(spike_times_ephys,spike_trials,lfp_data);

	spike_times_cluster{clust_id}.spike_phase = SPK_LFP.spike_phase;

end
