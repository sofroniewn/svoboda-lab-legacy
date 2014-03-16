% power vs aperture size

aperture_size = [22.5 22 20 18 16.5 14.5];
power = [46.7 46.6 46.7 46.4 45.7 43.1];

transmission = power/power(1)*100

spot_diam = [19 19 19 18.5 18 17];
dist = 22;

spot_diam = [11 11 11 10.5 8.5 7.5];
dist = 13;


WD = 3;
n = 1.33;
NA = n*sin(atan(spot_diam/2/(dist-WD)))

figure(1); clf(1);
plot(aperture_size,power,'LineWidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
base_dir = '/Users/sofroniewn/Documents/svoboda_lab/LFS/Calibration/2014_02_02/scanimage/';

no_ring_im_base = 'an232221_2014_02_02_no_ring_';
ring_im_base = 'an232221_2014_02_02_14x5_ring_';


im = load_image([base_dir no_ring_im_base '010.tif']);
im_r = load_image([base_dir ring_im_base '010.tif']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COMPUTE GLOBAL CROSS CORR TO ALGIN in XYZ
cut_val = 30;
im = im(cut_val:end-cut_val,cut_val:end-cut_val,:);
im_r = im_r(cut_val:end-cut_val,cut_val:end-cut_val,:);
[optimizer, metric] = imregconfig('monomodal')
tform = imregtform(im_r, im, 'translation', optimizer, metric);
tform = round(tform.T);



im_rs = NaN(size(im_r));
if tform(4,3) > 0
	for ij = 1:size(im_r,3) - tform(4,3)
	im_rs(:,:,ij+tform(4,3)) = func_im_shift(im_r(:,:,ij+tform(4,3)),-[tform(4,2) tform(4,1)]);
	end
	else
	for ij = 1:size(im_r,3) + tform(4,3)
	im_rs(:,:,ij) = func_im_shift(im_r(:,:,ij)-tform(4,3),-[tform(4,2) tform(4,1)]);	
	end
end

im_overlay = repmat(im(:,:,25),[1, 1, 3]);
im_overlay(:,:,3) = im_rs(:,:,25);

figure(4)
clf(4)
imshow(im_overlay/im_scale)
%slope_im = regress(im_rs(1:10:end)',im(1:10:end)');
%im_rs = im_rs/slope_im;

%%
figure(3)
clf(3)
plot(im(1:10:end),im_rs(1:10:end),'.r')
grid on
axis equal
%%


figure(1)
clf(1)
imshow(im_overlay/im_scale)

%% XYZ SLICE
width = 20;
num_slice = 25;
ax = plot_slices(200,250,width,num_slice,im,im_rs);
for ij = 1:10
	[x y] = ginput(1);
	if x > size(im,1)
		x = x - size(im,1);
	end
	ax = plot_slices(round(y),round(x),width,num_slice,im,im_rs);
end
