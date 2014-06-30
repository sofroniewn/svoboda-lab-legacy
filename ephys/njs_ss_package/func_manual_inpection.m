function [] = func_manual_inpection(single_unit_dir, tag_ID, raw_voltage_dir, processed_voltage_dir, raw_spikes_dir, gain, chNum, ch_spike, freqSampling, trigger_ch, bitcode_ch)


% 
% % load information from the solo file
% load(solo_filename);
% solo_aom = saved.stim_timing2AFCobj_stim_AOM_power_history;
% solo_xgalvo = saved.stim_timing2AFCobj_stim_xGalvo_pos_history;
% solo_ygalvo = saved.stim_timing2AFCobj_stim_yGalvo_pos_history;
% 


% find all the single units files
single_unit_filelist = dir([single_unit_dir,'SingleUnit*']);


% go through the sorted units one by one
for i_file = 1:size(single_unit_filelist,1)
    
    disp(['--------------------------------------------']);
    disp(['processing file ',single_unit_filelist(i_file).name]);

    % load the data
    load([single_unit_dir, single_unit_filelist(i_file).name]);
    
    % channel on which the unit is detected
    unit_channel = median(unit.channel);
    
    % stable trials
    stable_trials_tmp = unit.stable_trials;
    
    % find trials with maximum laser intensity
    %solo_aom_tmp = solo_aom(stable_trials_tmp);
    %solo_xgalvo_tmp = solo_xgalvo(stable_trials_tmp);
    %solo_ygalvo_tmp = solo_ygalvo(stable_trials_tmp);
    stable_trials_tmp = stable_trials_tmp;%(solo_aom_tmp==max(solo_aom) & solo_xgalvo_tmp==0 & solo_ygalvo_tmp==0);
    
    
    % select subset of trials
    i_selected_trial = stable_trials_tmp(randsample(length(stable_trials_tmp),min([20 length(stable_trials_tmp)])));
    
    
    % match solo_trial to spikeGL file
%     voltage_traces_filename = [raw_voltage_dir, 'data_5.bin'];
%     fid = fopen(voltage_traces_filename,'r');
%     matrixRaw=fread(fid,inf,'uint16'); % Read a full file
%     fclose(fid);
%     clear fid
%     matrixVol = double(10*(matrixRaw-(sign(matrixRaw-2^15)+1)*2^15)/2^16); % Convert to doubles and scale voltage
%     clear matrixRaw
%     
%     ch_all_raw = reshape(matrixVol,chNum,size(matrixVol,1)/chNum)';
%     clear matrixVol
%     Trigger_allCh = ch_all_raw(:,trigger_ch);
%     Bitcode_allCh = ch_all_raw(:,bitcode_ch);
%     clear ch_all_raw
%     
%     TimeStamps = (0 : size(Trigger_allCh, 1)-1)/freqSampling;
%     
%     i_start_time = find(Trigger_allCh > 1);
%     t_start = TimeStamps(i_start_time(1));
%     TimeStamps = TimeStamps - t_start;
%     
%     % read bit code
%     TrialNum_offset = func_read_bitcode(Bitcode_allCh,TimeStamps);
%     TrialNum_offset = TrialNum_offset-5; % for data_5.bin
%     
%     i_selected_trial = i_selected_trial-TrialNum_offset;
%     clear TimeStamps Trigger_allCh Bitcode_allCh voltage_traces_filename
     TrialNum_offset = 0;
    
    
    % process and display the data
    quality_score = [];
    artifact_annotation = [];    
    for i_trial = i_selected_trial
        
        if ~isempty(quality_score) & ~isempty(artifact_annotation)   
            break
        end
        
        close all
        figure('position',[100 100 1200 500])
        
%         % -------------- raw voltage traces ----------------
%         % first load and process raw data file
%         voltage_traces_filename = [raw_voltage_dir, 'run_b_',num2str(i_trial),'.bin'];
%         fid = fopen(voltage_traces_filename,'r');
% 
%         matrixRaw=fread(fid,inf,'uint16'); % Read a full file
%         fclose(fid);
%         clear fid
%         
%         matrixVol = double(10*(matrixRaw-(sign(matrixRaw-2^15)+1)*2^15)/2^16); % Convert to doubles and scale voltage
%         clear matrixRaw
%         
%         ch_all_raw = reshape(matrixVol,chNum,size(matrixVol,1)/chNum)';
%         clear matrixVol
%         
%         VoltageTraceInV_allCh = ch_all_raw(:,1:ch_spike)/gain;
%         Trigger_allCh = ch_all_raw(:,trigger_ch);
%         Bitcode_allCh = ch_all_raw(:,bitcode_ch);
%         clear ch_all_raw
%         
%         TimeStamps = (0 : size(Trigger_allCh, 1)-1)/freqSampling;
%         
%         i_start_time = find(Trigger_allCh > 1);
%         t_start = TimeStamps(i_start_time(1));
%         TimeStamps = TimeStamps - t_start;
%         
% 
%         % filter the data into spiking and field potential band
%         ch_MUA = [];
%         for i_ch = 1:ch_spike
%             ch_tmp         = timeseries(VoltageTraceInV_allCh(:,i_ch),TimeStamps);
%             ch_tmp_MUA     = idealfilter(ch_tmp,[300 6000],'pass');
%             ch_MUA(:,i_ch) = ch_tmp_MUA.data;
%         end
%         clear VoltageTraceInV_allCh
%         
%         
%         % sort channels
%         ch_MUA = func_sortChannel(ch_MUA);
%         ch_MUA = ch_MUA(:,unit_channel);
%         
% %         % read bit code
% %         TrialNum = func_read_bitcode(Bitcode_allCh,TimeStamps);
% %         disp(['done!  Matched to solo trial #',num2str(TrialNum)]);
        TrialNum = i_trial;
