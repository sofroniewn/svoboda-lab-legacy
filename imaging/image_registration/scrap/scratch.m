% Load in images
base_im_path = '/Users/sofroniewn/Documents/DATA/imaging_ex/an227254_2013_12_12_main_011.tif';
[im im_props] = load_image(base_im_path);
im_plane = im(:,:,2:4:end);
range = [1+512/4*1:512/4*3];
im_target = mean(im_plane(range,range,1:10),3);

base_im_path = '/Users/sofroniewn/Documents/DATA/imaging_ex/testing/anm237331_2014_01_30_testing_001.tif';
[im im_props] = load_image(base_im_path);
im_plane = im(:,:,10:2000);
range = 1:256;
im_target = mean(im_plane(range,range,1:20),3);



im_stack = im_plane(range,range,:);
fft_target = func_im_preprocess_target(im_target);

tic;
[im_register corr_offset] = func_register_stack(im_stack,fft_target);
toc;
im_comb_MOD =  cat(2, im_stack, zeros(size(im_stack,2),3,size(im_stack,3)), im_register);
im_comb_MOD(isnan(im_comb_MOD)) = 0;

figure(1)
clf(1)
imshow(mat2gray(mean(im_comb_MOD,3)))

im_comb_MOD_sm = convn(im_comb_MOD,ones(1,1,10)/10,'same');
im_comb_MOD_sm = im_comb_MOD_sm(:,:,10:5:end-10);
%%
implay(mat2gray(im_comb_MOD_sm))

%%
figure(1)
hist(im_plane(:))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start_trial = 0;
align_chan = 1;

save_opts.overwrite = 0;
save_opts.shifts = 1;
save_opts.tiffs = 1;
save_opts.text = 1;

register_directory(start_trial,align_chan,save_opts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global im_session;
align_chan = 1;

ij = 1;
files_for_reg = im_session.basic_info.cur_files;
num_files = numel(files_for_reg);
base_name = [im_session.basic_info.anm_str '_' im_session.basic_info.date_str '_' im_session.basic_info.run_str '_'];
cur_file = fullfile(im_session.basic_info.data_dir,files_for_reg(ij).name);
tic
[im im_align im_summary] = register_file(cur_file,base_name,im_session.ref,align_chan,ij);
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

analyze_chan = 1;
save_path = './example.txt';
save_im2text(im_align,im_summary,analyze_chan,save_path);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tSize = 5*8;
num_pixels = 512*512*4;
dat = uint16(round(1000*rand(tSize,num_pixels)));
x = zeros(1,num_pixels,'uint16');
y = zeros(1,num_pixels,'uint16')+1;
z = zeros(1,num_pixels,'uint16')+2;
dat = [y;x;z;dat];

save_path = './text_ex.txt';

f = fopen(save_path,'w');
fmt = repmat('%u ',1,tSize+2);
tic; fprintf(f,[fmt,'%u\n'],dat); toc

dat2 = double(dat);
tic; save('test2.txt','dat2','-ascii'); toc

tic; saveascii(dat,'test2.txt',0); toc

tic; writeTextFast(dat, 'test.txt'); toc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


mat = round(1000*rand(94,512*512*4));
fmt = repmat('%u ',1,size(mat,1)-1);
fmt = [fmt,'%u\n'];

f = fopen('test4.txt','w');
tic; writeTextFast(mat, 'test.txt'); toc;
tic; saveascii(mat,'test2.txt',0); toc
tic; save('test3.txt','mat','-ascii'); toc
tic; dlmwrite('test5.txt',mat,' '); toc
tic; fprintf(f,fmt,mat); toc
fclose(f);

tic; fprintf(f,fmt,mat); toc



mat = round(1000*rand(94,512*512*4));
fmt = repmat('%u ',1,size(mat,1)-1);
fmt = [fmt,'%u\n'];

f = fopen('test4.txt','w');
tic; saveascii(mat,'test2.txt',0); toc
tic; save('test3.txt','mat','-ascii'); toc
tic; dlmwrite('test5.txt',mat,' '); toc
tic; fprintf(f,fmt,mat); toc
fclose(f);

tic; fprintf(f,fmt,mat); toc

tic
for ij=1:94
 writeTextFast(mat(ij,:), 'test.txt');
end
toc
%tic; save('test3.txt','mat','-ascii'); toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


nPlane = 2;
im_comb_MOD =  cat(2, im{nPlane}, im_adj{nPlane});
figure(1)
clf(1)
imshow(mat2gray(mean(im_comb_MOD,3)))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nPlane = 2;
nChan = 1;

im_comb_MOD =  cat(2, squeeze(im_session.reg.raw_mean(:,:,nPlane,nChan,:)), squeeze(im_session.reg.align_mean(:,:,nPlane,nChan,:)));
figure(1)
clf(1)
imshow(mat2gray(mean(im_comb_MOD,3)))
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For legacy files (i.e. L4 data where triggering was at end of iti) needed to correct !!!!!   
ind = unique(session.trial_info.trial_start);
num_files = numel(session.data);
for ij = 1:num_files-1
    session.data{ij}.trial_matrix = [session.data{ij}.trial_matrix(:,ind:end) session.data{ij+1}.trial_matrix(:,1:ind-1)];
    session.data{ij}.processed_matrix = [session.data{ij}.processed_matrix(:,ind:end) session.data{ij+1}.processed_matrix(:,1:ind-1)];
    session.trial_info.trial_start(ij) = find(session.data{ij}.trial_matrix(9,:)==1,1,'first');
end
% for ij = 1:num_files-1
%   session.trial_info.scim_num_trigs(ij) = length(find(session.data{ij}.processed_matrix(6,:)));
%   if ij > 1 && session.trial_info.scim_logging(ij-1) == 1;
%       session.trial_info.scim_cum_trigs(ij) = session.trial_info.scim_cum_trigs(ij-1) + session.trial_info.scim_num_trigs(ij-1);
%   else
%       session.trial_info.scim_cum_trigs(ij) = 0;
%   end 
% end

cur_trial = 1;
load('/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/scanimage/summary/anm_0227254_2013_12_12_run_02_summary_001.mat')
trial_data = session.data{cur_trial};

prev_num_trigs = 0;
extra_frame = 0;

num_planes = im_summary.props.num_planes; % >> im_session.ref.im_props.numPlanes;
num_frames_scim = im_summary.props.num_frames; % >> im_session.reg.nFrames(cur_trial);
first_trig_scim = im_summary.props.firstFrame; % >> im_session.reg.startFrame(cur_trial);

scim_trig_vect = trial_data.processed_matrix(6,:);
[parsed_scim_trig_vect prev_num_trigs extra_frame] = synch_behaviour_scim(scim_trig_vect,prev_num_trigs,extra_frame,num_planes,num_frames_scim,first_trig_scim)
trial_data.processed_matrix(7,:) = parsed_scim_trig_vect;



%%

 figure(1)
 clf(1)
 hold on
 plot(scim_trig_vect,'b')
 plot(parsed_scim_trig_vect,'r')

% plot(session.data{trial_num}.trial_matrix(9,:),'r','LineWidth',2)
% plot(session.data{trial_num}.processed_matrix(7,:),'.g')
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% offline behaviour mode
% read in entire behaviour session and extract trial data from that
%
% online behaviour mode
% recieve trial data from another matlab via TCP/IP









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)
clf(4)
imshow(mat2gray(im_target)*2)
nroi = 7;
for i=1:nroi
bw = impoly;
inds{i} = bw.createMask;
end
%%
se3 = strel('disk',5);
%mask_roi = roi_ex3.createMask;
tot_catsa = zeros(3,size(im,3));
for ik = 1:100
    ik
