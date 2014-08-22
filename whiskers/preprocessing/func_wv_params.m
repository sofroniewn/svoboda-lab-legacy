function p = func_wv_params(base_dir,nLeft,nRight,overwrite)
%%
disp(['--------------------------------------------']);
disp(['EXTRACT WV PARAMS']);

save_path = fullfile(base_dir, 'vid_wv_info.mat');

if overwrite ~= 1 && exist(save_path) == 2
    load(save_path)
else
%%% Generate whisker vid information
xml_file_list = dir([base_dir '*.xml']);
xml_file_name = fullfile(base_dir, xml_file_list(1).name);
whisker_param_file = xmlread(xml_file_name);
fprintf([xml_file_list(1).name '\n']);

allListitems = whisker_param_file.getElementsByTagName('row');
thisListitem = allListitems.item(0);
thisList = thisListitem.getElementsByTagName('frame_rate');
thisElement = thisList.item(0);
frame_rate = str2num(char(thisElement.getFirstChild.getData));
thisList = thisListitem.getElementsByTagName('px2mm'); % frame rate
thisElement = thisList.item(0);
pix_per_mm = 1/str2num(char(thisElement.getFirstChild.getData)); % px2mm conversion
thisList = thisListitem.getElementsByTagName('face_parameter');
thisElement = thisList.item(0);
face_parameter = char(thisElement.getFirstChild.getData); % face_parameter
thisList = thisListitem.getElementsByTagName('number_of_whiskers');
thisElement = thisList.item(0);
number_of_whiskers = str2num(char(thisElement.getFirstChild.getData));  % number_of_whiskers

%face_parameter = 'bottom'; % overwrite
protract_dir = 'rightward';

disp(['     Number of whiskers = ' num2str(number_of_whiskers)])
disp(['     Face parameter is ' face_parameter])
disp(['     Protract direction is ' protract_dir])
disp(['     Frame rate (hz) =  ' num2str(frame_rate)])
disp(['     Pix per mm =  ' num2str(pix_per_mm)])

trajectory_nums = [0:(number_of_whiskers-1)];
poly_roi_lims = [25 80];
r_in_mm = 0.1;

vid_file_list = dir([base_dir '*.mp4']);
vid_file_num = ceil(numel(vid_file_list)/2);
vid_file_name = fullfile(base_dir, vid_file_list(vid_file_num).name);
vid_frame = 3;
vid_file = mmread(vid_file_name,vid_frame);

imagePixelDimsXY = [size(vid_file.frames.cdata,2) size(vid_file.frames.cdata,1)];
disp(['     Image size =  ' num2str(imagePixelDimsXY)])

    figure(232)
clf(232)
imshow(vid_file.frames.cdata)
set(gcf,'Position', [358   213   809   867]);
    face_mask_cords = ginput;

        midline = ginput;
        
p.base_dir = base_dir;
p.n_whiskers = number_of_whiskers;
p.trajectory_nums = trajectory_nums;
p.frame_rate = frame_rate;
p.pix_per_mm = pix_per_mm;
p.face_parameter = face_parameter;
p.protract_dir = protract_dir;
p.poly_roi_lims = poly_roi_lims;
p.r_in_mm = r_in_mm;
p.vid_file_name = vid_file_name;
p.vid_file = vid_file;
p.vid_frame = vid_frame;
p.imagePixelDimsXY = imagePixelDimsXY;
p.face_mask_cords = face_mask_cords;
p.midline = midline;
p.nLeft = nLeft;
p.nRight = nRight;
p.length_thresh = 60;

save_path = fullfile(base_dir, 'vid_wv_info.mat');
save(save_path,'p')
end

disp(['--------------------------------------------']);
