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
	plot([0 0],[-2 size(CSD.vlt_cmap,1)+5],'LineStyle','--','Color','k')
	set(gca, 'ydir', 'rev')
	%text(.90,.95,'CSD','Units','Normalized','Color','k')
	ylim([2 size(CSD.vlt_cmap,1)+1])
	xlim(1000*CSD.time_range)
	xlabel('Time (ms)')
	ylabel('Electrode number')
case 'LFP'
	imagesc(1000*[CSD.time_window(1) CSD.time_window(end)],1+[1 size(CSD.vlt_cmap,1)],CSD.vlt_cmap);
	plot([0 0],[-2 size(CSD.vlt_cmap,1)+5],'LineStyle','--','Color','k')
	set(gca, 'ydir', 'rev')
	text(.90,.95,'LFP','Units','Normalized','Color','k')
	ylim([2 size(CSD.vlt_cmap,1)+1])
	xlim(1000*CSD.time_range)
	xlabel('Time (ms)')
	ylabel('Electrode number')
case 'traces'
	plot(1000*CSD.time_window,CSD.vlt_trace);
	plot([0 0],[-2 size(CSD.vlt_cmap,1)+5],'LineStyle','--','Color','k')
	set(gca, 'ydir', 'rev')
	ylim([0 size(CSD.vlt_cmap,1)+4])
	xlim(1000*CSD.time_range)
	xlabel('Time (ms)')
	ylabel('Electrode number')
case 'profile'
	plot(CSD.profile_chan_interp,CSD.profile_interp)
	xlim([0 size(CSD.vlt_cmap,1)])
	xlabel('Electrode number')
otherwise
	error('WGNR :: unrecognized plot type for CSD')
end


set(gca, 'Layer', 'top')
set(gca, 'box', 'on')