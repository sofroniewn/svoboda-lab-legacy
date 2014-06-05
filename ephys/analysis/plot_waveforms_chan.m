function plot_waveforms_chan(clust_id,sorted_spikes,trial_range)

screen_size = get(0,'ScreenSize');
screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
screen_position_across = [1, screen_size(4)*2/3, screen_size(3), screen_size(4)/3];

spike_wave_detect = sorted_spikes{clust_id}.spike_waves;
trials = sorted_spikes{clust_id}.trial_num;

spike_wave_detect(~ismember(trials,trial_range),:) = [];
trials(~ismember(trials,trial_range)) = [];


detected_ch = sorted_spikes{clust_id}.detected_chan;

%nspk = size(spike_wave_detect,1);
%nchan = 1;
%nwind = size(spike_wave_detect,2);
figure(43)
clf(43)
%set(gcf,'Position',screen_position_across)
hold on
plot(spike_wave_detect','Color','b')

%plot(0,-.35*10^(-3),'.k','MarkerSize',30)
text(size(spike_wave_detect,2)+3,0,num2str(detected_ch))

%set(gca,'position',[ 0.05    0.1100    0.90    0.815])
%xlim([1-.5-(nchan+1)/2 nchan+.5-(nchan+1)/2])
%ylim([-.41 .21]*10^(-3))
