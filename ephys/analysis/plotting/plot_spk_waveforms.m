function plot_spk_waveforms(fig_props,WAVEFORMS)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

plot(WAVEFORMS.time_vect,WAVEFORMS.waves','Color','b','LineWidth',0.5)
plot(WAVEFORMS.time_vect,WAVEFORMS.avg,'Color','r','LineWidth',2)
plot(WAVEFORMS.time_vect,WAVEFORMS.avg + WAVEFORMS.std,'Color','c','LineWidth',1)
plot(WAVEFORMS.time_vect,WAVEFORMS.avg - WAVEFORMS.std,'Color','c','LineWidth',1)
    
text(.72,.28,sprintf('t1 %.0f us',1000*WAVEFORMS.tau_1),'units','normalized')
text(.72,.34,sprintf('t2 %.0f us',1000*WAVEFORMS.tau_2),'units','normalized')
text(.72,.4,sprintf('t3 %.0f us',1000*WAVEFORMS.tau_3),'units','normalized')
text(.72,.46,sprintf('Max %.0f uV',WAVEFORMS.amp),'units','normalized')
 
%title(['Cluster Id ' num2str(clust_id)])
xlim([WAVEFORMS.time_vect(1) WAVEFORMS.time_vect(end)])
ylim([-500 150])
set(gca,'ytick',[-400:100:100])
xlabel('Time (ms)')
ylabel('Amplitude (uV)')
