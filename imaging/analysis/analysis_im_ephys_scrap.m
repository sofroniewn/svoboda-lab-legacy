%%analysis_im_ephys


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Across epoch rasters & PSTHs and tuning curves

type_nam = 'corPos';
type_nam = 'corPos';


trial_range = [0 Inf];
t_window_ms = 200; % 200 ms window

roi_id = 2;

tuning_curve = generate_tuning_curve(roi_id,type_nam,trial_range,t_window_ms)
plot_tuning_curves(tuning_curve)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%