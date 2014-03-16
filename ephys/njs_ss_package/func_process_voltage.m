function [p d] = func_process_voltage(f_name,ch_common_noise,lite)

%% PROCESS RAW VOLTAGE
freqSampling = 19531.25;
gain = 200;
ch_num_tot = 35;
ch_num_spike = 32;
ch_trigger = 35;
ch_bitcode = [];
[VoltageTraceInV_allCh allOther_allCh Trigger_allCh Bitcode_allCh TimeStamps] = func_read_raw_voltages(f_name,freqSampling,gain,ch_num_tot,ch_num_spike,ch_trigger,ch_bitcode);

%% REORDER Voltage trace
probe_name = 'A32_edge';
[VoltageTraceInV_allCh ch_reorder] = func_reorder_channels(VoltageTraceInV_allCh,probe_name);

%% FILTER INTO SPIKING BAND
filter_range =[300 6000];
[ch_MUA_raw] = func_filter_raw_voltages(TimeStamps, VoltageTraceInV_allCh, filter_range);

%% SUBTRACT COMMON NOISE
[ch_MUA commonNoise] = func_denoise(TimeStamps, ch_MUA_raw, ch_common_noise);


%% GROUP DATA
p.freqSampling = freqSampling;
p.gain = gain;
p.ch_num_tot = ch_num_tot;
p.ch_num_spike = ch_num_spike;
p.ch_trigger = ch_trigger;
p.ch_bitcode = ch_bitcode;
p.ch_noise = ch_common_noise;
p.filter_range = filter_range;
p.probe_name = probe_name;

d.TimeStamps = TimeStamps';
d.VoltageTraceInV_allCh = VoltageTraceInV_allCh;
d.allOther_allCh = allOther_allCh;
d.Trigger_allCh = Trigger_allCh;
d.ch_MUA = ch_MUA;

end