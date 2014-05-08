function [ch_data] = func_parse_klusters(ch_data,i_trial,s,p,TimeStamps,total_inds)
%%
disp(['--------------------------------------------']);
disp(['parse for klusters file']);


% Determine stds and spike thresholds
% build data structure for matclust
if isempty(ch_data) == 1
    ch_data.spk = [];
    ch_data.res = [];
    ch_data.fet = [];
    ch_data.sync = [];
end

%%
n_spk = size(s.spikes_all,1);
if n_spk>1
    detection_ch = s.spikes_all(:,1);
    
    % convert waveform to linear in klusters format
    waveform_tmp = s.spike_wave;
    waveform_tmp = permute(waveform_tmp,[3 2 1]);
    waveform_tmp = waveform_tmp(:);
    % rescale voltages
    waveform_tmp = int16(waveform_tmp*p.gain/10*2^(16));


    spiketimes_inds = s.spikes_all(:,2);
    spiketimes_tmp = double(TimeStamps(spiketimes_inds));
    trials_tmp = double(zeros(n_spk,1)+i_trial);
    iCh_tmp = double(detection_ch);

    spike_amp = -s.spike_amp;
    spike_amp = s.spike_amp;
    spike_amp(spike_amp>.15*10^(-3)) = .15*10^(-3);
    spike_amp(spike_amp<-.6*10^(-3)) = -.6*10^(-3);
    spike_amp = -spike_amp;
    spike_amp = int16(spike_amp*p.gain/10*2^(16));

    spike_amp = [spike_amp spiketimes_inds];

    res_tmp = total_inds + spiketimes_inds;

   %Trial ID - trial time - detect channel - spike amp
    sync_tmp = [trials_tmp spiketimes_tmp iCh_tmp];

    ch_data.spk  = cat(1, ch_data.spk, waveform_tmp);
    ch_data.res   = cat(1, ch_data.res, res_tmp);  
    ch_data.fet  = cat(1, ch_data.fet, spike_amp);
    ch_data.sync  = cat(1, ch_data.sync, sync_tmp);
    
end

disp(['--------------------------------------------']);
