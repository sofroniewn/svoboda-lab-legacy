function wv = func_extract_whisking_variables(wl)
%%
disp(['--------------------------------------------']);
disp(['EXTRACT WHISKING VARIABLES']);
%% Put kappa and theta in new arrays
wv.data = cell(numel(wl.data),1);
wv.trajectoryIDs = wl.trajectoryIDs;
wv.framePeriodInSec = wl.framePeriodInSec;
wv.pxPerMm = wl.pxPerMm;
nWhisk = length(wv.trajectoryIDs);
% Calculate theta band pass filtered, theta amplitude, theta setpoint,
% theta phase
d = fdesign.bandpass('N,Fc1,Fc2',4,4,30,500);
H_bp = design(d,'butter');
[b_bp a_bp] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);
smooth_window = ones(1,250)/250;

for ij = 1:numel(wl.data)
    wv.data{ij}.theta_raw = wl.data{ij}.theta;
    wv.data{ij}.theta = wl.data{ij}.theta_lp;
    tmp = [repmat(wv.data{ij}.theta(:,1),1,125) wv.data{ij}.theta repmat(wv.data{ij}.theta(:,end),1,125)];
    tmp = conv2(tmp,smooth_window,'same');
    wv.data{ij}.theta_setpoint = tmp(:,126:end-125);
    wv.data{ij}.theta_bp = NaN(size(wv.data{ij}.theta));
    wv.data{ij}.theta_amp = NaN(size(wv.data{ij}.theta));
    wv.data{ij}.theta_phase = NaN(size(wv.data{ij}.theta));
    for ik = 1:nWhisk
        wv.data{ij}.theta_bp(ik,:) = filtfilt(b_bp,a_bp,wv.data{ij}.theta(ik,:));
        tmp = hilbert(wv.data{ij}.theta_bp(ik,:));
        wv.data{ij}.theta_amp(ik,:) = abs(tmp);
        wv.data{ij}.theta_phase(ik,:) = angle(tmp);
    end
    tmp = [repmat(wv.data{ij}.theta_amp(:,1),1,125) wv.data{ij}.theta_amp repmat(wv.data{ij}.theta_amp(:,end),1,125)];
    tmp = conv2(tmp,smooth_window,'same');
    wv.data{ij}.theta_amp = tmp(:,126:end-125);
    tmp = [repmat(wv.data{ij}.theta_phase(:,1),1,125) wv.data{ij}.theta_phase repmat(wv.data{ij}.theta_phase(:,end),1,125)];
    tmp = conv2(tmp,smooth_window,'same');
    wv.data{ij}.theta_phase = tmp(:,126:end-125);
    wv.data{ij}.kappa = wl.data{ij}.kappa_lp;
end
disp(['--------------------------------------------']);
