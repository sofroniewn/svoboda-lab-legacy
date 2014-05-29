function plot_tuning_curves(fig_id,tuning_curve,col_mat)

figure(fig_id)
clf(fig_id)
hold on
hb = bar(tuning_curve.x_vals,tuning_curve.means);
set(hb,'FaceColor',col_mat)
set(hb,'EdgeColor',col_mat)
max_y = zeros(length(tuning_curve.x_vals),1);
for ij = 1:length(tuning_curve.x_vals)
    plot([tuning_curve.x_vals(ij),tuning_curve.x_vals(ij)],[(tuning_curve.means(ij)-tuning_curve.std(ij)/sqrt(length(tuning_curve.data{ij}))), (tuning_curve.means(ij)+tuning_curve.std(ij)/sqrt(length(tuning_curve.data{ij})))],'LineWidth',2,'Color','k')
    max_y(ij) = ceil(5*tuning_curve.means(ij)+tuning_curve.std(ij)/sqrt(length(tuning_curve.data{ij})))/5;
end

max_y = max(max_y(~isnan(max_y)));
if isempty(max_y) || isnan(max_y)
    max_y = 0.01;
end
%plot(tuning_curve.x_vals,tuning_curve.means,'LineWidth',2)
%plot(tuning_curve.x_vals,(tuning_curve.means+tuning_curve.stds))
%plot(tuning_curve.x_vals,(tuning_curve.means-tuning_curve.stds))
ylim([0 max_y])
xlim([tuning_curve.x_range])
xlabel(tuning_curve.x_label)
ylabel(tuning_curve.y_label)
title(tuning_curve.title)