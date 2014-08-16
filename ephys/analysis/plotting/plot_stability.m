function plot_stability(fig_props,AMPLITUDES)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

trials = AMPLITUDES.trial_range(1):AMPLITUDES.trial_range(2);
bar(trials,AMPLITUDES.trial_firing_rate);
plot(AMPLITUDES.trial_spks, AMPLITUDES.norm_vals,'.k');
%title(['Cluster Id ' num2str(clust_id)])
xlabel('Trial Number')
ylabel('Firing rate (Hz)')
xlim(AMPLITUDES.trial_range);