%mask_roi = false(512,512);
start_ind_x = ceil(rand*410)+50;
start_ind_y = ceil(rand*410)+50;
mask_roi(start_ind_y:start_ind_y+5,start_ind_x:start_ind_x+5) = 1;
%mask_roi = inds{ik};
ca_ts = zeros(3,size(im,3));
for ij = 1:size(im,3)
    tmp = im_adj(:,:,ij);
    ca_ts(1,ij) = mean(tmp(mask_roi>0));
    tmp = im(:,:,ij);
    ca_ts(2,ij) = mean(tmp(mask_roi>0));
    tmp = im_PERON(:,:,ij);
    ca_ts(3,ij) = mean(tmp(mask_roi>0));
end

mask_roi_boundary = imdilate(mask_roi,se3);
mask_roi = ~mask_roi & mask_roi_boundary; 
ca_ts_boundary = zeros(3,size(im,3));
for ij = 1:size(im,3)
    tmp = im_adj(:,:,ij);
    ca_ts_boundary(1,ij) = mean(tmp(mask_roi>0));
    tmp = im(:,:,ij);
    ca_ts_boundary(2,ij) = mean(tmp(mask_roi>0));
    tmp = im_PERON(:,:,ij);
    ca_ts_boundary(3,ij) = mean(tmp(mask_roi>0));
end


if any(isnan(ca_ts))
    eee
end

F0 = mean(mean(ca_ts(:,1:5)));
ca_ts = (ca_ts - F0)/(F0+.1);
%ca_ts = abs(ca_ts);

F0 = mean(mean(ca_ts_boundary(:,1:5)));
ca_ts_boundary = (ca_ts_boundary - F0)/(F0+.1);
%ca_ts_boundary = abs(ca_ts_boundary);

tot_catsa = tot_catsa + abs(ca_ts - ca_ts_boundary);
end

tot_catsa = tot_catsa/100;


avg_catsa = squeeze(mean(mean(im)));
F0 = mean(avg_catsa(1:5));
avg_catsa = (avg_catsa - F0)/F0;

%%
figure(4)
clf(4)
hold on
plot(tot_catsa(2,:)','k','LineWidth',2)
plot(tot_catsa(1,:)','b','LineWidth',1.5)
plot(tot_catsa(3,:)','g','LineWidth',1.5)

plot(corr_offset/50)
%%
figure(4)
clf(4)
hold on
plot(ca_ts(2,:)','k','LineWidth',2)
plot(ca_ts(1,:)','b','LineWidth',1.5)
plot(ca_ts(3,:)','g','LineWidth',1.5)

plot(corr_offset/10)

%%
figure(3)
clf(3)
imshow(mat2gray(im_target)*2)
h = impoly;
%%
figure(3)
clf(3)
imshow(mat2gray(mean(DFF,3))*2)
%%
implay(mat2gray(DFF)*2)

%%
im_comb_MOD_red = impyramid(im_comb_MOD,'reduce');

F0_frame = mean(im_comb_MOD_red(:,:,:),3);
F0 = repmat(F0_frame,[1,1,size(im_comb_MOD_red,3)]);
DFF = (im_comb_MOD_red - F0)./(F0);
DFF(DFF<-5) = -5;
DFF(DFF>10) = 10;

%%

figure(3)
clf(3) 
hist(DFF(:),im_scale)
%hist(DFF(:),im_scale)
%%
F0_frame = mean(im,3);
F0 = repmat(F0_frame,[1,1,size(im,3)]);
%%
figure(4)
clf(4)
hist(DFF(:),im_scale)
%%
figure(4)
clf(4)
plot(squeeze(im(200,200:220,:))')
%%
figure
hist(im(:),im_scale)
%%
figure
hist(im_PERON(:),im_scale)

%%
tic; 
A = impyramid(im(:,:,ij),'reduce');
toc



