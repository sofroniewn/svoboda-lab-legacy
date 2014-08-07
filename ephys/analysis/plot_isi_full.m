function plot_isi_full(fig_id,clust_id,sorted_spikes,trial_range,ch_exclude)

% screen_size = get(0,'ScreenSize');
% screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
% screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
% screen_position_across = [1, screen_size(4)*2/3, screen_size(4)/3, screen_size(4)/3];

%spike_times = sorted_spikes{clust_id}.ephys_time;

spike_times = sorted_spikes{clust_id}.session_time/20833.33;
trials = sorted_spikes{clust_id}.trial_num;

spike_times(~ismember(trials,trial_range)) = [];
trials(~ismember(trials,trial_range)) = [];

num_spikes = length(spike_times);
%spike_times = spike_times + trials*15;

bin_size = .001; % in seconds

refractory_period_edge = .002;

ISI = diff(spike_times);


isi_violations = 100*sum(ISI<refractory_period_edge)/(num_spikes-1);


edges = [0:bin_size:.3];
smoothed_N = histc(ISI,edges);
%smoothed_N = smooth(smoothed_N,20);
%smoothed_N = conv(smoothed_N,ones(5,1)/5,'same');
smoothed_N = smooth(smoothed_N,10,'sgolay',3);
%smoothed_N = smooth(smoothed_N,'lowess',1/10);

[aa ind] = max(smoothed_N);
isi_peak = edges(ind);

ISI = [ISI;-ISI];
edges = [-.3:bin_size:.3];
N = histc(ISI,edges);

figure(fig_id)
clf(fig_id)
hold on
set(gcf,'Position',[11   712   305   282])
if (sum(N))
    phandle = bar(edges,N,'histc');
    
   % plot(edges(length(edges)/2+.5:end),smoothed_N,'r');
    set(phandle,'LineStyle','none');
    set(phandle,'FaceColor',[0 0 0]);
    xlabel('Time between events (seconds)','FontSize',12);
    ylabel('Number of events','FontSize',12);
end

if isfield(sorted_spikes{clust_id},'mean_spike_amp')
	raw_spike_amp = sorted_spikes{clust_id}.mean_spike_amp(1:32);
	raw_spike_amp(ch_exclude) = [];
	all_chan = [1:32];
	all_chan(ch_exclude) = [];

	over_samp = [1:.1:32];
	interp_amp = spline(all_chan,raw_spike_amp,over_samp);
	[pks loc] = max(interp_amp);
	exp_val = over_samp(loc);
	text(-0.031,.85*max(N),sprintf('Ch  %.1f',exp_val),'FontSize',18)
end

title(['Cluster Id ' num2str(clust_id)])
text(-0.031,.95*max(N),['Ch ' num2str(sorted_spikes{clust_id}.detected_chan)],'FontSize',18)
text(0.029,.75*max(N),sprintf('%.0f ms',1000*isi_peak),'FontSize',12,'Color','r')
text(0.029,.85*max(N),sprintf('%.2f%%',isi_violations),'FontSize',12,'Color','r')
text(0.029,.95*max(N),[num2str(num_spikes) ' spks'],'FontSize',12,'Color','r')
xlim([-.04 .04])
ylim([0 max(N)]);




