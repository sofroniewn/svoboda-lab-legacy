function [stds thresh_raw thresh] = func_determine_spike_thresholds(ch_MUA, param_extract)
%%
disp(['--------------------------------------------']);
disp(['determine spike thresholds file']);

% Determine stds and spike thresholds
stds = std(ch_MUA);
thresh =  stds * (-param_extract.std_level);
thresh_raw = thresh;

all_ch = [1:param_extract.ch_num_spike];
noise_ch = all_ch;
noise_ch(param_extract.ch_spikes) = [];
thresh(noise_ch) = -Inf;
 
disp(['--------------------------------------------']);
