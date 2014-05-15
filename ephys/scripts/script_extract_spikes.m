%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXTRACT SPIKE WAVEFORMS AND REMOVE ARTIFCATS


ch_spikes = [1:2, 4:26, 30:31]; % Channels to be used for spike detection
[s] = func_extract_spikes(p,d,ch_spikes);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INDIVIDUAL CHANNEL
ch_id = 17;
figure(21)
clf(21)
set(gcf,'Position',screen_position_across)
hold on
plot(d.TimeStamps,d.ch_MUA(:,ch_id))

plot([0 d.TimeStamps(end)*1.1],[s.param.thresh_raw(ch_id) s.param.thresh_raw(ch_id)],'k')

detected_spikes = find(s.ch_ids(:,3) == ch_id);
if ~isempty(detected_spikes)
    plot(s.TimeStamp(detected_spikes),s.param.thresh_raw(ch_id),'.m')
	plot(s.TimeStamp(detected_spikes),s.amplitudes(detected_spikes,ch_id),'.g')
end


if ismember(ch_id,s.param.ch_spikes)
    col = 'k';
else
    col = 'r';
end

text(d.TimeStamps(end)*1.05,0,num2str(ch_id),'color',col)
xlim([0 d.TimeStamps(end)*1.1])
ylim([-.3 .3]*10^(-3))
set(gca,'position',[ 0.1300    0.1100    0.7750    0.8150])



%% ACROSS CHANNELS SPIKES
figure(35)
clf(35)
set(gcf,'Position',screen_position_left)
hold on
for ij = 1:s.param.ch_num_spike
	plot(d.TimeStamps,d.ch_MUA(:,ij)+ij/4000)
	plot([0 d.TimeStamps(end)],[s.param.thresh_raw(ij) s.param.thresh_raw(ij)]+ij/4000,'k')
	detected_spikes = s.ch_ids(:,3) == ij;
	if sum(detected_spikes) > 0
    	plot(s.TimeStamp(detected_spikes),s.param.thresh_raw(ij) + ij/4000,'.r')
    	plot(s.TimeStamp(detected_spikes),s.amplitudes(detected_spikes,ij) + ij/4000,'.g')
	end

	if ismember(ij,s.param.ch_spikes)
	    col = 'k';
	else
	    col = 'r';
	end
	text(d.TimeStamps(end)*1.05,ij/4000,num2str(ij),'color',col)

end
   % plot(d.TimeStamps(s.spike_inds(:,2)),s.param.thresh(1)*1.1 + 1/4000,'.g')

plot(d.TimeStamps,.15*d.aux_chan(:,1)/2000+(ij+1)/4000,'k')
text(d.TimeStamps(end)*1.05,.05*(ij+1)/200,'Laser')
ylim([0 1.75]/200)
xlim([0 d.TimeStamps(end)*1.1])
set(gca,'position',[ 0.0500    0.150    0.90    0.80])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% PLOT WAVEFORMS OF SPIKE
nspk = size(s.waveforms,1);
nchan = size(s.waveforms,3);
nwind = size(s.waveforms,2);
figure(43)
clf(43)
spike_wave_PCA = reshape(s.waveforms,nspk,nchan*nwind);
plot(spike_wave_PCA(90:100,:)')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




