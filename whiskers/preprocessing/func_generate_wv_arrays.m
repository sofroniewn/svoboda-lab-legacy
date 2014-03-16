function wl = func_generate_wv_arrays(p)
%%
disp(['--------------------------------------------']);
disp(['GENERATE WV ARRAYS']);

save_path = fullfile(p.base_dir, p.WTLA_name);

if p.overwrite_WTLA ~= 1 && exist(save_path) == 2
    disp(['LOAD WV ARRAYS']);
    load(save_path)
else
    
    Whisker.makeAllDirectory_WhiskerTrial(p.base_dir,p.trajectory_nums, ...
        'faceSideInImage',p.face_parameter,'framePeriodInSec',1/p.frame_rate,'protractionDirection', ...
        p.protract_dir,'pxPerMm',p.pix_per_mm,'imagePixelDimsXY',p.imagePixelDimsXY,'mouseName','9','sessionName','9'); %% 'mouseName',[],'sessionName',[]
    
    Whisker.makeAllDirectory_WhiskerSignalTrial(p.base_dir,'polyRoiInPix',p.poly_roi_lims,'polyFitsMask',p.face_mask_cords');
    
    Whisker.makeAllDirectory_WhiskerTrialLite(p.base_dir,'r_in_mm',p.r_in_mm);
    
    wl = Whisker.WhiskerTrialLiteArray(p.base_dir);
    
    save(save_path,'wl');
    
    fprintf('ARRAYS GENERATED\n');
end

disp(['--------------------------------------------']);