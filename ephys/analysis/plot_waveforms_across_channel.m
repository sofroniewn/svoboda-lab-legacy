function plot_waveforms_across_channel(clust_id,trial_id,ch_id,s,d,not_clustered,show_artifact)

screen_size = get(0,'ScreenSize');
screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
screen_position_across = [1, screen_size(4)*2/3, screen_size(3), screen_size(4)/3];

[spike_clustered spike_not_clustered spike_artifact ch_id] = extract_sorted_spike_times(clust_id,trial_id,ch_id,s,d);

spike_wave_detect = s.spike_wave(spike_clustered,:,:);
spike_wave_detect_all = s.spike_wave(spike_not_clustered,:,:);
spike_wave_detect_artifact = s.spike_wave(spike_artifact,:,:);


nspk = size(spike_wave_detect,1);
nchan = size(spike_wave_detect,3);
nwind = size(spike_wave_detect,2);
figure(43)
clf(43)
set(gcf,'Position',screen_position_across)
hold on
chan_boundaries = repmat([1:nchan],2,1).*repmat(nwind,2,nchan);
plot(.5+(.5+chan_boundaries)/nwind,repmat([-.5;.5],1,nchan)*10^(-3),'k');
plot(.5+[1 nchan*nwind]/nwind,[0 0],'k');
spike_wave_PCA = reshape(spike_wave_detect,nspk,nchan*nwind);
plot(.5+[1:nwind*nchan]/nwind,spike_wave_PCA(1:end,:)','Color','b')

if not_clustered
	nspk_all = size(spike_wave_detect_all,1);
	spike_wave_PCA_all = reshape(spike_wave_detect_all,nspk_all,nchan*nwind);
	plot(.5+[1:nwind*nchan]/nwind,spike_wave_PCA_all(1:end,:)','Color','r')
end

if show_artifact
	nspk_all = size(spike_wave_detect_artifact,1);
	spike_wave_PCA_all = reshape(spike_wave_detect_artifact,nspk_all,nchan*nwind);
	plot(.5+[1:nwind*nchan]/nwind,spike_wave_PCA_all(1:end,:)','Color','g')
end

plot(ch_id,-.35*10^(-3),'.k','MarkerSize',30)
set(gca,'position',[ 0.05    0.1100    0.90    0.815])
xlim([1-.5 nchan+.5])
ylim([-.41 .21]*10^(-3))