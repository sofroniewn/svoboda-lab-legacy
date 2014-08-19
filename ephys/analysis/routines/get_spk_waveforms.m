function WAVEFORMS = get_spk_waveforms(spike_wave_detect,sample_rate)
% Compute waveform mean, std, and tau parameters

num_samps = size(spike_wave_detect,2);
peak_ind = 20;
over_samp = 5;


WAVEFORMS.time_vect = ([1:num_samps]-peak_ind)/sample_rate/2*1000;
WAVEFORMS.waves = spike_wave_detect/4;
WAVEFORMS.avg = mean(WAVEFORMS.waves);
WAVEFORMS.std = std(WAVEFORMS.waves);

WAVEFORMS.num_spikes = size(WAVEFORMS.waves,1);

% upsample waveform
time_vect_interp = ([1:1/over_samp:num_samps]-peak_ind)/sample_rate/2*1000;
avg_spk_interp = spline(WAVEFORMS.time_vect,WAVEFORMS.avg,time_vect_interp);

% compute 3 tau parameters
[min_avg ind_min] = min(avg_spk_interp);
ind_first_half_min = find(avg_spk_interp<min_avg/2,1,'first');
ind_second_half_min = find(avg_spk_interp<min_avg/2,1,'last')+1;
% left half width
WAVEFORMS.tau_1 = time_vect_interp(ind_min) - time_vect_interp(ind_first_half_min);
% right half width
WAVEFORMS.tau_2 = time_vect_interp(ind_second_half_min) - time_vect_interp(ind_min);
[max_avg ind_first_max] = max(avg_spk_interp(1:ind_min));
[max_avg ind_second_max] = max(avg_spk_interp(ind_min:end));
ind_second_max = ind_second_max + ind_min-1;
% distance between maxima
WAVEFORMS.tau_3 = time_vect_interp(ind_second_max) - time_vect_interp(ind_first_max);
% distance between minima and 2nd maxima
WAVEFORMS.tau_4 = time_vect_interp(ind_second_max) - time_vect_interp(ind_min);
  
 % extract average amplitude
WAVEFORMS.amp = min(avg_spk_interp);
 
 end
