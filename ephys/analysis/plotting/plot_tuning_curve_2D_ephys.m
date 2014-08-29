function plot_tuning_curve_2D_ephys(fig_props,tuning_curve)

colormap('gray')

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

h = imagesc(tuning_curve.regressor_obj.x_vals,tuning_curve.regressor_obj.y_vals,tuning_curve.means);
%h = imagesc(tuning_curve.regressor_obj.x_vals,tuning_curve.regressor_obj.y_vals,conv2(tuning_curve.means,ones(3,2)/6,'same'));
set(gca,'Color',[0.8 0.8 0.8])
set(h, 'AlphaData', ~isnan(tuning_curve.means))

% plot([floor(min(tuning_curve.x_vals)) floor(min(tuning_curve.x_vals))],[floor(min(tuning_curve.y_vals)) ceil(max(tuning_curve.y_vals))],'k','LineWidth',2)
% plot([ceil(max(tuning_curve.x_vals)) ceil(max(tuning_curve.x_vals))],[floor(min(tuning_curve.y_vals)) ceil(max(tuning_curve.y_vals))],'k','LineWidth',2)
% plot([floor(min(tuning_curve.x_vals)) ceil(max(tuning_curve.x_vals))],[floor(min(tuning_curve.y_vals)) floor(min(tuning_curve.y_vals))],'k','LineWidth',2)
% plot([floor(min(tuning_curve.x_vals)) ceil(max(tuning_curve.x_vals))],[ceil(max(tuning_curve.y_vals)) ceil(max(tuning_curve.y_vals))],'k','LineWidth',2)

xlabel(tuning_curve.regressor_obj.x_label)
ylabel(tuning_curve.regressor_obj.y_label)
xlim(tuning_curve.regressor_obj.x_range)
ylim(tuning_curve.regressor_obj.y_range)
%set(gca,'ytick',[5*floor(min(tuning_curve.y_vals)/5):5:5*ceil(max(tuning_curve.y_vals)/5)])
%set(gca,'xtick',[5*floor(min(tuning_curve.x_vals)/5):5:5*ceil(max(tuning_curve.x_vals)/5)])

set(gca,'layer','top')
