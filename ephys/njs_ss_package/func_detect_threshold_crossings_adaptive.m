function [spike_output] = func_detect_threshold_crossings_adaptive(ch_MUA, param_extract)
%%
disp(['--------------------------------------------']);
disp(['detect threshold crossings']);
%% Create channel neighbourhoods
nchan = size(ch_MUA,2);

%% DETECT SPIKES ON EACH CHANNEL INDEPENDENTLY
spikes = cell(nchan,2);
% Go through each channel and independently detect spikes
for i=1:nchan  
    % Go through and detect all indices above spike threshold
    xaux = find(ch_MUA(:,i) < param_extract.thresh(i));
    xaux0 = 0;
    nspk = 0;

    % trim spikes near end of record
    xaux(xaux>length(ch_MUA(:,i)) - param_extract.shadow_period - param_extract.retriggerDelay) = [];
    
    for j=1:length(xaux)
        % ignores retriggers within refractory period
        if xaux(j) >= xaux0 + param_extract.shadow_period
            % introduces alignment on the local Energy within retriggerDelay
            [maxi iaux]=min(ch_MUA(xaux(j):xaux(j)+param_extract.retriggerDelay-1,i));
            nspk = nspk + 1;
            spikes{i,1}(nspk) = iaux + xaux(j) -1;
            spikes{i,2}(nspk) = maxi;
            xaux0 = spikes{i,1}(nspk);
        end
    end
end

%% POOL ALL SPIKES %list detected channel - then timestamp - then amplitude
spikes_all = [];
for ij = 1:nchan
    spikes_all = [spikes_all;[repmat(ij,length(spikes{ij,1}),1) spikes{ij,1}' spikes{ij,2}']];
end

%% Resort by time
if isempty(spikes_all)~=1
[B,IX] = sort(spikes_all(:,2));
spikes_all = spikes_all(IX,:);
end

spikes_all = [spikes_all [1:size(spikes_all,1)]'];
%% REMOVE RETRIGGERING WITHIN CHANNEL NEIGHBOURHOOD
nspk = size(spikes_all,1);
spikes_all_copy = [spikes_all];
% Go through all spikes
spike_output = [];

while isempty(spikes_all_copy) ~= 1
        % find any spikes on other neighbourhood channels within trigger delay
        %other_chan_spikes = find(spikes_all_copy(:,2) <= spikes_all_copy(1,2)+param_extract.shadow_period_across_channels & ismember(spikes_all_copy(:,1),chan_range_large{spikes_all_copy(1,1)}));
        other_chan_spikes = find(spikes_all_copy(:,2) < spikes_all_copy(1,2)+param_extract.shadow_period_across_channels);


        chan_list = spikes_all_copy(other_chan_spikes,1);
        keep_ind = 1;
        keep_chan = spikes_all_copy(1,1);
        cur_chan = spikes_all_copy(1,1)+1;
        out_of_range = 0;
        while cur_chan <= nchan && out_of_range < 2
            add_ind = find(cur_chan == chan_list);
            if isempty(add_ind)
                out_of_range = out_of_range + 1;
            else
                keep_ind = [keep_ind add_ind'];
                keep_chan = [keep_chan cur_chan'];
                out_of_range = 0;
            end
            cur_chan = cur_chan+1;
        end
        cur_chan = spikes_all_copy(1,1)-1;
        out_of_range = 0;
        while cur_chan >= 1 && out_of_range < 2
            add_ind = find(cur_chan == chan_list);
            if isempty(add_ind)
                out_of_range = out_of_range + 1;
            else
                keep_ind = [keep_ind add_ind'];
                keep_chan = [keep_chan cur_chan'];    
                out_of_range = 0;
            end
            cur_chan = cur_chan-1;
        end

        min_range = min(keep_chan);
        max_range = max(keep_chan);

        [a ind] = min(spikes_all_copy(other_chan_spikes(keep_ind),3));
        spike_time = spikes_all_copy(other_chan_spikes(keep_ind(ind)),2);                

        spike_output = [spike_output; spike_time min_range max_range keep_chan(ind)];
        % delete spikes within channel range of detected spike
        spikes_all_copy(other_chan_spikes(keep_ind),:) = [];
end

disp(['--------------------------------------------']);
