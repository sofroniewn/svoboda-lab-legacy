function RASTER = get_spk_raster(spike_times,spike_trials,trial_range,groups,group_ids,time_range,mean_ds,temp_smooth)
% Computes spike raster and psth for each trial, grouped according to groups

spike_times(~ismember(spike_trials,trial_range)) = [];
spike_trials(~ismember(spike_trials,trial_range)) = [];

spike_trials(spike_times<time_range(1) | spike_times>time_range(2)) = [];
spike_times(spike_times<time_range(1) | spike_times>time_range(2)) = [];


num_groups = length(group_ids);
prev_max = 0;
RASTER.spikes = cell(num_groups,1);
RASTER.trials = cell(num_groups,1);
RASTER.psth = cell(num_groups,1);
RASTER.time_range = time_range;
for i_group = 1:num_groups
	trials_ids = find(groups == group_ids(i_group));
	RASTER.spikes{i_group} = spike_times(ismember(spike_trials,trials_ids));
	tmp = spike_trials(ismember(spike_trials,trials_ids));
	[C,ia,ic] = unique(tmp);
	
    RASTER.trials{i_group} = ic + prev_max;
    if ~isempty(ic)
    	prev_max = prev_max + max(ic) + 1;
    end

	% make psth
	spike_times_psth = {};
	for i_trial = 1:length(trials_ids)
    	spike_times_psth{i_trial,1} = spike_times(spike_trials == trials_ids(i_trial))';
	end
    [psth t] = func_getPSTH(spike_times_psth,time_range(1),time_range(2));

	RASTER.psth{i_group} = psth;
	RASTER.time = t;
end

psth_all = zeros(num_groups,length(RASTER.time));
for i_group = 1:num_groups
	psth_all(i_group,:) = RASTER.psth{i_group};
end
psth_all = conv2(psth_all,ones(mean_ds,temp_smooth)/mean_ds/temp_smooth,'same');
psth_all = psth_all(1:mean_ds:end,:);
RASTER.psth = psth_all;

RASTER.trial_range = [1 prev_max];

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

