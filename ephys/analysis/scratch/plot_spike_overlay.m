function plot_spike_overlay(clust_id,trial_id,ch_id,s,d)

screen_size = get(0,'ScreenSize');
screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
screen_position_across = [1, screen_size(4)*2/3, screen_size(3), screen_size(4)/3];

[spike_clustered spike_not_clustered spike_artifact ch_id] = extract_sorted_spike_times(clust_id,trial_id,ch_id,s,d);

length(spike_clustered)
length(spike_not_clustered)
length(spike_artifact)

spike_clustered = s.spikes_all(spike_clustered,2);
spike_not_clustered = s.spikes_all(spike_not_clustered,2);
spike_artifact = s.spikes_all(spike_artifact,2);


figure(21)
clf(21)
hold on
set(gcf,'Position',screen_position_across)
plot(d.TimeStamps,d.ch_MUA(:,ch_id))

plot([0 d.TimeStamps(end)*1.1],[s.param.thresh_raw(ch_id) s.param.thresh_raw(ch_id)],'k')

if ~isempty(spike_not_clustered)
    plot(d.TimeStamps(spike_not_clustered),d.ch_MUA(spike_not_clustered,ch_id),'.r')
end

if ~isempty(spike_artifact)
    plot(d.TimeStamps(spike_artifact),d.ch_MUA(spike_artifact,ch_id),'.g')
end

if ~isempty(spike_clustered)
    plot(d.TimeStamps(spike_clustered),d.ch_MUA(spike_clustered,ch_id),'.k')
end

%detected_spikes = find(s.spike_inds_trim(:,1) == ch_id);
%if ~isempty(detected_spikes)
%    plot(d.TimeStamps(s.spike_inds_trim(detected_spikes,2)),s.param.thresh_raw(ch_id)*1.1,'.r')
%end

if ismember(ch_id,s.param.ch_spikes)
    col = 'k';
else
    col = 'r';
end

text(d.TimeStamps(end)*1.05,0,num2str(ch_id),'color',col)
xlim([0 d.TimeStamps(end)*1.1])
ylim([-.4 .2]*10^(-3))
set(gca,'position',[ 0.05    0.1100    0.90    0.815])
