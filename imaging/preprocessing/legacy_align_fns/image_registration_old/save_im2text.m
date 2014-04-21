function [im_cords dat] = save_im2text(im_aligned,trial_data,analyze_chan,save_path,save_on)
%% CONVERT IMAGES TO TEXT FILE
% stimFolder - folder that contains the stim file
% stimName - name of the mat file containing the stim info
% xRng - array (in our case, [1,512])
% yRng - [1,512]
% thisZ - which plane we're doing


tSize = size(im_aligned{1,1},3);
num_planes = size(im_aligned,1);
num_pixels = size(im_aligned{1,1},1)*size(im_aligned{1,1},2);

% get the coordinates
[X Y] = meshgrid(1:size(im_aligned{1,1},2),1:size(im_aligned{1,1},1));

dat = zeros(tSize,num_pixels*num_planes,'uint16');
x = zeros(1,num_pixels*num_planes,'uint16');
y = zeros(1,num_pixels*num_planes,'uint16');
z = zeros(1,num_pixels*num_planes,'uint16');

% parse the info
for iPlane = 1:num_planes
    im_tmp = im_aligned{iPlane,analyze_chan};
    im_tmp = permute(im_tmp,[3 1 2]);    
    im_tmp = reshape(im_tmp,tSize,num_pixels);
    dat(:,(iPlane-1)*num_pixels+1:(iPlane)*num_pixels) = im_tmp;
    x((iPlane-1)*num_pixels+1:(iPlane)*num_pixels) = X(:)';
    y((iPlane-1)*num_pixels+1:(iPlane)*num_pixels) = Y(:)';
    z((iPlane-1)*num_pixels+1:(iPlane)*num_pixels) = iPlane;
end

im_cords.x = x;
im_cords.y = x;
im_cords.z = z;

if save_on == 1
    % write the plane to text
    f = fopen(save_path,'w');
    fmt = repmat('%u ',1,tSize+2);
    fprintf(f,[fmt,'%u\n'],[y;x;z;dat]);
end

bv_cords = [];

% write behaviour to text
if isempty(trial_data) ~= 1
    trial_data = trial_data(:,12); % hack for including corridor position only
    tSize = size(trial_data,1);
    dSize = size(trial_data,2);
    z = repmat(999,1,dSize);
    x = repmat(1,1,dSize);
    y = 1:dSize;

   if save_on == 1
        fmt = repmat('%.4f ',1,tSize+2);
        fprintf(f,[fmt,'%.4f\n'],[y;x;z;trial_data]);
    end
end

if save_on == 1
    % close file
    fclose(f);
end

end
