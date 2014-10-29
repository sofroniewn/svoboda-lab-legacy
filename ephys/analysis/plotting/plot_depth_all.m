function plot_depth_all(d,spike_times_cluster)

ind_p = find(strcmp(d.p_labels,'chan_depth'));
[inds clust_ids] = sort(d.p_nj(:,ind_p));

figure
set(gcf,'Position',[7    18   499   788])
hold on
max1 = 0;
for ij = 1:numel(spike_times_cluster)
clust_id = clust_ids(ij);
layer_4_dist_vals = [1:1/10:32];
AMPLITUDES = spike_times_cluster{clust_id}.interp_amp;
plot(layer_4_dist_vals,max1+AMPLITUDES,'Color',[0 0 0],'LineWidth',2);

text(33,max1,sprintf('%d',clust_id))
max1 = max1 + max(AMPLITUDES/10)*5;
end
