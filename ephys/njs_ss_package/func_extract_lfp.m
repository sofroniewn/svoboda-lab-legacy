function [lfp_data] = func_extract_lfp(base_dir, file_nums, lfp_name, over_write)
%%
disp(['--------------------------------------------']);
lite = 1;
f_name_save = fullfile(base_dir,'ephys','sorted',[lfp_name '.mat']);


if over_write == 0 && exist(f_name_save) == 2
    disp(['LOAD LFP']);
    load(f_name_save);
else

    f_name_flag = '*_trial*.bin';
    file_list = func_list_files(base_dir,f_name_flag,file_nums);

    lfp_data.trial = NaN(numel(file_list)-1,1);
    lfp_data.Hpsd = cell(numel(file_list)-1,1);
    %lfp_data.TimeStamps = cell(numel(file_list)-1,1);
    %lfp_data.flt_vlt_session = cell(numel(file_list)-1,1);
    lfp_data.raw_vlt = cell(numel(file_list)-1,1);
    lfp_data.flt_vlt_theta = cell(numel(file_list)-1,1);
    lfp_data.flt_vlt_gamma = cell(numel(file_list)-1,1);
    
    for i_trial = 1:numel(file_list)-1
        disp(file_list{i_trial});
        
        f_name = fullfile(base_dir,file_list{i_trial});
        f_name_processed_vlt = fullfile(base_dir,'ephys','processed',[file_list{i_trial}(1:end-4) '_processed_vlt.mat']);
        f_name_spikes = fullfile(base_dir,'ephys','processed',[file_list{i_trial}(1:end-4) '_spikes.mat']);
        
        disp(['EXTRACT LFP']);
        if exist(f_name_processed_vlt) == 2
            load(f_name_processed_vlt);
        else
            [p d] = func_process_voltage(f_name,ch_noise,lite);
            save(f_name_processed_vlt,'p','d');
        end
        aux_chan = d.aux_chan(:,1:3);
        ch_ids = p.ch_ids;
        ch_ids.file_trigger = 2;
        ch_ids.frame_trigger = 3;

        [aux_chan ch_ids start_ind] = extract_behaviour_triggers(aux_chan,ch_ids);

        if ~isempty(file_nums)
            lfp_data.trial(i_trial) = file_nums(i_trial);
        else
            lfp_data.trial(i_trial) = i_trial;        
        end

        x = mean(d.vlt_chan,2);

         if i_trial == 1
             freq = 1/mean(diff(d.TimeStamps));
             d_F = fdesign.bandpass('N,Fc1,Fc2',4,4,10,freq);
             H_bp = design(d_F,'butter');
             [b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);
             d_F2 = fdesign.bandpass('N,Fc1,Fc2',4,12,25,freq);
             H_bp2 = design(d_F2,'butter');
             [b2 a2] = sos2tf(H_bp2.sosMatrix,H_bp2.scaleValues);
             Hs=spectrum.mtm(4);
         end

        xz = filtfilt(b,a,x);
        xz2 = filtfilt(b2,a2,x);

        Hpsd = psd(Hs,x,'Fs',freq);
        lfp_data.Hpsd{i_trial}.Frequencies = Hpsd.Frequencies(1:1500);
        lfp_data.Hpsd{i_trial}.Data = Hpsd.Data(1:1500);
        lfp_data.raw_vlt{i_trial} = accumarray(aux_chan(aux_chan(:,4)>0,4),x(aux_chan(:,4)>0));
        lfp_data.flt_vlt_theta{i_trial} = accumarray(aux_chan(aux_chan(:,4)>0,4),xz(aux_chan(:,4)>0));
        lfp_data.flt_vlt_gamma{i_trial} = accumarray(aux_chan(aux_chan(:,4)>0,4),xz2(aux_chan(:,4)>0));
%       lfp_data.flt_vlt_ephys{i_trial} = xz;
%       lfp_data.TimeStamps{i_trial} = d.TimeStamps;


        disp(['--------------------------------------------']);
    end

    save(f_name_save,'lfp_data');
end
disp(['--------------------------------------------']);



