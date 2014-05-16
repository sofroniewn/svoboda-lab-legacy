function [vlt_chan aux_chan TimeStamps] = func_read_raw_voltages(f_name,freqSampling,gain,ch_ids);

    disp(['--------------------------------------------']);
    disp(['reading file ',f_name]);
    
    fid = fopen(f_name,'r');
    
    % Read a full file
    matrixRaw=fread(fid,inf,'uint16');
    fclose(fid);
    
    % Convert to doubles and scale voltage    
%    matrixVol = double(10*(matrixRaw-(sign(matrixRaw-2^15)+1)*2^15)/2^16);
    matrixVol = double(10*(matrixRaw-((matrixRaw-2^15)>0)*2^16)/2^16);
    ch_all_raw = reshape(matrixVol,ch_ids.num_tot,size(matrixVol,1)/ch_ids.num_tot)';

    % Seperate voltage chanels from auxillary channels
    vlt_chan = ch_all_raw(:,1:ch_ids.num_spike)/gain;
    aux_chan = ch_all_raw(:,ch_ids.num_spike+1:end);
    TimeStamps = (0 : size(vlt_chan, 1)-1)/freqSampling;
    
    disp(['--------------------------------------------']);

end