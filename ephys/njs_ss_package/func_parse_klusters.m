function [ch_data] = func_parse_klusters(i_dir,i_trial,s,p,TimeStamps,total_inds)
%%
disp(['--------------------------------------------']);
disp(['parse for klusters file']);

    clip_val = 1024;
    offset_val = 128;
    
    % convert waveform to linear in klusters format and rescale voltages
    waveform_tmp = s.waveforms;
    waveform_tmp = cat(1,repmat(0,[1 size(waveform_tmp,2),size(waveform_tmp,3)]),waveform_tmp);
    waveform_tmp = permute(waveform_tmp,[3 2 1]);
    waveform_tmp = waveform_tmp(:);
    waveform_tmp(isnan(waveform_tmp)) = .15*10^(-3);
    waveform_tmp = int16(waveform_tmp*p.gain/10*2^(16));

    % Extract amplitudes
    spike_amp = s.amplitudes;
    %spike_amp(isnan(spike_amp)) = 0;
    spike_amp(spike_amp>.15*10^(-3)) = .15*10^(-3);
    spike_amp(spike_amp<-.6*10^(-3)) = -.6*10^(-3);
    spike_amp = -spike_amp;
    spike_amp = spike_amp*p.gain/10*2^(16);
    %aa = find(isnan(spike_amp));
    %for ij = 1:length(aa)
    %    spike_amp(aa(ij)) = 255*rand - 128;
    %end
    spike_amp = spike_amp + offset_val;
    spike_amp(isnan(spike_amp)) = -10;
    spike_amp(spike_amp>clip_val) = clip_val;
    %spike_amp = int16(spike_amp);
    spike_amp = round(spike_amp);
    
    trials_tmp = double(zeros(length(s.index),1)+i_trial);
    dir_tmp = double(zeros(length(s.index),1)+i_dir);
    res_tmp = total_inds + s.index;
    
    %Trial ID - trial time - detect channel - spike amp
    sync_tmp = [trials_tmp s.index s.TimeStamp*10^6 s.ch_ids s.aux_chan(:,1:3)*1000 s.aux_chan(:,4:5) dir_tmp];
    spike_amp = [repmat(clip_val,1,size(spike_amp,2));spike_amp];
    res_tmp = [total_inds+1;res_tmp];
    sync_tmp = [sync_tmp(1,:);sync_tmp];
    sync_tmp(1,2) = 1;
    sync_tmp(1,3) = 0;
  
    
    ch_data.spk  = waveform_tmp;
    ch_data.res   = res_tmp;  
    ch_data.fet  =  [spike_amp res_tmp];
    ch_data.sync  = sync_tmp;

disp(['--------------------------------------------']);
