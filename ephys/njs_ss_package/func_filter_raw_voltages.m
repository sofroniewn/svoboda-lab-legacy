function [ch_MUA aux_chan] = func_filter_raw_voltages(TimeStamps, vlt_chan, aux_chan, ch_ids, filter_range);

    disp(['--------------------------------------------']);
    disp(['filtering file']);
    
     % filter the data into spiking and field potential band [300 6000]
    ch_MUA = NaN(size(vlt_chan));
    for i_ch = 1:size(vlt_chan,2)
        ex_trace = vlt_chan(:,i_ch);
       if ~isempty(ch_ids.artifact)
            %ex_trace = interp1(find(~aux_chan(:,ch_ids.blank)),ex_trace(~aux_chan(:,ch_ids.blank)),[1:length(ex_trace)]);
            %ex_trace = pchip(find(~aux_chan(:,ch_ids.blank)),ex_trace(~aux_chan(:,ch_ids.blank)),[1:length(ex_trace)]);
       end
        ch_tmp = timeseries(ex_trace,TimeStamps);  
        ch_tmp = idealfilter(ch_tmp,filter_range,'pass');
        ch_MUA(:,i_ch) = ch_tmp.data;
    end
    
    % Remove edge artifacts
    ch_MUA(1:199,:) = 0;
    ch_MUA(end-199:end,:) = 0;
    aux_chan(1:199,ch_ids.blank) = 1;
    aux_chan(end-199:end,ch_ids.blank) = 1;


    disp(['--------------------------------------------']);

end