%% Spatial profile
% 930nm, 15% (7.5mW) - zoom 01-6

save_path = 'E:\wgnr\Calibration\Scim_calibration\Figures';
no_ring_im_base = 'an232221_2014_02_03_no_ring_';
ring_im_base = 'an232221_2014_02_03_14x5_ring_';


im = load_image([base_dir no_ring_im_base '001.tif']);
im_r = load_image([base_dir ring_im_base '001.tif']);



im = load_image(data_path);
%%
im_avg = mean(im,3);
max_im = max(max(im_avg));

im_avg = 100*im_avg/max_im;
fov_um_per_pixel = 736/512; %% at 1.6 zoom
%%

figure(80)
clf(80)
set(gcf,'Position',[680   350   941   748])
imagesc(512*[-fov_um_per_pixel/2 fov_um_per_pixel/2],512*[-fov_um_per_pixel/2 fov_um_per_pixel/2],im_avg)
colormap('jet')
axis equal
xlim([-360 360])
ylim([-360 360])
cbar = colorbar;
set(cbar,'ylim',[0 100])
set(cbar,'ytick',[0:20:100])
ylabel(cbar,'Percent of maximum','FontSize',18)

set(gca,'FontSize',18)
xlabel('X-postion in focal plane (um)','FontSize',18)
ylabel('Y-postion in focal plane (um)','FontSize',18)
title('Spatial uniformity 1.6 zoom','FontSize',18)

fig_name = [save_path '\spatial_profile_raw'];
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-dbmp',fig_name);
%%

F = fspecial('gaussian', [25 25], 7);
sm_im = filter2(F,im_avg);
sm_im = 100*sm_im/max(max(sm_im));
[C,h] = contour(flipdim(sm_im,1),[10:10:100]);
%%
figure(80)
clf(80)
set(gcf,'Position',[680   350   941   748])
imagesc(512*[-fov_um_per_pixel/2 fov_um_per_pixel/2],512*[-fov_um_per_pixel/2 fov_um_per_pixel/2],sm_im)
colormap('gray')
axis equal
xlim([-360 360])
ylim([-360 360])
cbar = colorbar;
set(cbar,'ylim',[0 100])
set(cbar,'ytick',[0:20:100])
ylabel(cbar,'Percent of maximum','FontSize',18)

set(gca,'FontSize',18)
xlabel('X-postion in focal plane (um)','FontSize',18)
ylabel('Y-postion in focal plane (um)','FontSize',18)
hold on
[X Y] = meshgrid(-512/2+.25:512/2-.25,-512/2+.25:512/2-.25);
X = fov_um_per_pixel*X;
Y = fov_um_per_pixel*Y;
[C,h] = contour(X,Y,sm_im,[10:10:90 95 100]);
set(h,'LineWidth',2)
set(h,'Color','k')
set(h,'ShowText','on','TextStep',get(h,'LevelStep')*.5)
title('Contour plot of spatial uniformity 1.6 zoom','FontSize',18)

fig_name = [save_path '\spatial_profile_contour'];
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-dbmp',fig_name);
%% 1x zoom
data_path = 'E:\wgnr\Calibration\Scim_calibration\Spatial_profile\2013_01_25\fluorescein_1_1_a_001.tif';
im_1 = load_image(data_path);
im_avg_1 = mean(im_1,3);
max_im_1 = max(max(im_avg_1));
im_avg_1 = 100*im_avg_1/max_im_1;
%%
figure(82)
clf(82)
imshow(im_avg_1,[0 100])
title('Spatial profile 1.0 zoom','FontSize',18)
fig_name = [save_path '\spatial_profile_1x_zoom'];
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-dbmp',fig_name);

%% FOV size
zoom = [1.6 2 2.5 3 3.5 4 5 7.1 10.2 19.6 28.3];
y_dist = [736 593 473 398 342 299 238 168 122 59 39];
x_dist = [660 522 428 353 309 271 212 150 104 55 37];

figure(80)
clf(80)
set(gcf,'Position',[208         378        1301         720])
hold on
%plot(percent_setting,power,'LineWidth',2,'Color','k')
%plot(no_pockels_percent_setting,no_pockels_power,'LineWidth',2,'Color','k')

h_p(1) = plot(zoom,y_dist,'LineWidth',3,'Marker','x','Markeredgecolor','b','LineStyle','none','MarkerSize',14);
h_p(2) = plot(zoom,x_dist,'LineWidth',3,'Marker','x','Markeredgecolor','g','LineStyle','none','MarkerSize',14);

xlim([0 30])
%ylim([0 60])
set(gca,'FontSize',18)
xlabel('Zoom on Scan Image','FontSize',18)
ylabel('FoV size (um)','FontSize',18)
title('FoV size measured based on visibility of beads','FontSize',18)
legend_handle = legend(h_p,'y axis','x axis');
set(legend_handle, 'Location', 'NorthEast')

fig_name = [save_path '\FOV_size'];
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-dbmp',fig_name);

%% Cross correlation approach
data_path = 'E:\wgnr\Calibration\Scim_calibration\FOV\2013_01_25\fov_xy_100_zoom_016_001.tif';
im_fov = load_image(data_path);
im_fov_orig = im_fov(:,:,4);
im_fov_100 = im_fov(:,:,end-4);
%%
figure(72)
imshow(im_fov_100/256)
%%
cc = normxcorr2(im_fov_orig,im_fov_100);
[max_c ind] = max(abs(cc(:)));
[xpeak ypeak] = ind2sub(size(cc),ind(1))
displacments = [ypeak - size(im_fov_orig,2),-(xpeak - size(im_fov_orig,1))];
fov_size = 100./displacments*512
fov_um_per_pixel = 736/512;
%fov_size = mean(fov_size)
%%
figure(72)
surf(cc)

