function plot_spike_pair_corr(fig_id,clustnum1,clustnum2,sorted_spikes,trial_range,col_mat)


spike_times1 = sorted_spikes{clustnum1}.ephys_time;
trials1 = sorted_spikes{clustnum1}.trial_num;

spike_times1(~ismember(trials1,trial_range)) = [];
trials1(~ismember(trials1,trial_range)) = [];

spike_times2 = sorted_spikes{clustnum2}.ephys_time;
trials2 = sorted_spikes{clustnum2}.trial_num;

spike_times2(~ismember(trials2,trial_range)) = [];
trials2(~ismember(trials2,trial_range)) = [];


max_time = max(spike_times1);

	trials_ids = trial_range;
	diff_spike_times_trial = [];	
    for i_trial = 1:length(trials_ids)
            spike_times_trial1 = spike_times1(trials1 == trials_ids(i_trial))';
            spike_times_trial2 = spike_times2(trials2 == trials_ids(i_trial))';
            cur_diff = bsxfun(@minus,spike_times_trial1,spike_times_trial2');
            cur_diff = cur_diff(:);
            %cur_diff(cur_diff == 0) = [];
            diff_spike_times_trial = [diff_spike_times_trial;cur_diff];
            %cur_diff = bsxfun(@minus,spike_times_trial2,spike_times_trial1');
            %cur_diff = cur_diff(:);
            %cur_diff(cur_diff == 0) = [];
            %diff_spike_times_trial = [diff_spike_times_trial;cur_diff];
    end

ISI = diff_spike_times_trial;
ISI = ISI(find(ISI<.5));
%ISI = [ISI;-ISI];
edges = [-.1:.001:.1];
N = histc(ISI,edges);


figure(fig_id+909)
clf(fig_id+909)
hold on
set(gcf,'Position',[11   634   358   360])
if (sum(N))
    phandle = bar(edges,N,'histc');
    set(phandle,'LineStyle','none');
    set(phandle,'FaceColor',[0 0 0]);
    xlabel('Time between events (seconds)','FontSize',12);
    ylabel('Number of events','FontSize',12);
    xlim([-.04 .04])
   ylim([0 max(N)]);
%    ylim([0 25]);


end

title(['Cluster Id ' num2str(clustnum1) ' and Cluster Id ' num2str(clustnum2)])

end
