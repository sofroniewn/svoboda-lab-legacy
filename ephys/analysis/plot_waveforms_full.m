function plot_waveforms_full(clust_id,sorted_spikes,trial_range)

screen_size = get(0,'ScreenSize');
screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
screen_position_across = [1, screen_size(4)*2/3, screen_size(3), screen_size(4)/3];

spike_wave_detect = sorted_spikes{clust_id}.spike_waves;
trials = sorted_spikes{clust_id}.trial_num;

spike_wave_detect(trials < trial_range(1),:,:) = [];
trials(trials < trial_range(1)) = [];
spike_wave_detect(trials > trial_range(2),:,:) = [];
trials(trials > trial_range(2)) = [];


detected_ch = sorted_spikes{clust_id}.detected_chan;

nspk = size(spike_wave_detect,1);
nchan = size(spike_wave_detect,3);
nwind = size(spike_wave_detect,2);
figure(43)
clf(43)
set(gcf,'Position',screen_position_across)
hold on
chan_boundaries = repmat([1:nchan],2,1).*repmat(nwind,2,nchan);
plot(.5+(.5+chan_boundaries)/nwind-(nchan+1)/2,repmat([-.5;.5],1,nchan)*10^(-3),'k');
plot(.5+[1 nchan*nwind]/nwind-(nchan+1)/2,[0 0],'k');
spike_wave_PCA = reshape(spike_wave_detect,nspk,nchan*nwind);
plot(.5+[1:nwind*nchan]/nwind-(nchan+1)/2,spike_wave_PCA(1:end,:)','Color','b')

%plot(0,-.35*10^(-3),'.k','MarkerSize',30)
text(0,-.35*10^(-3),num2str(detected_ch))

set(gca,'position',[ 0.05    0.1100    0.90    0.815])
xlim([1-.5-(nchan+1)/2 nchan+.5-(nchan+1)/2])
ylim([-.41 .21]*10^(-3))
