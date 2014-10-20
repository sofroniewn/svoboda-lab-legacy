function SPK_CORR = get_spike_corr(spike_times1,spike_times2,same_flag)
% Computes cross correlation between two spike trains

bin_size = .002; % in seconds
max_corr_time = .3; % in seconds


% calculate total number of spikes
SPK_CORR.num_spikes1 = length(spike_times1);
SPK_CORR.num_spikes2 = length(spike_times2);

if ~same_flag
	spike_diffs = bsxfun(@minus,spike_times1,spike_times2');
else
	spike_diffs = diff(spike_times1);
	spike_diffs = [spike_diffs;-spike_diffs];
end

spike_diffs = spike_diffs(:);
spike_diffs(spike_diffs>1) = [];
spike_diffs(spike_diffs<-1) = [];


range_val = 100; %in ms
step_val = 2; %in ms

SPK_CORR.edges = [-max_corr_time:bin_size:max_corr_time];
SPK_CORR.dist = histc(spike_diffs(:),SPK_CORR.edges);
SPK_CORR.dist = SPK_CORR.dist/sum(SPK_CORR.dist);
SPK_CORR.mean = mean(SPK_CORR.dist);
end


