function [VoltageTraceInV_allCh ch_order] = func_reorder_channels(VoltageTraceInV_allCh,probe_name);

    disp(['--------------------------------------------']);
    disp(['reorder channels file']); 
   
    % sort channels
    if strcmp(probe_name,'A32_edge')
        ch_order = data_channel_order_list;
    else
        error('Unrecognized probe')
    end
    VoltageTraceInV_allCh = VoltageTraceInV_allCh(:,ch_order);
   
    disp(['--------------------------------------------']);
end