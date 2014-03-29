function save_im2text(im_align,im_summary,trial_data,analyze_chan,save_path)
%% CONVERT IMAGES TO TEXT FILE
% stimFolder - folder that contains the stim file
% stimName - name of the mat file containing the stim info
% xRng - array (in our case, [1,512])
% yRng - [1,512]
% thisZ - which plane we're doing


tSize = im_summary.props.num_frames;
num_pixels = im_summary.props.width*im_summary.props.height;

% get the coordinates
[X Y] = meshgrid(1:im_summary.props.width,1:im_summary.props.height);

dat = zeros(tSize,num_pixels*im_summary.props.num_planes,'uint16');
x = zeros(1,num_pixels*im_summary.props.num_planes,'uint16');
y = zeros(1,num_pixels*im_summary.props.num_planes,'uint16');
z = zeros(1,num_pixels*im_summary.props.num_planes,'uint16');

% parse the info
for iPlane = 1:im_summary.props.num_planes
    im_tmp = uint16(im_align{iPlane,analyze_chan});
    im_tmp = permute(im_tmp,[3 1 2]);    
    im_tmp = reshape(im_tmp,tSize,num_pixels);
    dat(:,(iPlane-1)*num_pixels+1:(iPlane)*num_pixels) = im_tmp;
    x((iPlane-1)*num_pixels+1:(iPlane)*num_pixels) = X(:)';
    y((iPlane-1)*num_pixels+1:(iPlane)*num_pixels) = Y(:)';
    z((iPlane-1)*num_pixels+1:(iPlane)*num_pixels) = iPlane;
end

% write the plane to text
f = fopen(save_path,'w');
fmt = repmat('%u ',1,tSize+2);
fprintf(f,[fmt,'%u\n'],[y;x;z;dat]);

% write behaviour to text
if isempty(trial_data) ~= 1
    trial_data = trial_data(:,12); % hack for including corridor position only
    tSize = size(trial_data,1);
    dSize = size(trial_data,2);
    z = repmat(999,1,dSize);
    x = repmat(1,1,dSize);
    y = 1:dSize;
    
    fmt = repmat('%.4f ',1,tSize+2);
    fprintf(f,[fmt,'%.4f\n'],[y;x;z;trial_data]);
end

% close file
fclose(f);

end
