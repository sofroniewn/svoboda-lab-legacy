function plot_CSD(fig_props,CSD,plot_type)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

switch plot_type
case 'CSD'
	imagesc(1000*[CSD.time_window(1) CSD.time_window(end)],1+[1 size(CSD.vals,1)],CSD.vals);
	set(gca, 'ydir', 'rev')
	text(.90,.95,'CSD','Units','Normalized','Color','k')
	ylim([2 size(CSD.vlt_cmap,1)+1])
case 'LFP'
	imagesc(1000*[CSD.time_window(1) CSD.time_window(end)],1+[1 size(CSD.vlt_cmap,1)],CSD.vlt_cmap);
	set(gca, 'ydir', 'rev')
	text(.90,.95,'LFP','Units','Normalized','Color','k')
	ylim([2 size(CSD.vlt_cmap,1)+1])
case 'traces'
	plot(1000*CSD.time_window,CSD.vlt_trace);
	ylim([1 size(CSD.vlt_cmap,1)+2])
	ytick_vals = [0:5:size(CSD.vlt_cmap,1)+2];
	set(gca,'ytick',ytick_vals - 2 - mod(size(CSD.vlt_cmap,1),5))
	set(gca,'yticklabel',{5+max(ytick_vals) - ytick_vals})
otherwise
	error('WGNR :: unrecognized plot type for CSD')
end

plot([0 0],[1 size(CSD.vlt_cmap,1)+2],'LineStyle','--','Color','k')

xlim(1000*CSD.time_range)
xlabel('Time (ms)')
ylabel('Electrode number')
set(gca, 'Layer', 'top')
set(gca, 'box', 'on')