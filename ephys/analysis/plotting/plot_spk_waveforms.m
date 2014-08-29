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
plot(WAVEFORMS.time_vect,WAVEFORMS.avg,'Color','k','LineWidth',3)
plot(WAVEFORMS.time_vect,WAVEFORMS.avg + WAVEFORMS.std,'Color','k','LineWidth',1)
plot(WAVEFORMS.time_vect,WAVEFORMS.avg - WAVEFORMS.std,'Color','k','LineWidth',1)
    
%text(.6,.08,sprintf('t1 %.0f us',1000*WAVEFORMS.tau_1),'units','normalized')
%text(.6,.14,sprintf('t2 %.0f us',1000*WAVEFORMS.tau_2),'units','normalized')
%text(.6,.2,sprintf('t3 %.0f us',1000*WAVEFORMS.tau_3),'units','normalized')
text(.55,.2,sprintf('Amp %.0f uV',-WAVEFORMS.amp),'units','normalized','Color','r')
text(.55,.13,sprintf('tau %.0f us',1000*WAVEFORMS.tau_4),'units','normalized','Color','r')
text(.55,.06,sprintf('SNR %.1f',WAVEFORMS.SNR),'units','normalized','Color','r')

text(.55,.96,[num2str(WAVEFORMS.num_spikes) ' spks'],'Color','r','units','normalized')

xlim([WAVEFORMS.time_vect(1) WAVEFORMS.time_vect(end)])
ylim([-300 125])
set(gca,'ytick',[-300:100:100])
xlabel('Time (ms)')
ylabel('Amplitude (uV)')
