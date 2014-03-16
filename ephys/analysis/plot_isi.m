function plot_isi(clust_id,trial_id,ch_id,s,d)

screen_size = get(0,'ScreenSize');
screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
screen_position_across = [1, screen_size(4)*2/3, screen_size(4)/3, screen_size(4)/3];

[spike_clustered spike_not_clustered spike_artifact ch_id] = extract_sorted_spike_times(clust_id,trial_id,ch_id,s,d);

spike_clustered = s.spikes_all(spike_clustered,2);
spike_not_clustered = s.spikes_all(spike_not_clustered,2);
spike_artifact = s.spikes_all(spike_artifact,2);

spike_times = d.TimeStamps(spike_clustered);

ISI = diff(spike_times);
ISI = ISI(find(ISI<.5));
ISI = [ISI;-ISI];
edges = [-.3:.0005:.3];
%dges = [[-.025:.0005:.025]];
N = histc(ISI,edges);

figure(21)
clf(21)
hold on
set(gcf,'Position',screen_position_across)
if (sum(N))
    phandle = bar(edges,N,'histc');
    set(phandle,'LineStyle','none');
    set(phandle,'FaceColor',[0 0 0]);
    xlabel('Time between events (seconds)','FontSize',12);
    ylabel('Number of events','FontSize',12);
end

axis([-.04 .04 0 max(N)]);
