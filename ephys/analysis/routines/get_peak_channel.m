function [peak_channel interp_amp] = get_peak_channel(mean_spike_amp,ch_exclude)
% get depth of spike by upsampling amplitude across channels, and finding the max 

num_channels = length(mean_spike_amp);
over_samp_factor = 10;

% exclude channels listed as dead;
all_chan = [1:num_channels];
if ismember(ch_exclude,[1 num_channels])
	error('WGNR ERROR :: cannot exclude top or bottom channels for depth estimation')
end
all_chan(ch_exclude) = [];
mean_spike_amp(ch_exclude) = [];

% upsample and smooth by fitting spline
over_samp_chan = [1:1/over_samp_factor:num_channels];
interp_amp = spline(all_chan,mean_spike_amp,over_samp_chan);

% find maximum of smoothed amplitude
[pks loc] = max(interp_amp);
peak_channel = over_samp_chan(loc);

end
