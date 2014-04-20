
fullpath = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/scanimage/an227254_2013_12_12_main_001.tif';

tic;
hdr = extern_scim_opentif_fast(fullpath, 'header');
toc

opt.data_type = 'uint16';

tic;
[im improps] = load_image(fullpath);
toc

tic;
[im improps] = load_image_fast(fullpath);
toc
tic;
[im improps] = load_image_fast(fullpath,opt);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global im_session;
align_chan = 1;
ij = 1;
base_name = '';
cur_file = fullpath;
ref = im_session.ref;

tic
[im im_aligned im_summary] = register_file(cur_file,base_name,ref,align_chan,ij);	
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	num_planes = ref.im_props.numPlanes;
	num_chan = ref.im_props.nchans;

	% load image
	[im_raw improps] = load_image(cur_file);
	num_frames = size(im_raw,3)/num_chan;

	post_fft = ref.post_fft;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		fast_reg_flag = 1

tic
	% compute shifts
	shifts_raw = zeros(num_frames,2);
	parfor ij = 1:num_frames
		plane = mod(ij-1,num_planes)+1;
		cur_im = im_raw(:,:,align_chan+(ij-1)*num_chan);
		ref_im = ref.post_fft{plane};
		[shifts_raw(ij,:) tmp] = register_image_fast(cur_im,ref_im);			
	end
toc

tic
	% compute shifts
	shifts_raw = zeros(num_frames,2);
	parfor ij = 1:num_frames
		plane = mod(ij-1,num_planes)+1;
		cur_im = im_raw(:,:,align_chan+(ij-1)*num_chan);
		shifts_raw(ij,:)= register_image_fast(cur_im,post_fft{plane});			
	end
toc

tic
B = arrayfun(@(x) func_shift_stack(x,im_raw,align_chan,num_chan,num_planes,post_fft),[1:num_frames]) 
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cur_im = im_raw(:,:,1);
cur_stack = im_raw(:,:,1:4:end);

figure
imshow(ref_im/500)

ref_im = ref.base_images{1};

tic
[corr_offset corr_2] = gcorr( cur_im, ref_im, 512);
toc

tic
[corr_offset corr_2] = gcorr_mod( cur_im, ref_im, 512);
toc

figure
imshow(corr_2/max(corr_2(:)))

ref_fft = fft2(ref_im);
B = fliplr(ref_im);
B = flipud(B);
B = fft2(B);

for ij = 1:size(cur_stack,3);
cur_im = cur_stack(:,:,ij);
tic
[corr_offset corr_2] = gcorr_mod( cur_im, ref_im, 512);
toc
corr_offset
tic
[corr_offset corr_2] = gcorr_mod_fast(cur_im, B);
toc
corr_offset
tic
output = dftregistration(fft2(cur_im),ref_fft,1);
toc
output(3:4)
tic
[corr_offset corr_2] = gcorr_fast(cur_im, post_fft{1}, 512);
toc
corr_offset
tic
[corr_offset corr_2] = gcorr( cur_im, ref_im, 512);
toc
corr_offset
display(num2str(ij))
end


fmt_s = imformats('tif');

tic
		imf = imfinfo(fullpath);
toc

im_index = 1;

tic
I = zeros(512,512,length(imf),'uint16');
for im_index = 1:length(imf)
I(:,:,im_index) = imread(fullpath,im_index);
end
toc
tic
I1 = zeros(512,512,length(imf),'uint16');
for im_index = 1:length(imf)
I1(:,:,im_index) = imread(fullpath,'tif',im_index);
end
toc
I = I - I1;
max(abs(I(:)))
tic
I1 = zeros(512,512,length(imf),'uint16');
for im_index = 1:length(imf)
I1(:,:,im_index) = imread_NJS(fullpath,'tif',im_index);
end
toc
I = I - I1;
max(abs(I(:)))
tic
I1 = zeros(512,512,length(imf),'uint16');
for im_index = 1:length(imf)
I1(:,:,im_index) = feval(fmt_s.read, fullpath, im_index);;
end
toc
I = I - I1;
max(abs(I(:)))
tic
I1 = zeros(512,512,length(imf),'uint16');
for im_index = 1:length(imf)
   TifLink.setDirectory(im_index);
	I1(:,:,im_index) = TifLink.read();
end
toc
I = I - I1;
max(abs(I(:)))
tic
I1 = zeros(512,512,length(imf),'uint16');
for im_index = 1:length(imf)
I1(:,:,im_index) = imread(fullpath, 'Info', imf,im_index);
end
toc
I = I - I1;
max(abs(I(:)))



TifLink = Tiff(fullpath, 'r');
for i=1:NumberImages
   TifLink.setDirectory(i);
   FinalImage(:,:,i)=TifLink.read();
end
TifLink.close();




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 cd('/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254')

 analyze_chan = 1;

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

tic
all_dat = [y;x;z;dat];
toc

%% TEXT WRITING
a = uint16(round(500*rand(74,1048576)));

tic;
f = fopen('test.txt','w');
fmt = repmat('%u ',1,tSize+2);
fprintf(f,[fmt,'%u\n'],all_dat);
toc

tic; save('test4.txt','all_dat'); toc

tic;
f = fopen('test6.bin','w');
fwrite(f,[all_dat],'uint16');
toc


tic;
f = fopen('test7.bin','wb');
fwrite(f,[all_dat],'uint16');
toc


fclose(f);
f = fopen('test6.bin','r');
A = fread(f,size(all_dat),'uint16');



tic;
f = fopen('test6.bin','w');
fwrite(f,[1 2 3 4;5 6 7 8;9 10 11 12],'uint16');
toc
fclose(f)

f = fopen('test6.bin','r');
A = fread(f,[3,4],'uint16');



tic;
f = fopen('test3.txt','w');
fmt = repmat('%u ',1,tSize+2);
for ij = 1:size(all_dat,2)
fprintf(f,[fmt,'%u\n'],all_dat(:,ij));
end
toc

tic; dlmwrite('test2.txt',all_dat,' '); toc
% Elapsed time is 2.239497 seconds.

for



tic; saveascii(all_dat,'test3.txt',0); toc
% Elapsed time is 0.474688 seconds.
all_dat_ascii = double(all_dat);
tic; save('test4.txt','all_dat_ascii','-ascii'); toc
% Elapsed time is 0.388379 seconds.

tic; writeTextFast(all_dat_ascii, 'test5.txt'); toc


test_dat = [1 2 3 101 102 103;4 5 6 104 105 106];

tic;
f = fopen('test9.bin','w');
fwrite(f,[test_dat],'uint16');
toc
fclose(f)





