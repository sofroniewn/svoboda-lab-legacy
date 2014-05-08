function [ch_MUA] = func_filter_raw_voltages(TimeStamps, VoltageTraceInV_allCh,filter_range,laser_power);

    disp(['--------------------------------------------']);
    disp(['filtering file']);
    
if ~isempty(laser_power)
artifact_time = zeros(size(laser_power));
for_conv = 50;
laser_onsets = single(diff(laser_power)>.1);
laser_onsets = conv(laser_onsets,ones(for_conv,1),'same');
laser_onsets = find(laser_onsets)+for_conv/2;
artifact_time(laser_onsets) = 1;
for_conv = 50;
laser_onsets = single(diff(laser_power)<-.1);
laser_onsets = conv(laser_onsets,ones(for_conv,1),'same');
laser_onsets = find(laser_onsets)+for_conv/2;
artifact_time(laser_onsets) = 1;
end
     % filter the data into spiking and field potential band [300 6000]
    ch_MUA = NaN(size(VoltageTraceInV_allCh));
    for i_ch = 1:size(VoltageTraceInV_allCh,2)
        ex_trace = VoltageTraceInV_allCh(:,i_ch);
       if ~isempty(laser_power)
            ex_trace = interp1(find(~artifact_time),ex_trace(~artifact_time),[1:length(ex_trace)]);
       end
        ch_tmp = timeseries(ex_trace,TimeStamps);  
        ch_tmp = idealfilter(ch_tmp,filter_range,'pass');
        ch_MUA(:,i_ch) = ch_tmp.data;
    end
    
       ch_MUA(1:199,:) = 0;
       ch_MUA(end-199:end,:) = 0;

    disp(['--------------------------------------------']);

end