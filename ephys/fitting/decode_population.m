function [perf rate N] = decode_population(f_nc,N)
% for # of nuerons in N resample f_nc to get decoder performance 
N(N>size(f_nc,1)) = [];

% number of resamples
n_resamp = 10;
perf = zeros(n_resamp,length(N),size(f_nc,2));
rate = zeros(n_resamp,length(N),size(f_nc,2));

for iN = 1:length(N)
	n_neurons = N(iN);
	for iReps = 1:n_resamp;
		[iN length(N) iReps n_resamp]
		samp = randperm(size(f_nc,1),n_neurons);
		fs_nc = f_nc(samp,:);
		[perf(iReps,iN,:) rate(iReps,iN,:)] = decode_tuning(fs_nc);
	end
end

perf = squeeze(mean(perf,1));
rate = squeeze(mean(rate,1));