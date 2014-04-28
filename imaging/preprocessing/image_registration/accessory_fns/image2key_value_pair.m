function key_values = image2key_value_pair(im_stack,analyze_plane,num_plane,analyze_chan,num_chan)


y_pixels = size(im_stack,1);
x_pixels = size(im_stack,2);
tSize = size(im_stack,3)/num_plane/num_chan;
num_pixels = y_pixels*x_pixels;

% get the coordinates
[X Y] = meshgrid(1:x_pixels,1:y_pixels);

key_values = zeros(tSize+4,num_pixels,'uint16');

% parse the info
key_values(1,:) = X(:)';
key_values(2,:) = Y(:)';
key_values(3,:) = analyze_plane;
key_values(4,:) = analyze_chan;
im_tmp = im_stack(:,:,analyze_plane+(analyze_chan-1)*num_plane:analyze_chan*num_plane:end);
im_tmp = permute(im_tmp,[3 1 2]);    
im_tmp = reshape(im_tmp,tSize,num_pixels);
key_values(5:end,:) = im_tmp;
