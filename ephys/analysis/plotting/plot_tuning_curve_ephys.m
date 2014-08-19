function plot_tuning_curve_ephys(fig_props,tuning_curve)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

col_mat = [0 0 1];

hb = bar(tuning_curve.regressor_obj.x_vals,tuning_curve.means);
set(hb,'FaceColor',col_mat)
set(hb,'EdgeColor',col_mat)
max_y = zeros(length(tuning_curve.regressor_obj.x_vals),1);
plot(tuning_curve.regressor_obj.x_range,[0 0],'k')
for ij = 1:length(tuning_curve.regressor_obj.x_vals)
    plot([tuning_curve.regressor_obj.x_vals(ij),tuning_curve.regressor_obj.x_vals(ij)],[(tuning_curve.means(ij)-tuning_curve.std(ij)/sqrt(length(tuning_curve.data{ij}))), (tuning_curve.means(ij)+tuning_curve.std(ij)/sqrt(length(tuning_curve.data{ij})))],'LineWidth',2,'Color',[0.5 0.5 0.5])
    max_y(ij) = ceil(tuning_curve.means(ij)+tuning_curve.std(ij)/sqrt(length(tuning_curve.data{ij})));
end

if ~isempty(tuning_curve.model_fit)
     plot(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.curve,'LineWidth',2,'Color','k')
end

max_y = max(max_y(~isnan(max_y)));
if isempty(max_y) || isnan(max_y) || max_y == 0
     max_y = 0.01;
end

%plot(tuning_curve.x_vals,tuning_curve.means,'LineWidth',2)
%plot(tuning_curve.x_vals,(tuning_curve.means+tuning_curve.stds))
%plot(tuning_curve.x_vals,(tuning_curve.means-tuning_curve.stds))
ylim([0 max_y])
xlim([tuning_curve.regressor_obj.x_range])
xlabel(tuning_curve.regressor_obj.x_label)
ylabel(tuning_curve.regressor_obj.y_label)
set(gca,'xtick',tuning_curve.regressor_obj.x_tick)
% title(title_str)