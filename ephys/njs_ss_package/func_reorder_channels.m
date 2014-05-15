function [vlt_chan ch_order] = func_reorder_channels(vlt_chan,probe_name);

    disp(['--------------------------------------------']);
    disp(['reorder channels file']); 
   
    % sort channels
    if strcmp(probe_name,'A32_edge')
        ch_order = data_channel_order_list;
    else
        error('Unrecognized probe')
    end
    vlt_chan = vlt_chan(:,ch_order);
   
    disp(['--------------------------------------------']);
end