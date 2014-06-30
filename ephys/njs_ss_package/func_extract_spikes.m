function [s] = func_extract_spikes(p,d,ch_spikes)
%%
param_extract.ch_spikes = ch_spikes;
param_extract.ch_num_spike = p.ch_ids.num_spike;
param_extract.ch_ids = p.ch_ids;

% SETTING THRESHOLD
param_extract.std_level = 3;
param_extract.retriggerDelay = 4;
param_extract.shadow_period = 9;
param_extract.shadow_period_across_channels = 9;
param_extract.channel_neighbourhood_large = 8;
param_extract.channel_neighbourhood_small = 8;

param_extract.w_pre = 13;
param_extract.w_post = 16;
param_extract.int_factor = 2;
param_extract.jitter = 3;
param_extract.a_pre = 10;
param_extract.a_post = 13;

param_extract.artifact_thresh = .3*10^(-3);

%% Determine spike threshold and channel noise
std_level = 3;
[stds thresh_raw thresh] = func_determine_spike_thresholds(d.ch_MUA, param_extract);
param_extract.stds = stds;
param_extract.thresh_raw = thresh_raw;
param_extract.thresh = thresh;

%% Detect threshold crossings
[spike_output] = func_detect_threshold_crossings_adaptive(d.ch_MUA, param_extract);

%% Extract waveforms
if isempty(spike_output) ~= 1
	[spike_amp spike_width spike_wave spike_PCA] = func_extract_waveforms_blank(d.ch_MUA, spike_output, param_extract);
	%% Detect artifacts
	%spikes_all = func_remove_artifacts(spikes_all,spike_wave,param_extract.artifact_thresh);
	%spikes_trim = spikes_trim(ismember(spikes_trim,find(spikes_all(:,5))));
else
    spike_amp = [];
    spike_width = [];
    spike_wave = [];
    spike_PCA = [];
end


%% Group data
s.param = param_extract;

s.index = spike_output(:,1);
s.ch_ids = spike_output(:,2:4);

s.TimeStamp = d.TimeStamps(s.index,:);
s.aux_chan = d.aux_chan(s.index,:);

s.amplitudes = spike_amp;
s.waveforms = spike_wave;



