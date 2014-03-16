function [ax] = plot_slices(y_val,x_val,width,slice_num,im,im_rs)

im_scale = 1000;

slice_y = mean(im(y_val-width:y_val+width,:,slice_num));
slice_y_r = mean(im_rs(y_val-width:y_val+width,:,slice_num));
slice_x = squeeze(mean(im(:,x_val-width:x_val+width,slice_num),2));
slice_x_r = squeeze(mean(im_rs(:,x_val-width:x_val+width,slice_num),2));

slice_z = squeeze(mean(mean(im(y_val-width:y_val+width,x_val-width:x_val+width,:))));
slice_z_r = squeeze(mean(mean(im_rs(y_val-width:y_val+width,x_val-width:x_val+width,:))));

scale_factor_x = max(slice_x(50:end-50))/max(slice_x_r(50:end-50));
scale_factor_y = max(slice_y(50:end-50))/max(slice_y_r(50:end-50));
scale_factor_z = max(slice_z(10:end-10))/max(slice_z_r(10:end-10));


%scale_factor_x = 1;
%scale_factor_y = 1;
%scale_factor_z = 1;

slice_x_r = slice_x_r*scale_factor_x;
slice_y_r = slice_y_r*scale_factor_y;
slice_z_r = slice_z_r*scale_factor_z;


figure(1)
clf(1)
set(gcf,'Position',[100 80 3/2*size(im,2) size(im,2)])
set(gcf,'Color',[1 1 1])
ax = subplot(2,3,[1:2]);
set(ax,'Position',[0 .5 2/3*1 .5])
set(gca,'visible','off')
im_c = cat(2,im,im_rs);
imshow(im_c(:,:,slice_num)/im_scale)
hold on
plot([1 size(im_c,2)],[y_val y_val],'g','LineWidth',2)
plot([1 size(im_c,2)],[y_val y_val]+width,'g','LineWidth',1,'LineStyle','--')
plot([1 size(im_c,2)],[y_val y_val]-width,'g','LineWidth',1,'LineStyle','--')

plot([x_val x_val],[1 size(im_c,1)],'m','LineWidth',2)
plot([x_val x_val]+width,[1 size(im_c,1)],'m','LineWidth',1,'LineStyle','--')
plot([x_val x_val]-width,[1 size(im_c,1)],'m','LineWidth',1,'LineStyle','--')

plot([x_val x_val]+size(im_c,1),[1 size(im_c,1)],'m','LineWidth',2)
plot([x_val x_val]+width+size(im_c,1),[1 size(im_c,1)],'m','LineWidth',1,'LineStyle','--')
plot([x_val x_val]-width+size(im_c,1),[1 size(im_c,1)],'m','LineWidth',1,'LineStyle','--')
plot([25 25],[25 25],'.b','MarkerSize',40)
plot([25 25]+size(im_c,1),[25 25],'.r','MarkerSize',40)

plot(2*size(im_c,1)-100 +[1 512/60*10],[size(im_c,1) size(im_c,1)] - 20,'Color',[.99 .99 .99],'LineWidth',2)


ax2 = subplot(2,2,3);
set(ax2,'Position',[2/3 .5 2/3*.5 .5])
camroll(ax2,-90)
hold on
plot(slice_x,'b')
plot(slice_x_r,'r')
xlim([1 size(im_c,1)])
set(gca,'visible','off')

ax3 = subplot(2,2,4);
set(ax3,'Position',[0 0 2/3*.5 .5])
hold on
plot(slice_y,'b')
plot(slice_y_r,'r')
xlim([1 size(im_c,1)])
set(gca,'visible','off')


ax4 = subplot(2,2,4);
set(ax4,'Position',[2/3 0 2/3*.5 .5])
hold on
plot(slice_z,'b')
plot(slice_z_r,'r')
plot(length(slice_z_r)-12+[1 10],[min(slice_z) min(slice_z)]*.96,'Color',[0 0 0],'LineWidth',2)
xlim([1 size(im,3)])
ylim([min(slice_z)*.95 max(slice_z)*1.05])
set(gca,'visible','off')

 figure(2)
 clf(2)
 set(gcf,'position',[100         616        1046         190])
 im_c = cat(2,im,im_rs);
 im_zy = squeeze(im_c(y_val,:,:))';
 im_c = cat(1,im,im_rs);
 im_zx = squeeze(im_c(:,x_val,:))';

 im_z = cat(1,im_zy,im_scale*ones(20,size(im_zx,2)),im_zx);
 imshow(im_z/im_scale)
 hold on
 plot([1 size(im_z,2)],[slice_num slice_num],'c','LineWidth',2)
 plot([1 size(im_z,2)],20+size(im,3)+[slice_num slice_num],'c','LineWidth',2)
 plot([x_val x_val],[1 size(im,3)],'m','LineWidth',2)
 plot([x_val x_val]+width,[1 size(im,3)],'m','LineWidth',1,'LineStyle','--')
 plot([x_val x_val]-width,[1 size(im,3)],'m','LineWidth',1,'LineStyle','--')
 plot([x_val x_val]+size(im,1),[1 size(im,3)],'m','LineWidth',2)
 plot([x_val x_val]+width+size(im,1),[1 size(im,3)],'m','LineWidth',1,'LineStyle','--')
 plot([x_val x_val]-width+size(im,1),[1 size(im,3)],'m','LineWidth',1,'LineStyle','--')
 plot([y_val y_val],size(im,3)+20+[1 size(im,3)],'g','LineWidth',2)
 plot([y_val y_val]+width,size(im,3)+20+[1 size(im,3)],'g','LineWidth',1,'LineStyle','--')
 plot([y_val y_val]-width,size(im,3)+20+[1 size(im,3)],'g','LineWidth',1,'LineStyle','--')
 plot([y_val y_val]+size(im,1),size(im,3)+20+[1 size(im,3)],'g','LineWidth',2)
 plot([y_val y_val]+width+size(im,1),size(im,3)+20+[1 size(im,3)],'g','LineWidth',1,'LineStyle','--')
 plot([y_val y_val]-width+size(im,1),size(im,3)+20+[1 size(im,3)],'g','LineWidth',1,'LineStyle','--')

plot([10 10],[1 10]+5,'Color',[.99 .99 .99],'LineWidth',2)
plot(10 +[1 512/60*10],[45 45],'Color',[.99 .99 .99],'LineWidth',2)





axes(ax)
end