function ISI = get_isi(spike_times,refractory_period)
% Computes interspike intervals
% Determine percent of spikes violating refractory period

bin_size = .001; % in seconds
max_isi = .3; % in seconds

% if refractory_period not given use default
if isempty(refractory_period)
	refractory_period = 0.002; % in seconds
end
ISI.refractory_period = refractory_period;

% calculate total number of spikes
ISI.num_spikes = length(spike_times);

% compute ISI distribution
ISI_times = diff(spike_times);
ISI_times = [ISI_times;-ISI_times];
ISI.edges = [-max_isi:bin_size:max_isi]';
ISI.dist = histc(ISI_times,ISI.edges);

% find peak of ISI distribution
start_ind = (length(ISI.edges) + 1)/2;
smoothed_N = smooth(ISI.dist(start_ind:end),10,'sgolay',3);
[x ind] = max(smoothed_N);
ISI.peak = ISI.edges(start_ind-1 + ind);


% calculate percent ISI violations
ISI.violations = 100*sum(ISI_times>0 & ISI_times<ISI.refractory_period)/(ISI.num_spikes-1);
end


