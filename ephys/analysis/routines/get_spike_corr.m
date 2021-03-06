function SPK_CORR = get_spike_corr(spike_times1,spike_times2,same_flag)
% Computes cross correlation between two spike trains

bin_size = .001; % in seconds
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

spike_diffs_tmp = spike_diffs;
spike_diffs_tmp(spike_diffs_tmp>.1) = [];
spike_diffs_tmp(spike_diffs_tmp<-.1) = [];

SPK_CORR.num_spikes_range = length(spike_diffs_tmp);

SPK_CORR.edges = [-max_corr_time:bin_size:max_corr_time];
SPK_CORR.dist = histc(spike_diffs(:),SPK_CORR.edges);
SPK_CORR.dist = SPK_CORR.dist/sum(SPK_CORR.dist);
SPK_CORR.mean = mean(SPK_CORR.dist);

mid_edge = find(SPK_CORR.edges==0);
end_edge = mid_edge+20;

SPK_CORR.val = mean(SPK_CORR.dist(mid_edge:end_edge));
SPK_CORR.mod = (SPK_CORR.val - SPK_CORR.mean)/SPK_CORR.mean;

if same_flag
	SPK_CORR.mod = 0;
end

end


