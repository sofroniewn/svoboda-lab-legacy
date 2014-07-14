function plot_tuning_curves_2D(fig_id,tuning_curve)

figure(fig_id)
clf(fig_id)
set(gcf,'Position',[1034 634 406 172])
subplot(1,2,1)
hold on
h = imagesc(tuning_curve.x_vals,tuning_curve.y_vals,tuning_curve.means);
set(gca,'Color',[0.8 0.8 0.8])
set(h, 'AlphaData', ~isnan(tuning_curve.means))

plot([floor(min(tuning_curve.x_vals)) floor(min(tuning_curve.x_vals))],[floor(min(tuning_curve.y_vals)) ceil(max(tuning_curve.y_vals))],'k','LineWidth',2)
plot([ceil(max(tuning_curve.x_vals)) ceil(max(tuning_curve.x_vals))],[floor(min(tuning_curve.y_vals)) ceil(max(tuning_curve.y_vals))],'k','LineWidth',2)
plot([floor(min(tuning_curve.x_vals)) ceil(max(tuning_curve.x_vals))],[floor(min(tuning_curve.y_vals)) floor(min(tuning_curve.y_vals))],'k','LineWidth',2)
plot([floor(min(tuning_curve.x_vals)) ceil(max(tuning_curve.x_vals))],[ceil(max(tuning_curve.y_vals)) ceil(max(tuning_curve.y_vals))],'k','LineWidth',2)

xlabel(tuning_curve.x_label)
ylabel(tuning_curve.y_label)
xlim([floor(min(tuning_curve.x_vals)) ceil(max(tuning_curve.x_vals))])
ylim([floor(min(tuning_curve.y_vals)) ceil(max(tuning_curve.y_vals))])
set(gca,'ytick',[5*floor(min(tuning_curve.y_vals)/5):5:5*ceil(max(tuning_curve.y_vals)/5)])
set(gca,'xtick',[5*floor(min(tuning_curve.x_vals)/5):5:5*ceil(max(tuning_curve.x_vals)/5)])

set(gca,'layer','top')
%hcb = colorbar;
%set(get(hcb,'ylabel'),'String','dff')
title_str = tuning_curve.title;
title(title_str)

subplot(1,2,2)
hold on
if ~isempty(tuning_curve.model_fit)
h = imagesc(tuning_curve.x_fit_vals,tuning_curve.y_fit_vals,tuning_curve.model_fit.curve);

plot([floor(min(tuning_curve.x_vals)) floor(min(tuning_curve.x_vals))],[floor(min(tuning_curve.y_vals)) ceil(max(tuning_curve.y_vals))],'k','LineWidth',2)
plot([ceil(max(tuning_curve.x_vals)) ceil(max(tuning_curve.x_vals))],[floor(min(tuning_curve.y_vals)) ceil(max(tuning_curve.y_vals))],'k','LineWidth',2)
plot([floor(min(tuning_curve.x_vals)) ceil(max(tuning_curve.x_vals))],[floor(min(tuning_curve.y_vals)) floor(min(tuning_curve.y_vals))],'k','LineWidth',2)
plot([floor(min(tuning_curve.x_vals)) ceil(max(tuning_curve.x_vals))],[ceil(max(tuning_curve.y_vals)) ceil(max(tuning_curve.y_vals))],'k','LineWidth',2)

xlabel(tuning_curve.x_label)
ylabel(tuning_curve.y_label)
xlim([floor(min(tuning_curve.x_vals)) ceil(max(tuning_curve.x_vals))])
ylim([floor(min(tuning_curve.y_vals)) ceil(max(tuning_curve.y_vals))])
set(gca,'ytick',[5*floor(min(tuning_curve.y_vals)/5):5:5*ceil(max(tuning_curve.y_vals)/5)])
set(gca,'xtick',[5*floor(min(tuning_curve.x_vals)/5):5:5*ceil(max(tuning_curve.x_vals)/5)])

set(gca,'layer','top')
%hcb = colorbar;
%set(get(hcb,'ylabel'),'String','dff')
title_str = tuning_curve.title;
title(title_str)
end
