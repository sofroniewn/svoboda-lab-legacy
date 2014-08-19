global session
global sorted_spikes
global trial_range

all_clust_ids = [3:numel(sorted_spikes)];
plot_on = 1;

d = summarize_cluster(all_clust_ids,sorted_spikes,session,exp_type,id_type,trial_range,plot_on);
assignin('base','d',d);

