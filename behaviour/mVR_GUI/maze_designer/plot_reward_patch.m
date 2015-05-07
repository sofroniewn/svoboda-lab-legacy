function [h tform] = plot_reward_patch(x_cords,y_cords,scale)

% generate stipes
[gclipped xdata ydata tform] = make_reward_patch(x_cords,y_cords,scale,0,[]);

h = imagesc(gclipped,'xdata',xdata, 'ydata',ydata);
set(h,'AlphaData',~isnan(gclipped))
set(gca,'ydir','normal');
axis normal
set(gca,'Color',[0 0 0])
colormap('gray')