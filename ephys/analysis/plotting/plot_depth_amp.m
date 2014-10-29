function plot_depth_amp(fig_props,AMPLITUDES)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

electrode_vals = [1:1/10:32];

plot(AMPLITUDES, electrode_vals,'k','LineWidth',2);
%title(['Cluster Id ' num2str(clust_id)])
%xlabel('Trial Number')
ylabel('Channels')
xlim([0 max(AMPLITUDES/10)*10])
%xlim(AMPLITUDES.trial_range);

