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

spikes_all = [spikes_all [1:size(spikes_all,1)]'];
%% REMOVE RETRIGGERING WITHIN CHANNEL NEIGHBOURHOOD
nspk = size(spikes_all,1);
spikes_all_copy = [spikes_all];
% Go through all spikes
spikes_trim = [];
while isempty(spikes_all_copy) ~= 1
        % find any spikes on other neighbourhood channels within trigger delay
        other_chan_spikes = find(spikes_all_copy(:,2) <= spikes_all_copy(1,2)+param_extract.shadow_period_across_channels & ismember(spikes_all_copy(:,1),chan_range_large{spikes_all_copy(1,1)}));
        % find max amplitude of spikes
        [a ind] = min(spikes_all_copy(other_chan_spikes,3));
        spikes_trim = [spikes_trim; spikes_all_copy(other_chan_spikes(ind),:)];
        % delete spikes within channel range of detected spike
        other_chan_spikes = find(spikes_all_copy(:,2) <= spikes_all_copy(1,2)+param_extract.shadow_period_across_channels & ismember(spikes_all_copy(:,1),chan_range_large{spikes_all_copy(other_chan_spikes(ind),1)}));
        spikes_all_copy(other_chan_spikes,:) = [];
end

spikes_trim = spikes_trim(:,4);
disp(['--------------------------------------------']);
