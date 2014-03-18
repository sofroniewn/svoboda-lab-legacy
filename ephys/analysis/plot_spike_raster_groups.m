function plot_spike_raster_groups(clustnum,sorted_spikes,trial_range,groups,group_ids,col_mat)

num_groups = length(group_ids);

spike_times = sorted_spikes{clustnum}.spike_inds(:,3);
trials = sorted_spikes{clustnum}.spike_inds(:,1);

spike_times(trials < trial_range(1)) = [];
trials(trials < trial_range(1)) = [];
spike_times(trials > trial_range(2)) = [];
trials(trials > trial_range(2)) = [];

figure(14)
clf(14)
hold on

tot_trials = 0;
max_psth = 0;
for i_group = 1:num_groups-1
	trials_ids = find(groups >= group_ids(i_group) & groups < group_ids(i_group+1));
	trials_ids(trials_ids < trial_range(1)) = [];
	trials_ids(trials_ids > trial_range(2)) = [];
	spike_times_psth = {};
	for i_trial = 1:length(trials_ids)
    	spike_times_psth{i_trial,1} = spike_times(trials == trials_ids(i_trial))';
	end
	[psth t] = func_getPSTH(spike_times_psth,0,5);
	plot(t(10:end-10),psth(10:end-10),'LineWidth',2,'Color',col_mat(i_group,:));
	max_psth = max(max_psth,max(psth(10:end-10)));
	tot_trials = tot_trials + length(trials_ids);
end

prev_trials = ceil(max_psth*10)/10;
for i_group = 1:num_groups-1
	trials_ids = find(groups >= group_ids(i_group) & groups < group_ids(i_group+1));
	spike_times_psth = {};
	trials_group = trials(ismember(trials,trials_ids));
	trials_ids(trials_ids < trial_range(1)) = [];
	trials_ids(trials_ids > trial_range(2)) = [];
	for i_trial = 1:length(trials_ids)
    	spike_times_psth{i_trial,1} = spike_times(trials == trials_ids(i_trial))';
		trials_group(trials_group == trials_ids(i_trial)) = i_trial;
	end
	spike_times_group = spike_times(ismember(trials,trials_ids));
	plot(spike_times_group,prev_trials+(trials_group)*100/tot_trials,'.','Color',col_mat(i_group,:))
	prev_trials = prev_trials + max(trials_group)*100/tot_trials + 1;
end
xlim([0 5])
ylim([0 100+10+round(10*max_psth)/10+10])

return




function [PSTH time] = func_getPSTH(SpikeTimes, PSTH_StartTime, PSTH_EndTime)

% 
% SpikeTimes -- {n_rep,1}
% 

if nargin == 1
    PSTH_StartTime = -.52;
    PSTH_EndTime = 5.020;
end

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


