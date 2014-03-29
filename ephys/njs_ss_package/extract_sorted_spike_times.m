function [spike_clustered spike_not_clustered spike_artifact ch_id] = extract_sorted_spike_times(clustattrib,clustdata,clust_id,trial_id,ch_id,s,d)

% look at current trial
keep_inds = find(ismember(clustdata.customvar.trials,trial_id));

% look at spike indices in current trial
keep_inds = ismember(clustattrib.clusters{clust_id}.index,keep_inds);

% pull out spike inds
keep_spikes = clustattrib.clusters{clust_id}.index(keep_inds);

% indicate detection channel
%detected_ch = mode(clustdata.customvar.iCh(keep_spikes));
detected_ch = mode(clustdata.customvar.iCh(clustattrib.clusters{clust_id}.index));
if isempty(ch_id) == 1
	ch_id = detected_ch;
end

% extract spike times
spike_times = clustdata.customvar.spiketimes(keep_spikes);
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
