function plot_spike_isi_groups(fig_id,clustnum,sorted_spikes,trial_range,groups,group_ids,col_mat,time_range,mean_ds,group_scale)

num_groups = length(group_ids);

spike_times = sorted_spikes{clustnum}.ephys_time;
trials = sorted_spikes{clustnum}.trial_num;

spike_times(~ismember(trials,trial_range)) = [];
trials(~ismember(trials,trial_range)) = [];

spike_times(spike_times>time_range(2) & spike_times<time_range(1)) = [];


max_time = max(spike_times);






tot_trials = 0;
max_psth = 0;
psth_all = [];
for i_group = 1:num_groups
	trials_ids = find(groups == group_ids(i_group));
	trials_ids(~ismember(trials_ids,trial_range)) = [];
	diff_spike_times_trial = [];	
    for i_trial = 1:length(trials_ids)
            spike_times_trial = spike_times(trials == trials_ids(i_trial))';
            diff_spike_times_trial = [diff_spike_times_trial;diff(spike_times_trial)'];
    end

ISI = diff_spike_times_trial;
ISI = ISI(find(ISI<.5));
ISI = [ISI;-ISI];
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

title(['Cluster Id ' num2str(clustnum) '  Group num ' num2str(i_group)])

end
