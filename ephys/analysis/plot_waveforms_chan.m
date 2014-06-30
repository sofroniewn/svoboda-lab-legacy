function plot_waveforms_chan(fig_id,clust_id,sorted_spikes,trial_range,type)

% screen_size = get(0,'ScreenSize');
% screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
% screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
% screen_position_across = [1, screen_size(4)*2/3, screen_size(3), screen_size(4)/3];

spike_wave_detect = sorted_spikes{clust_id}.spike_waves;
trials = sorted_spikes{clust_id}.trial_num;

spike_wave_detect(~ismember(trials,trial_range),:) = [];
trials(~ismember(trials,trial_range)) = [];



detected_ch = sorted_spikes{clust_id}.detected_chan;

%nspk = size(spike_wave_detect,1);
%nchan = 1;
%nwind = size(spike_wave_detect,2);
time_vect = ([1:53]-20)/20833.33/2*1000;

if strcmp(type,'avg')
    figure(fig_id)
    clf(fig_id)
    set(gcf,'Position',[1554         637         362         358])
    hold on
    avg_spk = mean(spike_wave_detect);
    std_spk = std(spike_wave_detect);
    plot(time_vect,spike_wave_detect','Color','b','LineWidth',0.5)
    plot(time_vect,avg_spk,'Color','r','LineWidth',2)
    plot(time_vect,avg_spk + std_spk,'Color','c','LineWidth',1)
    plot(time_vect,avg_spk - std_spk,'Color','c','LineWidth',1)
  
else
    figure(fig_id+1)
    clf(fig_id+1)
    set(gcf,'Position',[10   285   362   258])
    hold on
    plot(time_vect,spike_wave_detect','Color','b')
end
%plot(0,-.35*10^(-3),'.k','MarkerSize',30)
title(['Cluster Id ' num2str(clust_id)])
xlim([time_vect(1) 1.2*(time_vect(end))])
ylim([-550 200])
xlabel('Time (ms)')
ylabel('Amplitude (uV)')

%set(gca,'position',[ 0.05    0.1100    0.90    0.815])
%xlim([1-.5-(nchan+1)/2 nchan+.5-(nchan+1)/2])
%ylim([-.41 .21]*10^(-3))
