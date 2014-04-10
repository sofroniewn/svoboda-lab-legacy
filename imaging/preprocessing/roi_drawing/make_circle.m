function mask = make_circle(im_width,im_height,centerW,centerH,radius)

[W,H] = meshgrid(1:im_width,1:im_height);
mask = sqrt((W-centerW).^2 + (H-centerH).^2) < radius;
