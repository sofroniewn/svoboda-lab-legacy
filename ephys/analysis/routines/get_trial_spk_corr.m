function SPK_CORR = get_trial_spk_corr(clust_id1,clust_id2,spike_times_cluster,d,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);

constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);

u_ind = find(strcmp(d.u_labels,'trial_num'));
raw_trial_nums = d.u_ck(u_ind,:);

keep_trials = raw_trial_nums(keep_trials);
spike_times1 = spike_times_cluster{clust_id1}.spike_times(ismember(spike_times_cluster{clust_id1}.spike_trials,keep_trials)&spike_times_cluster{clust_id1}.spike_times_ephys>=time_range(1)&spike_times_cluster{clust_id1}.spike_times_ephys<=time_range(2));
spike_times2 = spike_times_cluster{clust_id2}.spike_times(ismember(spike_times_cluster{clust_id2}.spike_trials,keep_trials)&spike_times_cluster{clust_id2}.spike_times_ephys>=time_range(1)&spike_times_cluster{clust_id2}.spike_times_ephys<=time_range(2));

SPK_CORR = get_spike_corr(spike_times1,spike_times2);

