function plot_isi(fig_props,ISI)

% create figure if properties specified
if ~isempty(fig_props)
	figure(fig_props.id)
	clf(fig_props.id)
	set(gcf,'Position',fig_props.position)
end
cla
hold on
phandle = bar(1000*ISI.edges,ISI.dist,'histc');
set(phandle,'LineStyle','none');
set(phandle,'FaceColor',[0 0 0]);
xlabel('Time between events (milliseconds)');
ylabel('Number of events');
xlim([-40 40])
ylim([0 max(ISI.dist)]);

%title(['Cluster Id ' num2str(clust_id)])
text(.725,.89,sprintf('%.0f ms',1000*ISI.peak),'Color','r','units','normalized')
text(.725,.96,sprintf('%.2f%%',ISI.violations),'Color','r','units','normalized')


