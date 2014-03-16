function [ch_MUA] = func_filter_raw_voltages(TimeStamps, VoltageTraceInV_allCh,filter_range);

    disp(['--------------------------------------------']);
    disp(['filtering file']);
    
     % filter the data into spiking and field potential band [300 6000]
    ch_MUA = NaN(size(VoltageTraceInV_allCh));
    for i_ch = 1:size(VoltageTraceInV_allCh,2)
        ch_tmp = timeseries(VoltageTraceInV_allCh(:,i_ch),TimeStamps);  
        ch_tmp = idealfilter(ch_tmp,filter_range,'pass');
        ch_MUA(:,i_ch) = ch_tmp.data;
    end
    
       ch_MUA(1:199,:) = 0;
       ch_MUA(end-199:end,:) = 0;

    disp(['--------------------------------------------']);

end