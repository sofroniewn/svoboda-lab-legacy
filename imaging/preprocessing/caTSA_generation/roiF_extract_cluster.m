function [rawRoiData antiRoiFluoVec neuropilData] = roiF_extract_cluster(data_dir,file_num,roi_array_fname,roi_name,signalChannels,overwrite)


overwrite = str2num(overwrite);

cur_files = dir(fullfile(data_dir,'*_main_*.tif'));
cur_file = fullfile(data_dir,cur_files(str2num(file_num)).name);
[pathstr, base_name, ext] = fileparts(cur_files(str2num(file_num)).name);

replace_start = strfind(base_name,'main');
replace_end = replace_start+4;
trial_str = base_name(replace_end:end);
base_name = base_name(1:replace_start-1);

type_name = 'roi_data';
file_name = [base_name roi_name trial_str '.mat'];
save_roi_file = fullfile(data_dir,type_name,file_name);

if exist(save_roi_file) == 2 && overwrite == 0
    load(save_roi_file);
else
    type_name = 'roi_data';
    folder_name = fullfile(data_dir,type_name);
    if exist(folder_name) ~= 7
        mkdir(folder_name);
    end
    
    fprintf('\nExtract F from rois file num %s \n',file_num);
    signalChannels = str2num(signalChannels);
    
    ref_files = dir(fullfile(data_dir,'ref_images_*.mat'));
    load(fullfile(data_dir,ref_files(1).name));
    
    num_planes = ref.im_props.numPlanes;
    num_chan = ref.im_props.nchans;
    
    num_x_pixels = ref.im_props.width;
    num_y_pixels = ref.im_props.height;
    
    
    
    type_name = 'summary';
    file_name = [base_name type_name trial_str];
    summary_file_name = fullfile(data_dir,type_name,[file_name '.mat']);
    load(summary_file_name);
    num_frame_file = im_summary.props.num_frames;
    
    type_name = 'registered';
    im_aligned = cell(num_planes,num_chan);
    for iPlane = 1:num_planes
        for iChan = 1:num_chan
            file_name = [base_name type_name trial_str '_p' sprintf('%02d',iPlane) '_c' sprintf('%02d',iChan) '.bin'];
            registered_file_name = fullfile(data_dir,type_name,file_name);
            fid = fopen(registered_file_name,'r');
            key_values = fread(fid,[num_frame_file+4,num_x_pixels*num_y_pixels],'uint16');
            fclose(fid);
            im_aligned{iPlane,iChan} = key_value_pair2image(key_values,num_x_pixels,num_y_pixels);
        end
    end
    
    
    if ischar(roi_array_fname)
        [pathstr,name,ext] = fileparts(roi_array_fname);
        fname = fullfile(pathstr,['PROCESSED_' name '.mat']);
        load(fname);
    else
        processedRoi = roi_array_fname;
    end
    
    [rawRoiData_tmp antiRoiFluoVec_tmp neuropilData_tmp] = processRoiArray(processedRoi, im_aligned, signalChannels);
    % concatenate caTSA variables
    rawRoiData = [];
    antiRoiFluoVec = [];
    neuropilData = [];
    for ik = 1:num_planes
        rawRoiData = cat(1,rawRoiData,rawRoiData_tmp{ik});
        antiRoiFluoVec = cat(1,antiRoiFluoVec,antiRoiFluoVec_tmp{ik});
        neuropilData = cat(1,neuropilData,neuropilData_tmp{ik});
    end
    
    % save registered data
    fprintf('Saving roi data\n')
    save(save_roi_file,'rawRoiData','antiRoiFluoVec','neuropilData');
    
    fprintf('DONE\n');
end
end