function wv = func_cleanup_whisker_traces(wl)
%%
disp(['--------------------------------------------']);
disp(['CLEAN UP WHISKER TRACES']);

%% Put kappa and theta in new arrays
wv.data = cell(numel(wl.trials),1);
wv.trajectoryIDs = wl.trials{1}.trajectoryIDs;
wv.framePeriodInSec = wl.trials{1}.framePeriodInSec;
wv.pxPerMm = wl.trials{1}.pxPerMm;
nWhisk = length(wv.trajectoryIDs);

for ij = 1:numel(wl.trials)
    time = zeros(nWhisk,1);
    for ik = 1:nWhisk
        if ~isempty(wl.trials{ij}.time{ik})
            time(nWhisk) = max(wl.trials{ij}.time{ik});
        end
    end
    max_time = max(time);
    nInds = round(max_time/wv.framePeriodInSec)+1;
    wv.data{ij}.theta = NaN(nWhisk,nInds);
    wv.data{ij}.kappa = NaN(nWhisk,nInds);
    for ik = 1:nWhisk
        if ~isempty(wl.trials{ij}.time{ik})
            wv.data{ij}.theta(ik,round(wl.trials{ij}.time{ik}/wv.framePeriodInSec)+1) = wl.trials{ij}.theta{ik};
            wv.data{ij}.kappa(ik,round(wl.trials{ij}.time{ik}/wv.framePeriodInSec)+1) = wl.trials{ij}.kappa{ik};
        end
    end
    wv.data{ij}.theta_NaN = sum(isnan(wv.data{ij}.theta),2);
    wv.data{ij}.kappa_NaN = sum(isnan(wv.data{ij}.kappa),2);
end

%% INTERPOLATE
disp(['INTERPOLATE']);
for ij = 1:numel(wl.trials)
    nInds = size(wv.data{ij}.theta,2);
    range = [1:nInds]';
    wv.data{ij}.theta_interp = wv.data{ij}.theta;
    wv.data{ij}.kappa_interp = wv.data{ij}.kappa;
    for ik = 1:nWhisk
        if ~isempty(wl.trials{ij}.time{ik})
        wv.data{ij}.theta_interp(ik,1) = wv.data{ij}.theta_interp(ik,find(~isnan(wv.data{ij}.theta_interp(ik,:)),1,'first'));
        wv.data{ij}.theta_interp(ik,end) = wv.data{ij}.theta_interp(ik,find(~isnan(wv.data{ij}.theta_interp(ik,:)),1,'last'));
        wv.data{ij}.kappa_interp(ik,1) = wv.data{ij}.kappa_interp(ik,find(~isnan(wv.data{ij}.theta_interp(ik,:)),1,'first'));
        wv.data{ij}.kappa_interp(ik,end) = wv.data{ij}.kappa_interp(ik,find(~isnan(wv.data{ij}.theta_interp(ik,:)),1,'last'));
        wv.data{ij}.theta_interp(ik,:) = interp1q(find(~isnan(wv.data{ij}.theta_interp(ik,:)))',wv.data{ij}.theta_interp(ik,~isnan(wv.data{ij}.theta_interp(ik,:)))',range);
        wv.data{ij}.kappa_interp(ik,:) = interp1q(find(~isnan(wv.data{ij}.kappa_interp(ik,:)))',wv.data{ij}.kappa_interp(ik,~isnan(wv.data{ij}.kappa_interp(ik,:)))',range);
        end
    end
end

%% SET UP LOW PASS FILTER
d = fdesign.lowpass('N,Fc',4,30,round(1/wv.framePeriodInSec));
H_lp = design(d,'butter');
[b_lp a_lp] = sos2tf(H_lp.sosMatrix,H_lp.scaleValues);

%% FILTER DATA
disp(['LOW PASS FILTER']);
for ij = 1:numel(wl.trials)
    wv.data{ij}.theta_lp = NaN(size(wv.data{ij}.theta));
    wv.data{ij}.kappa_lp = NaN(size(wv.data{ij}.kappa));
    for ik = 1:nWhisk
        if ~isempty(wl.trials{ij}.time{ik})
        wv.data{ij}.theta_lp(ik,:) = filtfilt(b_lp,a_lp,wv.data{ij}.theta_interp(ik,:));
        wv.data{ij}.kappa_lp(ik,:) = filtfilt(b_lp,a_lp,wv.data{ij}.kappa_interp(ik,:));     
        end
    end
end

disp(['--------------------------------------------']);
