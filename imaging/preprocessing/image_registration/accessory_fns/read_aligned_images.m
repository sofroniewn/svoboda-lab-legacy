function [keys values] = read_aligned_images(cur_file,iPlane,iChan,down_sample)

if down_sample > 1
	ds_filter = ones(down_sample,1)/down_sample;
end

[pathstr, base_name, ext] = fileparts(cur_file);
% define file name
replace_start = strfind(base_name,'main');
replace_end = replace_start+4;
% define data name
trial_str = base_name(replace_end:end);
base_name = base_name(1:replace_start-1);

type_name = 'summary';
file_name = [base_name type_name trial_str];
summary_file_name = fullfile(pathstr,type_name,[file_name '.mat']);
load(summary_file_name);
num_frame_file = im_summary.props.num_frames;
num_x_pixels = im_summary.props.width;
num_y_pixels = im_summary.props.height;
num_planes = im_summary.props.num_planes;

type_name = 'registered';
file_name = [base_name type_name trial_str '_p' sprintf('%02d',iPlane) '_c' sprintf('%02d',iChan) '.bin'];
registered_file_name = fullfile(pathstr,type_name,file_name);
fid = fopen(registered_file_name,'r');
key_values = fread(fid,[num_frame_file+4,num_x_pixels*num_y_pixels],'uint16');
fclose(fid);
keys = key_values(1:4,:);
if down_sample > 1;
    tmp = key_values(5:end,:);
    tmp = uint16(conv2(single(tmp),ds_filter,'same'));
    values = tmp(1:down_sample:end,:);
else
    values = key_values(5:end,:);
end