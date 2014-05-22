
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
trial_num = 1;
base_name = '';
cur_file = fullpath;
ref = im_session.ref;

tic
[im im_aligned im_summary] = register_file(cur_file,base_name,ref,align_chan,ij);	
toc



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % load images
    tic;
    opt.data_type = 'uint16';
    [im_raw improps] = load_image_fast(fullpath,opt);
    %toc

    % register files 
    %tic;
    [im_shifted shifts] = register_file(im_raw,ref);
	%toc


    % summarize images
    %tic;
    im_summary = sumarize_images(improps,im_raw,im_shifted,shifts,trial_num);
	toc

	
analyze_chan = 1;
analyze_plane = 1;
num_planes = improps.numPlanes;
num_chan = improps.nchans;


key_values = image2key_value_pair(im_shifted,analyze_plane,num_planes,analyze_chan,num_chan);


base_name = 'an227254_2013_12_12_main';
trial_str = '_001'
data_dir = im_session.basic_info.data_dir;

tic
save_registered_data(data_dir,base_name,im_shifted,num_planes,num_chan)
toc

text_dir = '.'
down_sample = 8;
trial_data = [];

save_registered_on = 0;
save_text_on = 1;
save_registered_data(data_dir,base_name,trial_str,im_shifted,num_planes,num_chan,text_dir,down_sample,trial_data,save_registered_on,save_text_on);

%%% 
N = round(123*rand)+1;
n = round(12*rand)+1;

N =102
n =10
AA = [1:N];
AA = AA(1:n:end);
length(AA) - ceil(N/n)


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
all_dat = uint16(round(500*rand(74,1048576)))+1; % 10 seconds of 512 x 512 x 4 data
%%% 155 MB - takes 20 s with fprintf - takes 150ms with fwrite

all_dat = uint16(round(500*rand(30,70))); % 10 seconds of 512 x 512 x 4 data


tic;
f = fopen('test.txt','W');
fmt = repmat('%u ',1,size(all_dat,1)-1);
fprintf(f,[fmt,'%u\n'],all_dat);
toc




tic;
fmt = repmat('%u ',1,size(all_dat,1)-1);
aa = sprintf([fmt,'%u\n'],all_dat);
f = fopen('test9.txt','w');
fprintf(f,['%s'],aa);
toc

all_dat_R = all_dat(:);

C = char.empty(0,7);

tic;
fmt = repmat('%u ',1,size(all_dat,1)-1);
fmt = [fmt,'%u\n'];
f = fopen('test99.txt','w');
aa = char(zeros(1,293457260));
start_ind = 0;
for ij = 1:size(all_dat,2)
	bb = sprintf(fmt,all_dat(:,ij));
	aa(start_ind+1:start_ind+length(bb));
	start_ind = start_ind + length(bb);
end
fprintf(f,['%s'],aa);
toc

dim = 4096;
C = cell(1,dim);
for ij = 1:dim
%	C{ij} = [num2str(ij) ' '];
	C{ij} = [num2str(ij)];
end

tic
all_dat_R = all_dat(:);
all_dat_str = C(all_dat_R);
toc
[all_dat_str{:}];

 
tic
qq = [pp{:}];
toc
tic
qq = CStr2String(all_dat_str,' ');
toc


tic;
fmt = repmat('%s',1,size(all_dat_str,1)-1);
aa = sprintf([fmt,'%s\n'],all_dat_str);
f = fopen('test9.txt','w');
fprintf(f,['%s'],aa);
toc

bb = all_dat_str(:);


tic;
writeTextFast(double(all_dat),'test.txt')
toc

tic;
writeIntToText(all_dat,'test2.txt')
toc


tic; save('test4.txt','all_dat'); toc

tic;
f = fopen('test6.bin','w');
fwrite(f,[all_dat],'uint16');
toc


all_dat_2 = double(all_dat);

tic; writeTextFast(all_dat,'test5.txt'); toc

tic;t = sprintf('%d\n',foo);toc
Elapsed time is 14.609328 seconds.
tic;fprintf(f,t);toc
Elapsed time is 2.059919 seconds.






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







