function plot_spike_pair_corr_groups(fig_id,clustnum1,clustnum2,sorted_spikes,trial_range,groups,group_ids,col_mat,time_range,mean_ds,group_scale)

num_groups = length(group_ids);

spike_times1 = sorted_spikes{clustnum1}.ephys_time;
trials1 = sorted_spikes{clustnum1}.trial_num;

spike_times1(~ismember(trials1,trial_range)) = [];
trials1(~ismember(trials1,trial_range)) = [];
spike_times1(spike_times1>time_range(2) & spike_times1<time_range(1)) = [];

spike_times2 = sorted_spikes{clustnum2}.ephys_time;
trials2 = sorted_spikes{clustnum2}.trial_num;

spike_times2(~ismember(trials2,trial_range)) = [];
trials2(~ismember(trials2,trial_range)) = [];
spike_times2(spike_times2>time_range(2) & spike_times2<time_range(1)) = [];


max_time = max(spike_times1);






tot_trials = 0;
max_psth = 0;
psth_all = [];
for i_group = 1:num_groups
	trials_ids = find(groups == group_ids(i_group));
	trials_ids(~ismember(trials_ids,trial_range)) = [];
	diff_spike_times_trial = [];	
    for i_trial = 1:length(trials_ids)
            spike_times_trial1 = spike_times1(trials1 == trials_ids(i_trial))';
            spike_times_trial2 = spike_times2(trials2 == trials_ids(i_trial))';
            cur_diff = bsxfun(@minus,spike_times_trial1,spike_times_trial2');
            cur_diff = cur_diff(:);
            diff_spike_times_trial = [diff_spike_times_trial;cur_diff];
    end

ISI = diff_spike_times_trial;
ISI = ISI(find(ISI<.5));
%ISI = [ISI;-ISI];
edges = [-.3:.001:.3];
N = histc(ISI,edges);

N = N*group_scale(i_group);

figure(fig_id+909+i_group)
clf(fig_id+909+i_group)
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

title(['Cluster Id ' num2str(clustnum1) '  Cluster Id ' num2str(clustnum2) '  Group num ' num2str(i_group)])

end
