function save_registered_data_frame(data_dir,base_name,trial_str,prev_frame_num,im_stack,num_planes,num_chan,trial_data)

% create new folder for images from this trial
type_name = 'registered_im';
new_dir = fullfile(data_dir,type_name,['images' trial_str]);
if exist(new_dir) ~=7
	mkdir(new_dir)
end
% 		

y_pixels = size(im_stack,1);
x_pixels = size(im_stack,2);
num_block = num_planes*num_chan;
tSize = size(im_stack,3)/num_block;
num_pixels = y_pixels*x_pixels;

% save new images 
for ij = 1:tSize
	im_tmp = im_stack(:,:,1+(ij-1)*num_block:ij*num_block);
	im_tmp = im_tmp(:);
	frame_num = ij + prev_frame_num;
	file_name = ['images_' sprintf('%06d',frame_num)];
	registered_file_name = fullfile(new_dir,[file_name '.bin']);	
 		fid = fopen(registered_file_name,'w');
 		fwrite(fid,im_tmp,'uint16');
 		fclose(fid);
end


 % write behaviour data
 if ~isempty(trial_data)
    type_name = 'registered_bv';
	new_dir = fullfile(data_dir,type_name,['behaviour' trial_str]);
	if exist(new_dir) ~=7
		mkdir(new_dir)
	end
 	
  	trial_data = round(trial_data(:,[12 7])/80*4096); % hack for including corridor position only
  	tSize = size(trial_data,1);
	% save new images 
	for ij = 1:tSize
		bv_tmp = trial_data(ij,:);
		frame_num = ij + prev_frame_num;
		file_name = ['behaviour_' sprintf('%06d',frame_num)];
		registered_file_name = fullfile(new_dir,[file_name '.bin']);	
 		fid = fopen(registered_file_name,'w');
 		fwrite(fid,bv_tmp,'uint16');
 		fclose(fid);
	end
end
 

 