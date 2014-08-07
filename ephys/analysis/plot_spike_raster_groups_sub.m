function [tuning_curve t psth_all] = plot_spike_raster_groups_sub(fig_id,clustnum,sorted_spikes,trial_range,groups,group_ids,col_mat,time_range,mean_ds)

num_groups = length(group_ids);

spike_times = sorted_spikes{clustnum}.ephys_time;
trials = sorted_spikes{clustnum}.trial_num;

spike_times(~ismember(trials,trial_range)) = [];
trials(~ismember(trials,trial_range)) = [];


max_time = max(spike_times);

figure(fig_id)
clf(fig_id)
set(gcf,'Position',[11    67   556   408])

tuning_curve.means = NaN(num_groups,1);
tuning_curve.std = NaN(num_groups,1);
tuning_curve.num_pts = zeros(num_groups,1);
tuning_curve.data = cell(num_groups,1);


h_ax_rast = axes('Position',[.13 .4 .775 .55]);
%set(h_ax_rast,'Position',[.13 .45 .775 .3]);
%cur_pos = get(h_ax_rast,'Position')

hold on
max_psth = 0;
prev_trials = ceil(max_psth*10)/10;
for i_group = 1:num_groups
	trials_ids = find(groups == group_ids(i_group));
	spike_times_psth = {};
	trials_group = trials(ismember(trials,trials_ids));
	trials_ids(~ismember(trials_ids,trial_range)) = [];
	tot_spikes = zeros(length(trials_ids),1);
	for i_trial = 1:length(trials_ids)
    	spike_times_psth{i_trial,1} = spike_times(trials == trials_ids(i_trial))';
		trials_group(trials_group == trials_ids(i_trial)) = i_trial;
	    tmp = spike_times(trials == trials_ids(i_trial))';
    	tmp = tmp(tmp>time_range(1) & tmp<time_range(2));
		tot_spikes(i_trial) = length(tmp)/(time_range(2) - time_range(1));
	end
	tuning_curve.data{i_group} = tot_spikes;
	tuning_curve.means(i_group) = mean(tuning_curve.data{i_group});
	tuning_curve.std(i_group) = std(tuning_curve.data{i_group});
	tuning_curve.num_pts(i_group) = length(tuning_curve.data{i_group});

	spike_times_group = spike_times(ismember(trials,trials_ids));
	if ~isempty(spike_times_group)
		plot(spike_times_group,prev_trials+(trials_group),'.','Color',col_mat(i_group,:))
		prev_trials = prev_trials + max(trials_group) + 1;
	end
end
xlim([0 4])
ylim([-5 prev_trials+5])
%set(gca,'xtick',[])
ylabel('Trial number')



h_ax_psth = axes('Position',[.13 .1 .775 .25]);
hold on
tot_trials = 0;
max_psth = 0;
psth_all = [];
for i_group = 1:num_groups
	trials_ids = find(groups == group_ids(i_group));
	trials_ids(~ismember(trials_ids,trial_range)) = [];
	spike_times_psth = {};
	for i_trial = 1:length(trials_ids)
    	spike_times_psth{i_trial,1} = spike_times(trials == trials_ids(i_trial))';
	end
	[psth t] = func_getPSTH(spike_times_psth,0,max_time);
	if ~isempty(psth)
		psth_all = [psth_all;psth];
	else
		psth_all = [psth_all;zeros(1,length(t))];
	end
	tot_trials = tot_trials + length(trials_ids);
end

	col_map_all = col_mat;
	psth_all = conv2(psth_all,ones(mean_ds,40)/mean_ds/40,'same');
	psth_all = psth_all(1:mean_ds:end,:);
	%col_map_all = conv2(col_map_all,ones(mean_ds,1)/mean_ds,'same');
	col_map_all = col_map_all(1:mean_ds:end,:);

for i_group = 1:size(psth_all,1)
	plot(t(10:end-10),psth_all(i_group,10:end-10),'LineWidth',2,'Color',col_map_all(i_group,:));
end
    
    max_psth = max(psth_all(:));
	

xlim([0 4])
xlabel('Time (s)')
ylabel('Firing rate (Hz)')

return




function [PSTH time] = func_getPSTH(SpikeTimes, PSTH_StartTime, PSTH_EndTime)

time = PSTH_StartTime:.001:PSTH_EndTime;


n_rep = size(SpikeTimes,1);
total_counts = 0;
for i_rep = 1:n_rep
    
    [counts] = hist(SpikeTimes{i_rep,1},PSTH_StartTime:0.001:PSTH_EndTime);
    total_counts = total_counts+counts/n_rep;
    
end

avg_window = ones(1,50)/0.05;
PSTH = conv(total_counts,avg_window,'same');

time = time(21:end-20);
PSTH = PSTH(21:end-20);

return


