function RASTER = get_spk_raster(spike_times,spike_trials,trial_range,groups,group_ids,time_range,mean_ds,temp_smooth)
% Computes spike raster and psth for each trial, grouped according to groups

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
	trials_ids(~ismember(trials_ids,trial_range)) = [];
    RASTER.spikes{i_group} = spike_times(ismember(spike_trials,trials_ids));

	tmp = spike_trials(ismember(spike_trials,trials_ids));
    [C,ia,ic] = unique([trials_ids;tmp]);
    ic(1:length(trials_ids)) = [];
    
    RASTER.trials{i_group} = ic + prev_max;
    prev_max = prev_max + length(trials_ids) + 1;

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
    if ~isempty(RASTER.psth{i_group})
    	psth_all(i_group,:) = RASTER.psth{i_group};
    end
end
psth_all = conv2(psth_all,ones(1,temp_smooth)/1/temp_smooth,'same');
psth_all = downsample(psth_all,mean_ds);
%psth_all = psth_all(1:mean_ds:end,:);
RASTER.psth = psth_all;

RASTER.trial_range = [1 prev_max];
