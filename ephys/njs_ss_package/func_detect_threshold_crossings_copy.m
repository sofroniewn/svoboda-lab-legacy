function [spikes_all spikes_trim] = func_detect_threshold_crossings(ch_MUA, param_extract)
%%
disp(['--------------------------------------------']);
disp(['detect threshold crossings']);
%% Create channel neighbourhoods
nchan = size(ch_MUA,2);
chan_range = cell(nchan,1);
chan_range_large = cell(nchan,1);
range_small = [-param_extract.channel_neighbourhood_small:param_extract.channel_neighbourhood_small];
range_large = [-param_extract.channel_neighbourhood_large:param_extract.channel_neighbourhood_large];

for ij = 1:nchan
    chan_range_large{ij} = ij+range_large;
    chan_range{ij} = ij+range_small;
    chan_range{ij}(chan_range{ij} < 1 | chan_range{ij} > nchan) = [];
    chan_range_large{ij}(chan_range_large{ij} < 1 | chan_range_large{ij} > nchan) = [];
end

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

%% POOL ALL SPIKES
spikes_all = [];
for ij = 1:nchan
    spikes_all = [spikes_all;[repmat(ij,length(spikes{ij,1}),1) spikes{ij,1}' spikes{ij,2}']];
end
if isempty(spikes_all)~=1
[B,IX] = sort(spikes_all(:,2));
spikes_all = spikes_all(IX,:);
end


%% Detect on all channels simultaneously
xaux = sum(ch_MUA<repmat(param_extract.thresh,size(ch_MUA,1),1),2);
xaux = find(xaux);
xaux0 = 0;
nspk = 0;
% trim spikes near end of record
xaux(xaux>size(ch_MUA,1) - param_extract.shadow_period - param_extract.retriggerDelay) = [];
spikes_trim = [];   
for j=1:length(xaux)
    % ignores retriggers within refractory period
    if xaux(j) >= xaux0 + param_extract.shadow_period
        % introduces alignment on the local Energy within retriggerDelay
        across_channel_slice = ch_MUA(xaux(j):xaux(j)+param_extract.retriggerDelay-1,:);
        [maxi iaux] = min(across_channel_slice(:));
        nspk = nspk + 1;
        spikes_keep = iaux + xaux(j) -1;
        spikes_trim = [spikes_trim;spikes_keep];
        xaux0 = spikes{i,1}(nspk);
    end
end

%% REMOVE RETRIGGERING WITHIN CHANNEL NEIGHBOURHOOD
%ch_MUA_blanked = ch_MUA;
%nspk = size(spikes_all,1);
%spikes_all_copy = [spikes_all];
% Go through all spikes
%spikes_trim = [];
%for j=1:nspk
%    if isempty(spikes_all_copy) ~= 1
%        % find any spikes on other neighbourhood channels within trigger delay
%        other_chan_spikes = find(spikes_all_copy(:,2) <= spikes_all_copy(1,2)+param_extract.shadow_period_across_channels & ismember(spikes_all_copy(:,1),chan_range_large{spikes_all_copy(1,1)}));
%        % find max amplitude of spikes
%        [a ind] = min(spikes_all_copy(other_chan_spikes,3));
%        spikes_trim = [spikes_trim; spikes_all_copy(other_chan_spikes(ind),:)];
%        % delete spikes within channel range of detected spike
%        other_chan_spikes = find(spikes_all_copy(:,2) <= spikes_all_copy(1,2)+param_extract.shadow_period_across_channels & ismember(spikes_all_copy(:,1),chan_range_large{spikes_all_copy(other_chan_spikes(ind),1)}));
%        spikes_all_copy(other_chan_spikes,:) = [];
%    end
%end

%% REMOVE RETRIGGERING WITHIN CHANNEL NEIGHBOURHOOD
ch_MUA_blanked = ch_MUA;
nspk = size(spikes_all,1);
% Go through and detect all indices above spike threshold
spikes_trim = [];
for j=1:nspk
   % check if current spike has already been blanked
   if abs(ch_MUA_blanked(spikes_all(j,2),spikes_all(j,1))) > 0 
       % look in large channel neighbourhood of detected spike to find
       % channel maximum SNR event 
       tmp = ch_MUA_blanked(spikes_all(j,2):spikes_all(j,2)+param_extract.retriggerDelay-1,chan_range_large{spikes_all(j,1)});
       tmp = (tmp./repmat(param_extract.stds(chan_range_large{spikes_all(j,1)}),param_extract.retriggerDelay,1));
       [maxi iaux] = min(tmp(:));
       [iaux idx_chan] = ind2sub(size(tmp),iaux);
        idx_chan = chan_range_large{spikes_all(j,1)}(idx_chan);
        % this channel is now the detection channel
        % blank voltages on small neighbourhood channels
        ch_MUA_blanked(spikes_all(j,2):spikes_all(j,2)+param_extract.shadow_period_across_channels-1,chan_range{idx_chan}) = 0;
        spikes_trim = [spikes_trim; idx_chan, (iaux+spikes_all(j,2)-1)];
    end
end

disp(['--------------------------------------------']);
