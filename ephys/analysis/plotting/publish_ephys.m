global session
global sorted_spikes
global trial_range
global ephys_summary

if ~isempty(ephys_summary)
	all_clust_ids = ephys_summary.d(:,2);
else
	all_clust_ids = [3:numel(sorted_spikes)];
end
plot_on = 1;
d = [];

d = summarize_cluster(d,ephys_summary,all_clust_ids,sorted_spikes,session,exp_type,id_type,trial_range,plot_on);
assignin('base','d',d);

