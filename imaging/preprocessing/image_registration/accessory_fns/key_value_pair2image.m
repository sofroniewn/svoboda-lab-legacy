function im_stack = key_value_pair2image(key_values,num_x_pixels,num_y_pixels)

tSize = size(key_values,1)-4;
im_stack = reshape(key_values(5:end,:),tSize,num_x_pixels,num_y_pixels);
im_stack = permute(im_stack,[2 3 1]);    	