function [spike_amp spike_width spike_wave spike_PCA] = func_extract_waveforms_blank(ch_MUA, spikes_trim, p)
%%
disp(['--------------------------------------------']);
disp(['extract_waveforms']);
%% Set parameters
p.window = [-p.w_pre:p.w_post+p.retriggerDelay];
p.num_samps = length(p.window);
p.s = 1:p.num_samps;
p.ints = 1/p.int_factor:1/p.int_factor:(p.w_pre+p.w_post+p.retriggerDelay+1);
p.a_ints = [-p.a_pre*p.int_factor:p.int_factor*p.a_post+p.int_factor*p.retriggerDelay];
p.a_ints(1) = [];
p.a_ints(end) = [];
p.a_num_samps = length(p.a_ints);
p.a_mid = find(p.a_ints==0);

%% Create channel neighbourhoods
nchan = size(ch_MUA,2);

%% EXTRACT WAVEFORMS
nspk = size(spikes_trim,1);
nchan = size(ch_MUA,2);

% pre thru post spike index array
spkWaveformIndex = repmat(spikes_trim(:,1),1,p.num_samps)+repmat(p.window,nspk,1);
% Filtered waveform signals
auxspikes = reshape(ch_MUA(spkWaveformIndex,:),nspk,p.num_samps,nchan);
% makes the interpolation and intspikes have double the points in this case
intspikes = permute(spline(p.s,permute(auxspikes,[1 3 2]),p.ints),[1 3 2]);

%% Set waveform to positive outside neighborhood of detection channel
all_chan = [1:nchan];
intspikes_clean = intspikes;
for j = 1:nspk
    tmp_chan = all_chan;
    tmp_chan(max(spikes_trim(j,2)-2,1):min(spikes_trim(j,3)+2,nchan)) = [];
    intspikes_clean(j,:,tmp_chan) = NaN;
end

%% Realign spikes to maximum after interpolation
% Find peak amplitude of each waverform in jitter period and shift
jitter_window = p.int_factor*(p.w_pre-p.jitter):p.int_factor*(p.w_pre+p.jitter);
spike_wave = zeros(nspk,p.a_num_samps,nchan);

for j = 1:nspk
        tmp = intspikes_clean(j,jitter_window,spikes_trim(j,4));
        [maxi iaux] = max(-tmp);
        iaux = iaux+p.int_factor*(p.w_pre-p.jitter)-1;
        tmp = squeeze(intspikes_clean(j,:,:));
        spike_wave(j,:,:) = tmp(iaux+p.a_ints,:);
end

%% Find spike widths and amplitude
% Take amplitude as max on any channel
% spike_amp = squeeze(max(spike_wave(:,p.a_mid-1:p.a_mid+1,:),[],2));
spike_amp = squeeze(mean(spike_wave(:,p.a_mid-1:p.a_mid+1,:),2));
spike_width = zeros(nspk,nchan);
for j = 1:nspk
    for k = 1:nchan
        half_amp = spike_amp(j,k)/2;
        if half_amp <= 0
            tmp = spike_wave(j,:,k);
            a = find(tmp(1:p.a_mid)>half_amp,1,'last');
            b = find(tmp(p.a_mid+1:end)>half_amp,1,'first')-1+p.a_mid;
            if isempty(a) ~= 1 && isempty(b) ~= 1
                spike_width(j,k) = b - a;
            end
        end
    end
end
%% Extract PCA features on spikes
% spike_wave_PCA = reshape(spike_wave,nspk,nchan*p.a_num_samps);
% [COEFF,SCORE]   = princomp(spike_wave_PCA);
% spike_PCA = SCORE(:,1:nchan);
spike_PCA = [];
%%
disp(['--------------------------------------------']);

% %%
% figure(43)
% clf(43)
% hold on
% %plot(tmp)
% plot(spike_wave_PCA(1,:))
% 
%%
% figure(43)
% clf(43)
% hold on
% %plot(tmp)
% for j = 1
% plot(squeeze(intspikes_shift(j,:,spikes_trim(j,1))))
% plot(20,squeeze(intspikes_shift(j,20,spikes_trim(j,1))),'.r')
% plot([17 27]+1,[squeeze(intspikes_shift(j,20,spikes_trim(j,1))) squeeze(intspikes_shift(j,20,spikes_trim(j,1)))]/2,'r')
% 
% end