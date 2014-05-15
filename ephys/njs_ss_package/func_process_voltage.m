function [p d] = func_process_voltage(f_name,ch_common_noise)

freqSampling = 19531.25;
gain = 200;
ch_ids.num_tot = 35;
ch_ids.num_spike = 32;
ch_ids.file_trigger = 3;
ch_ids.frame_trigger = 2;
ch_ids.artifact = 1;
ch_ids.bitcode = [];


%% PROCESS RAW VOLTAGE
[vlt_chan aux_chan TimeStamps] = func_read_raw_voltages(f_name,freqSampling,gain,ch_ids);

%% REORDER Voltage trace
probe_name = 'A32_edge';
[vlt_chan ch_reorder] = func_reorder_channels(vlt_chan,probe_name);

%% Find out behaviour frame numbers
[aux_chan ch_ids start_ind] = extract_behaviour_triggers(aux_chan,ch_ids);

%% FIND BLANK PERIODS
[aux_chan ch_ids] = detect_artifacts_ephys(aux_chan,ch_ids);


%% FILTER INTO SPIKING BAND
filter_range =[300 6000];
[ch_MUA aux_chan] = func_filter_raw_voltages(TimeStamps, vlt_chan, aux_chan, ch_ids, filter_range);

%% SUBTRACT COMMON NOISE
[ch_MUA commonNoise] = func_denoise(TimeStamps, ch_MUA, ch_common_noise);

%% GROUP DATA
p.freqSampling = freqSampling;
p.gain = gain;
p.ch_ids = ch_ids;
p.ch_noise = ch_common_noise;
p.filter_range = filter_range;
p.probe_name = probe_name;

d.TimeStamps = TimeStamps' - TimeStamps(start_ind);
d.vlt_chan = vlt_chan;
d.aux_chan = aux_chan;
d.ch_MUA = ch_MUA;
d.trial_start_ind = start_ind;

end