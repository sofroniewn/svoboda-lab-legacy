function [VoltageTraceInV_allCh allOther_allCh Trigger_allCh Bitcode_allCh TimeStamps] = func_read_raw_voltages(f_name,freqSampling,gain,ch_num_tot,ch_num_spike,ch_trigger,ch_bitcode);

    disp(['--------------------------------------------']);
    disp(['reading file ',f_name]);
    
    fid = fopen(f_name,'r');
    
    % Read a full file
    matrixRaw=fread(fid,inf,'uint16');
    fclose(fid);
    
    % Convert to doubles and scale voltage    
    matrixVol = double(10*(matrixRaw-(sign(matrixRaw-2^15)+1)*2^15)/2^16);
    ch_all_raw = reshape(matrixVol,ch_num_tot,size(matrixVol,1)/ch_num_tot)';

    VoltageTraceInV_allCh = ch_all_raw(:,1:ch_num_spike)/gain;
    Trigger_allCh = ch_all_raw(:,ch_trigger);
    other_channels = ch_num_spike+1:ch_num_tot;
    other_channels(other_channels==ch_trigger) = [];
    allOther_allCh = ch_all_raw(:,other_channels);
    TimeStamps = (0 : size(VoltageTraceInV_allCh, 1)-1)/freqSampling;
    
    if isempty(ch_bitcode) ~= 0
        Bitcode_allCh = ch_all_raw(:,ch_bitcode);
    else
        Bitcode_allCh = [];
    end
    
    disp(['--------------------------------------------']);

end