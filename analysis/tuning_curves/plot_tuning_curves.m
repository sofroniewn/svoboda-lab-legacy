function plot_tuning_curves(fig_id,tuning_curve,col_mat)

figure(fig_id)
clf(fig_id)
hold on
hb = bar(tuning_curve.x_vals,tuning_curve.means);
set(hb,'FaceColor',col_mat)
set(hb,'EdgeColor',col_mat)
for ij = 1:length(tuning_curve.x_vals)
    plot([tuning_curve.x_vals(ij),tuning_curve.x_vals(ij)],[(tuning_curve.means(ij)-tuning_curve.std(ij)/sqrt(length(tuning_curve.data{ij}))), (tuning_curve.means(ij)+tuning_curve.std(ij)/sqrt(length(tuning_curve.data{ij})))],'LineWidth',2,'Color','k')
end
max_y = 5*ceil(max(tuning_curve.means+tuning_curve.std/sqrt(length(tuning_curve.data{ij}))))/5;
%plot(tuning_curve.x_vals,tuning_curve.means,'LineWidth',2)
%plot(tuning_curve.x_vals,(tuning_curve.means+tuning_curve.stds))
%plot(tuning_curve.x_vals,(tuning_curve.means-tuning_curve.stds))
ylim([0 max_y])
xlim([tuning_curve.x_range])
xlabel(tuning_curve.x_label)
title(tuning_curve.title)