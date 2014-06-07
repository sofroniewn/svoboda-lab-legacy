load('S:\Janelia\wgnr\data\an217488\130723_Anm_217488_Run_1_parsed_data_fits.mat')
%%
load('S:\Janelia\wgnr\data\an216166\130727_Anm_216166_Run_1_parsed_data_fits.mat')
%%
figure(32)
clf(32)
hold on
h_c = hist(d.fits.single(2).r2,[0:.1:1]);
h_s = hist(d.fits.single(3).r2,[0:.1:1]);
h_j = hist(d.fits.joint.r2,[0:.1:1]);

plot([0:.1:1],h_s,'r');
plot([0:.1:1],h_c);
plot([0:.1:1],h_j,'k');

%% GOOD CORR
figure(32)
clf(32)
hold on
%hist(d.fits.single(2).estPrs(inds,1),40)
%hist(d.fits.joint.estPrs(inds,1),40)
scatter(d.fits.joint.estPrs(:,1),d.fits.single(2).r2)
set(gca,'clim',[0 .1])
ylim([0 1])
xlim([0 30])
%%
figure(32)
clf(32)
hold on
%hist(d.fits.single(2).estPrs(inds,1),40)
%hist(d.fits.joint.estPrs(inds,1),40)
scatter(d.fits.joint.estPrs(:,3),d.fits.single(3).r2)
set(gca,'clim',[0 .1])
ylim([0 1])
xlim([0 70])
%%
figure(1)
clf(1)
hold on
inds = d.xyz(:,3)==1;
%imagesc(d.workingImages{1});
colormap('jet')
%axes
scatter(d.xyz(inds,2),d.xyz(inds,1),100,d.fits.joint.estPrs(inds,1),'filled');
set(gca,'clim',[0 15])
%%
%std_dist = sqrt(d.fits.joint.estPrs(:,2).^2+d.fits.joint.estPrs(:,4).^2);
%inds = d.fits.joint.r2>.01 & std_dist < im_scale;
%inds = d.fits.joint.r2>.01 & std_dist < im_scale;
colormap('jet')

figure(32)
clf(32)
hold on
%hist(d.fits.single(2).estPrs(inds,1),40)
%hist(d.fits.joint.estPrs(inds,1),40)
%scatter(d.fits.single(2).estPrs(:,1),d.fits.single(3).estPrs(:,1),[],d.fits.single(2).r2)
scatter(d.fits.joint.estPrs(:,1),d.fits.joint.estPrs(:,3),[],d.fits.single(2).r2)
set(gca,'clim',[0 .5])
ylim([0 70])
xlim([0 30])
colormap('jet')
%%
figure(32)
clf(32)
hold on
%hist(d.fits.single(2).estPrs(inds,1),40)
%hist(d.fits.joint.estPrs(inds,1),40)
scatter(d.fits.joint.estPrs(:,3),d.fits.single(3).r2)
set(gca,'clim',[0 .1])
ylim([0 1])
xlim([0 70])
%%
figure(32)
clf(32)
hold on
%hist(d.fits.single(2).estPrs(inds,1),40)
%hist(d.fits.joint.estPrs(inds,1),40)
scatter(d.fits.single(2).estPrs(:,1),d.fits.single(2).r2)
set(gca,'clim',[0 .1])
ylim([0 1])
xlim([0 30])
%%
figure(32)
clf(32)
hold on
%hist(d.fits.single(2).estPrs(inds,1),40)
%hist(d.fits.joint.estPrs(inds,1),40)
scatter(d.fits.single(3).estPrs(:,1),d.fits.single(3).r2)
set(gca,'clim',[0 .1])
ylim([0 1])
xlim([0 70])
%%
figure
plot(d.cor_pos)
%%
plotMultFits(d,'single','corridor');
