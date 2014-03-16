function [ch_MUA commonNoise] = func_denoise(TimeStamps, ch_MUA, ch_noise)

% Subtract common noise from all channels. Determine common noise using
% channels with no spikes on them. Average these channels together
% then scale noise to each particular channel and subtract it off

    disp(['--------------------------------------------']);
    disp(['denoise file']);
    
    % determine common noise
    if isempty(ch_noise) ~= 1
    commonNoise = trimmean(ch_MUA(:, ch_noise),.5,2);
    
    % subtract off common noise, scaling noise appropriately
        t_post_stim = [-Inf Inf]; % in sec
        i_post_stim = find(TimeStamps>t_post_stim(1) & TimeStamps<t_post_stim(2));
        X = [ones(size(commonNoise(i_post_stim),1),1) commonNoise(i_post_stim)];
        for i_ch = 1:size(ch_MUA,2)
            b = regress(ch_MUA(i_post_stim,i_ch),X);
            ch_MUA(:,i_ch) = ch_MUA(:,i_ch) - commonNoise*b(2);
        end
    else
    end
    disp(['--------------------------------------------']);

end