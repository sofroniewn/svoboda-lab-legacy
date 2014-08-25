function wl_trial = func_ff_whisker_process(M,p)

MM = func_reclassify_measurements(M,p);

wl_trial.trajectoryIDs = p.trajectory_nums;
wl_trial.framePeriodInSec = 1/p.frame_rate;
wl_trial.pxPerMm = p.pix_per_mm;

wl_trial.time = cell(length(p.trajectory_nums),1);
wl_trial.theta = cell(length(p.trajectory_nums),1);
wl_trial.kappa = cell(length(p.trajectory_nums),1);

for ik = 1:length(p.trajectory_nums)
	wl_trial.time{ik} = MM(MM(:,1) == ik-1,2)/p.frame_rate;
	wl_trial.theta{ik} = MM(MM(:,1) == ik-1,6);
	wl_trial.kappa{ik} = MM(MM(:,1) == ik-1,7);
end