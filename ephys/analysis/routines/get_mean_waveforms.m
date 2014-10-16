function [time_vect norm_waves mean_waves] = get_mean_waveforms(all_anm)

%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
% %% MEAN WAVEFORMS
%
 time_vect = all_anm{1}.d.summarized_cluster{1}.WAVEFORMS.time_vect;
 mean_waves = [];
 mean_waves_sm = [];
 tau_new = [];
 for ih = 1:numel(all_anm)
   for ij = 1:numel(all_anm{ih}.d.summarized_cluster)
   	avg_wave = all_anm{ih}.d.summarized_cluster{ij}.WAVEFORMS.avg;
 	mean_waves = cat(1,mean_waves,avg_wave);
 	avg_wave = smooth(avg_wave,5,'sgolay',1);
 	mean_waves_sm = cat(1,mean_waves_sm,avg_wave');
 	[val ind] = max(avg_wave(20:end));
 	tau_new = cat(1,tau_new,time_vect(20-1+ind));
 	end
 end

 norm_waves = bsxfun(@minus,mean_waves,mean(mean_waves(:,1:10),2));
% %norm_waves = mean_waves;
 norm_waves = bsxfun(@rdivide,norm_waves,-min(norm_waves,[],2));

% norm_waves_sm = bsxfun(@minus,mean_waves_sm,mean(mean_waves_sm(:,1:10),2));
% norm_waves_sm = bsxfun(@rdivide,norm_waves_sm,-min(norm_waves_sm,[],2));
