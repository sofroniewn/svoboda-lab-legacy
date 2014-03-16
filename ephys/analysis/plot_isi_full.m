function plot_isi_full(clust_id,sorted_spikes)

screen_size = get(0,'ScreenSize');
screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
screen_position_across = [1, screen_size(4)*2/3, screen_size(4)/3, screen_size(4)/3];

spike_times = sorted_spikes{clust_id}.spike_inds(:,3);

ISI = diff(spike_times);
ISI = ISI(find(ISI<.5));
ISI = [ISI;-ISI];
edges = [-.3:.0005:.3];
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