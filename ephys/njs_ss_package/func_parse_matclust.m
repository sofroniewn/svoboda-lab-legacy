function [ch_data] = func_parse_matclust(ch_data,i_trial,s,p,TimeStamps,total_time)
%%
disp(['--------------------------------------------']);
disp(['parse for matclust file']);

% Determine stds and spike thresholds
% build data structure for matclust
if isempty(ch_data) == 1
    ch_data.params = [];
    ch_data.paramnames = {};
    ch_data.customvar.waveform = [];
    ch_data.customvar.spiketimes = [];
    ch_data.customvar.trials = [];
    ch_data.customvar.iCh = [];
    % save labels in mat-clust format
    ch_data.paramnames = cat(1, ch_data.paramnames, 'time stamp');
    ch_data.paramnames = cat(1, ch_data.paramnames, 'detection Ch');    
end
%%
% establish variables
waveform_tmp = [];
spiketimes_tmp = [];
trials_tmp = [];
iCh_tmp = [];
params_tmp = [];

s.spikes_all = s.spikes_all(s.spike_inds_trim,:);
s.spike_amp = s.spike_amp(s.spike_inds_trim,:);
s.spike_width = s.spike_width(s.spike_inds_trim,:);
s.spike_wave = s.spike_wave(s.spike_inds_trim,:,:);

%%
n_spk = size(s.spikes_all,1);
if n_spk>1
    detection_ch = s.spikes_all(:,1);
    for i_sample = 1:size(s.spike_wave,2)
        i_tmp = sub2ind(size(s.spike_wave), 1:size(s.spike_wave,1), zeros(1,size(detection_ch,1))+i_sample, detection_ch');
        waveform_tmp(:,i_sample) = s.spike_wave(i_tmp);
    end
    spiketimes_tmp = double(TimeStamps(s.spikes_all(:,2)));
    trials_tmp = double(zeros(n_spk,1)+i_trial);
    iCh_tmp = double(detection_ch);
   
    spike_amp = s.spike_amp;
    spike_amp(spike_amp>.15*10^(-3)) = .15*10^(-3);
    spike_amp(spike_amp<-.6*10^(-3)) = -.6*10^(-3);
    spike_amp = -spike_amp;

    % save data for matclust
    params_tmp = cat(2, params_tmp, (total_time + spiketimes_tmp));
    params_tmp = cat(2, params_tmp, double(detection_ch));
    params_tmp = cat(2, params_tmp, spike_amp);
    %params_tmp = cat(2, params_tmp, s.spike_width);
    %params_tmp = cat(2, params_tmp, s.spike_PCA);
    
    ch_data.params               = cat(1, ch_data.params, params_tmp);
    ch_data.customvar.waveform   = cat(1, ch_data.customvar.waveform, waveform_tmp);  % renormalize spike here to orginial amplitude
    ch_data.customvar.spiketimes = cat(1, ch_data.customvar.spiketimes, spiketimes_tmp);
    ch_data.customvar.trials     = cat(1, ch_data.customvar.trials, trials_tmp);
    ch_data.customvar.iCh        = cat(1, ch_data.customvar.iCh, iCh_tmp);
    
end

disp(['--------------------------------------------']);
