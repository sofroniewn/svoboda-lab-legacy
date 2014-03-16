%% Point Spread Function
% 200nm beads, 930nm - zoom 51-0


base_dir = '/Users/sofroniewn/Documents/svoboda_lab/LFS/Calibration/2014_02_03_beads/';

no_ring_im_base = 'an999999_2014_02_03_no_ring_';
ring_im_base = 'an999999_2014_02_03_14x5_ring_';


im_s = load_image([base_dir no_ring_im_base '001.tif']);
im_r = load_image([base_dir ring_im_base '001.tif']);



%%
im = im(320-40:320+40,50+80:360,20:end);

%%
z_micron_2_pixel = .2; 
x_micron_2_pixel = 26/512; %%fov_size(1)/512;
y_micron_2_pixel = 31/512; %%fov_size(2)/512;
pix2um = [y_micron_2_pixel x_micron_2_pixel z_micron_2_pixel]; % units microns to pixel
bead_coords = [242 234 68]'; %%%%360 116 26 [215 256 63] [215 256 63] [250 250 52]
[psf fbc] = psf_measure(double(im_s/50), pix2um, bead_coords)
im = im_s;

bead_coords = [260 320 64]'; %%%%360 116 26 [215 256 63] [215 256 63] [250 250 52]
[psf fbc] = psf_measure(double(im_r/5), pix2um, bead_coords)
im = im_r*4;

%%
%%
implay(im/500)
%%
figure(45)
hold on
plot(im(fbc(1),:,fbc(3)));
plot(im(:,fbc(2),fbc(3)),'k');
plot(squeeze(im(fbc(1),fbc(2),:)),'r');

%%
im_red = im(fbc(1)+[-50:50],fbc(2)+[-50:50],fbc(3));
figure(92)
clf(92)
set(gcf,'Position',[15  350 1606/2 748/2])
h_s1 = subplot(1,2,1)
imagesc(50*y_micron_2_pixel*[-1 1],50*x_micron_2_pixel*[-1 1],im_red,[0 300]);
colormap('gray')
axis equal
xlim([-2 2])
ylim([-2 2])

%set(gca,'ydir','reverse')
set(gca,'xtick',[-2:1:2])
set(gca,'ytick',[-2:1:2])
set(gca,'yticklabel',-[-2:1:2])

set(gca,'FontSize',18)
xlabel('X-postion in focal plane (um)','FontSize',18)
ylabel('Y-postion in focal plane (um)','FontSize',18)
title('200nm bead for PSF calculation','FontSize',18)

text(0.3,-1.85,'FWHM PSF','Color',[1 1 1],'FontSize',18)
text(0.3,-1.30,sprintf('x axis %.2f um \ny axis %.2f um \nz axis %.2f um',psf(1),psf(2),psf(3)),'Color',[1 1 1],'FontSize',18)

subplot(1,2,2)
%im_red = squeeze(im(250+[-50:50],239,49+[-30:30]));
im_red_2 = squeeze(im(fbc(1),fbc(2)+[-50:50],fbc(3)+[-15:15]));

