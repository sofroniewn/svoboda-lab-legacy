function plot_behaviour_vect(fig_props,BEHAVIOUR_VECT)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

trials = BEHAVIOUR_VECT.trial_range(1):BEHAVIOUR_VECT.trial_range(2);
plot(trials, BEHAVIOUR_VECT.vals,'r','linewidth',2);
%title(['Cluster Id ' num2str(clust_id)])
xlabel('Trial Number')
ylabel(BEHAVIOUR_VECT.ylabel)
xlim(BEHAVIOUR_VECT.trial_range);

