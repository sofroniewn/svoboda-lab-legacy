function [spike_clustered spike_not_clustered spike_artifact ch_id] = extract_sorted_spike_times_klusters(cluster_ids,sync_info,clust_id,trial_id,ch_id,s,d)

% look at current trial
keep_inds = find(ismember(sync_info(:,1),trial_id) & cluster_ids = cluster_id);

% extract spike times
spike_times = sync_info(keep_inds,3);
spike_inds = zeros(size(spike_times));
ind_ts = d.TimeStamps(s.spikes_all(:,2));
for ij = 1:length(spike_inds)
    [a ind] = min(abs(ind_ts - spike_times(ij)));
    spike_inds(ij) = ind;
end
spike_inds = s.spikes_all(spike_inds,2);


tmp = find(s.spikes_all(:,1) == ch_id);
spike_inds_chan_all = s.spikes_all(tmp,2);

spike_clustered = [];
spike_not_clustered = [];
for ij = 1:length(spike_inds_chan_all)
	if min(abs(spike_inds_chan_all(ij) - spike_inds)) <= s.param.retriggerDelay
		spike_clustered = [spike_clustered;tmp(ij)];
	else
		spike_not_clustered = [spike_not_clustered;tmp(ij)];	
	end
end

spike_artifact_ind = s.spikes_all(spike_not_clustered,5) == 0;

spike_artifact = spike_not_clustered(spike_artifact_ind);
spike_not_clustered = spike_not_clustered(~spike_artifact_ind);