imagesc(50*x_micron_2_pixel*[-1 1],15*z_micron_2_pixel*[-1 1],im_red_2',[0 300]);
colormap('gray')
xlim([-2 2])
ylim([-3 3])
%axis equal

%set(gca,'ydir','reverse')
set(gca,'xtick',[-2:1:2])
set(gca,'ytick',[-3:1:3])
set(gca,'yticklabel',-[-3:1:3])

set(gca,'FontSize',18)
xlabel('X-postion in focal plane (um)','FontSize',18)
ylabel('Z-postion in focal plane (um)','FontSize',18)
title('200nm bead for PSF calculation','FontSize',18)
%set(gca,'Position',get(h_s1,'Position') + [.5 0 0 0])

%set(gca,'PlotBoxAspectRatio',[1 1 1])
set(gca,'DataAspectRatio',[2 3 2])






fig_name = [save_path '\PSF_calc' date];
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-dbmp',fig_name);
%%
%%
im_red = im(fbc(1)+[-50:50],fbc(2)+[-50:50],fbc(3)+[-15:15]);
figure(92)
clf(92)
set(gcf,'Position',[15  350 1606 748])
h_s1 = subplot(1,3,2)
imagesc(50*y_micron_2_pixel*[-1 1],50*x_micron_2_pixel*[-1 1],im_red(:,:,16),[0 300]);
colormap('gray')
axis equal
xlim([-2 2])
ylim([-2 2])

%set(gca,'ydir','reverse')
set(gca,'xtick',[-2:1:2])
set(gca,'ytick',[-2:1:2])
set(gca,'yticklabel',-[-2:1:2])

set(gca,'FontSize',18)
xlabel('X-postion in focal plane (um)','FontSize',18)
ylabel('Y-postion in focal plane (um)','FontSize',18)
title('200nm bead for PSF calculation','FontSize',18)

h_s2 = subplot(1,3,1)
imagesc(50*y_micron_2_pixel*[-1 1],50*x_micron_2_pixel*[-1 1],im_red(:,:,16-10),[0 300]);
colormap('gray')
axis equal
xlim([-2 2])
ylim([-2 2])
set(gca,'FontSize',18)

%set(gca,'ydir','reverse')
set(gca,'xtick',[-2:1:2])
set(gca,'ytick',[-2:1:2])
set(gca,'yticklabel',-[-2:1:2])
xlabel('X-postion in focal plane (um)','FontSize',18)
ylabel('Y-postion in focal plane (um)','FontSize',18)
title('2.5um above bead','FontSize',18)

h_s3 = subplot(1,3,3)
imagesc(50*y_micron_2_pixel*[-1 1],50*x_micron_2_pixel*[-1 1],im_red(:,:,16+10),[0 300]);
colormap('gray')
axis equal
xlim([-2 2])
ylim([-2 2])

%set(gca,'ydir','reverse')
set(gca,'xtick',[-2:1:2])
set(gca,'ytick',[-2:1:2])
set(gca,'yticklabel',-[-2:1:2])
xlabel('X-postion in focal plane (um)','FontSize',18)
ylabel('Y-postion in focal plane (um)','FontSize',18)
title('200nm bead for PSF calculation','FontSize',18)
set(gca,'FontSize',18)
title('2.5um below bead','FontSize',18)

text(0.2,-1.85,'FWHM PSF','Color',[1 1 1],'FontSize',18)
text(0.2,-1.20,sprintf('x axis %.2f um \ny axis %.2f um \nz axis %.2f um',psf(1),psf(2),psf(3)),'Color',[1 1 1],'FontSize',18)

% subplot(1,2,2)
% %im_red = squeeze(im(250+[-50:50],239,49+[-30:30]));
% im_red_2 = squeeze(im(fbc(1),fbc(2)+[-50:50],fbc(3)+[-30:30]));
% 
% imagesc(50*x_micron_2_pixel*[-1 1],30*z_micron_2_pixel*[-1 1],im_red_2',[-20 236]);
% colormap('gray')
% xlim([-2 2])
% ylim([-4 4])
% %axis equal
% 
% %set(gca,'ydir','reverse')
% set(gca,'xtick',[-2:1:2])
% set(gca,'ytick',[-4:2:4])
% set(gca,'yticklabel',-[-4:2:4])
% 
% set(gca,'FontSize',18)
% xlabel('X-postion in focal plane (um)','FontSize',18)
% ylabel('Z-postion in focal plane (um)','FontSize',18)
% title('200nm bead for PSF calculation','FontSize',18)
% %set(gca,'Position',get(h_s1,'Position') + [.5 0 0 0])
% 
% %set(gca,'PlotBoxAspectRatio',[1 1 1])
% set(gca,'DataAspectRatio',[2 4 2])


fig_name = [save_path '\bead_stack' date];
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-dbmp',fig_name);
%%
data_path_FOV = 'E:\wgnr\Calibration\Scim_calibration\PSF\2013_02_10\fov_0x_0y_001.tif';
data_path_FOV_shift = 'E:\wgnr\Calibration\Scim_calibration\PSF\2013_02_10\fov_10x_10y_001.tif';
im_1 = load_image(data_path_FOV);
im_2 = load_image(data_path_FOV_shift);
%%
figure(72)
imshow(im_fov_orig/256)
%%

x_micron_2_pixel = 5/x_disp;
y_micron_2_pixel = 5/y_disp;
%%
cc = normxcorr2(im_2,im_1);
[max_c ind] = max(abs(cc(:)));
[xpeak ypeak] = ind2sub(size(cc),ind(1))
displacments = [ypeak - size(im_2,2),-(xpeak - size(im_2,1))];
fov_size = 10./displacments*size(im_2,2)
fov_um_per_pixel = 736/512;
%%
figure(72)
imshow(cc)
colormap('jet')