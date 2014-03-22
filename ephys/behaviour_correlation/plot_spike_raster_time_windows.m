function tuning_curve = plot_spike_raster_time_windows(clustnum,sorted_spikes,extracted_times,group_ids,max_time,col_mat,plot_on)

groups = extracted_times(:,6);
num_groups = length(group_ids);

spike_times = sorted_spikes{clustnum}.spike_inds(:,3);
trials = sorted_spikes{clustnum}.spike_inds(:,1);

if plot_on
	figure(14)
	clf(14)
	hold on
end

tuning_curve.means = NaN(num_groups,1);
tuning_curve.stds = NaN(num_groups,1);
tuning_curve.num_pts = zeros(num_groups,1);
tuning_curve.data = cell(num_groups,1);

max_psth = 0;
for i_group = 1:num_groups
	trials_ids = find(groups == group_ids(i_group));
	if isempty(trials_ids)~=1
	spike_times_psth = {};
	tuning_curve.data{i_group} = zeros(length(trials_ids),1);
	for i_trial = 1:length(trials_ids)
		tmp = spike_times(trials == extracted_times(trials_ids(i_trial),1))';
		tmp = tmp(tmp>=extracted_times(trials_ids(i_trial),4)&tmp<=extracted_times(trials_ids(i_trial),5));
		tmp = tmp - extracted_times(trials_ids(i_trial),4);
    	spike_times_psth{i_trial,1} = tmp;
		tuning_curve.data{i_group}(i_trial) = length(tmp)/max_time;
	end
	tuning_curve.means(i_group) = mean(tuning_curve.data{i_group});
	tuning_curve.stds(i_group) = std(tuning_curve.data{i_group});
	tuning_curve.num_pts(i_group) = length(tuning_curve.data{i_group});
	[psth t] = func_getPSTH(spike_times_psth,0,max_time);
	if plot_on
		plot(t(2:end-2),psth(2:end-2),'LineWidth',2,'Color',col_mat(i_group,:));
	end
	max_psth = max(max_psth,max(psth(2:end-2)));
	end
end

prev_start = ceil(max_psth/10)*10;
if isempty(prev_start)
	prev_start = 0;
end

if plot_on
prev_trials = prev_start;
for i_group = 1:num_groups
	trials_ids = find(groups == group_ids(i_group));
	if isempty(trials_ids)~=1
	spike_times_psth = {};
	trials_group = [];
	spike_times_group = [];
	for i_trial = 1:length(trials_ids)
		tmp = spike_times(trials == extracted_times(trials_ids(i_trial),1))';
		tmp = tmp(tmp>=extracted_times(trials_ids(i_trial),4)&tmp<=extracted_times(trials_ids(i_trial),5));
		tmp = tmp - extracted_times(trials_ids(i_trial),4);
		spike_times_group = [spike_times_group;tmp'];
		trials_group = [trials_group;repmat(i_trial,length(tmp),1)];
 	end
	plot(spike_times_group,prev_trials+(trials_group)*100/size(extracted_times,1),'.','Color',col_mat(i_group,:))
	prev_trials = prev_trials + max(trials_group)*100/size(extracted_times,1) + 1;
	end
end
xlim([0 max_time])
ylim([0 prev_trials])
end

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


