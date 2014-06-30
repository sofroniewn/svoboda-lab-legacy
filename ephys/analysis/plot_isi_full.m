function plot_isi_full(fig_id,clust_id,sorted_spikes,trial_range)

% screen_size = get(0,'ScreenSize');
% screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
% screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
% screen_position_across = [1, screen_size(4)*2/3, screen_size(4)/3, screen_size(4)/3];

spike_times = sorted_spikes{clust_id}.ephys_time;
trials = sorted_spikes{clust_id}.trial_num;

spike_times(~ismember(trials,trial_range)) = [];
trials(~ismember(trials,trial_range)) = [];



ISI = diff(spike_times);
ISI = ISI(find(ISI<.5));
ISI = [ISI;-ISI];
edges = [-.3:.0005:.3];
N = histc(ISI,edges);

figure(fig_id)
clf(fig_id)
hold on
set(gcf,'Position',[11   634   358   360])
if (sum(N))
    phandle = bar(edges,N,'histc');
    set(phandle,'LineStyle','none');
    set(phandle,'FaceColor',[0 0 0]);
    xlabel('Time between events (seconds)','FontSize',12);
    ylabel('Number of events','FontSize',12);
end

title(['Cluster Id ' num2str(clust_id)])
text(-0.03,.95*max(N),['Ch ' num2str(sorted_spikes{clust_id}.detected_chan)],'FontSize',18)
axis([-.04 .04 0 max(N)]);