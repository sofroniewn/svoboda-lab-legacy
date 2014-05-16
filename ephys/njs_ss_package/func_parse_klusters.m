function [ch_data] = func_parse_klusters(i_trial,s,p,TimeStamps,total_inds)
%%
disp(['--------------------------------------------']);
disp(['parse for klusters file']);

    
    % convert waveform to linear in klusters format and rescale voltages
    waveform_tmp = s.waveforms;
    waveform_tmp = permute(waveform_tmp,[3 2 1]);
    waveform_tmp = waveform_tmp(:);
    waveform_tmp = int16(waveform_tmp*p.gain/10*2^(16));

    % Extract amplitudes
    spike_amp = s.amplitudes;
    spike_amp(spike_amp>.15*10^(-3)) = .15*10^(-3);
    spike_amp(spike_amp<-.6*10^(-3)) = -.6*10^(-3);
    spike_amp = -spike_amp;
    spike_amp = round(spike_amp*p.gain/10*2^(16));


    trials_tmp = double(zeros(length(s.index),1)+i_trial);
    res_tmp = total_inds + s.index;

    %Trial ID - trial time - detect channel - spike amp
    sync_tmp = [trials_tmp s.index s.TimeStamp*10^6 s.ch_ids s.aux_chan(:,1:3)*1000 s.aux_chan(:,4:5)];

    ch_data.spk  = waveform_tmp;
    ch_data.res   = res_tmp;  
    ch_data.fet  =  [spike_amp res_tmp];
    ch_data.sync  = sync_tmp;

disp(['--------------------------------------------']);