%         
%         
%         % cut off data from two ends to get ride of edge effects from filtering
%         ch_MUA = ch_MUA(200:end-200,:);
%         TimeStamps = TimeStamps(200:end-200);
%         
%         
%         % plot the raw data
%         subplot(2,1,1); hold on
%         plot(TimeStamps, ch_MUA, 'k');
%         
        
        
     
       %  keyboard
        
        % --------------- load and plot processed voltage trace ----------------
        load([processed_voltage_dir, 'raw_trace_',num2str(tag_ID),'_trial_',num2str(i_trial+TrialNum_offset),'.mat']);
        ch_MUA = ch_MUA(:,unit_channel);
        
        subplot(2,1,1); hold on
        plot(TimeStamps, ch_MUA, 'r');
        
        
        
        % --------------- load and plot raw and sorted spikes ----------------
        % load detected all spikes
        load([raw_spikes_dir, 'raw_spike_',num2str(tag_ID),'_trial_',num2str(i_trial+TrialNum_offset),'.mat']);
        
        %spikes_curr = ss_align(spikes_curr);
        [spikes_curr] = func_discard_artifact_units_mCh(spikes_curr, .035);
        
    n_spk = size(spikes_curr.waveforms,1);
    % extract data
    try
        % raw spike times
        subplot(2,1,1); hold on
        plot(spikes_curr.spiketimes(spikes_curr.info.detect.event_channel==unit_channel), min(ch_MUA)*1.2, 'xk');
        
        % raw waveforms
        subplot(2,4,7);
        plot(spikes_curr.waveforms(spikes_curr.info.detect.event_channel==unit_channel,:,unit_channel)');
        
        
        
        % sorted spike times
        subplot(2,1,1); hold on
        if sum(unit.trials==i_trial+TrialNum_offset)
            plot(unit.spike_times(unit.trials==i_trial+TrialNum_offset), min(ch_MUA)*1.2,'or');
        end
        
        % sorted waveforms
        subplot(2,4,6);
        plot(unit.waveforms(unit.trials==i_trial+TrialNum_offset,:)');

        
        
        % plot both raw and sorted for comparison
        subplot(2,4,8); hold on
        plot(spikes_curr.waveforms(spikes_curr.info.detect.event_channel==unit_channel,:,unit_channel)'/5,'k'); % divide by 5 for amplication compensation
        plot(unit.waveforms(unit.trials==i_trial+TrialNum_offset,:)', 'r');
        
        
        
        % plot ISI
        subplot(2,4,5);
        isi = diff(unit.spike_times);
        isi = isi(find(isi<.5));
        isi = [isi; -isi];
        edges = [-.03:.00025:.03];
        n = histc(isi,edges);
        bar(edges, n, 'k')
        axis([-.02 .02 0 max(n)]);
    catch  
    end
        
        % display some info about the unit
        subplot(2,1,1);
        title([single_unit_filelist(i_file).name, '; Trial ', num2str(TrialNum), ' FA:',num2str(unit.false_alarm_est),'  Miss: ',num2str(unit.miss_est)])
        clear ch_MUA TimeStamps *_allCh spikes_curr
        
        
        % user input
        if isempty(quality_score) & isempty(artifact_annotation)   
            dummy =  input('Enter ''1'' or ''0'' for unit quality;  ''y'' or ''n'' for laser artifact;  hit ''Return'' to continue','s');
            if (str2num(dummy)==1)|(str2num(dummy)==0)
                quality_score = dummy;
            end
            if (dummy=='y')|(dummy=='n')
                artifact_annotation = dummy;
            end
        elseif isempty(quality_score)
            dummy =  input('Enter ''1'' or ''0'' for unit quality;  hit ''Return'' to continue','s');
            if (str2num(dummy)==1)|(str2num(dummy)==0)
                quality_score = dummy;
            end
            if (dummy=='y')|(dummy=='n')
                artifact_annotation = dummy;
            end
        elseif isempty(artifact_annotation)
            dummy =  input('Enter ''y'' or ''n'' for laser artifact;  hit ''Return'' to continue','s');
            if (str2num(dummy)==1)|(str2num(dummy)==0)
                quality_score = dummy;
            end
            if (dummy=='y')|(dummy=='n')
                artifact_annotation = dummy;
            end
        end
        close all
        
    end
    
    % save the data
    unit.manual_quality_score = quality_score;
    unit.artifact_annotation = artifact_annotation;
    
    save([single_unit_dir, single_unit_filelist(i_file).name],'unit');
    
end
