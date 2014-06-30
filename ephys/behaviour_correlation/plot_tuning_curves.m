function plot_tuning_curves(fig_id,tuning_curve)

figure(fig_id)
clf(fig_id)
hold on
bar(tuning_curve.x_vals,tuning_curve.means)

for ij = 1:length(tuning_curve.x_vals)
    plot([tuning_curve.x_vals(ij),tuning_curve.x_vals(ij)],[(tuning_curve.means(ij)-tuning_curve.stds(ij)/sqrt(length(tuning_curve.data{ij}))), (tuning_curve.means(ij)+tuning_curve.stds(ij)/sqrt(length(tuning_curve.data{ij})))],'LineWidth',2,'Color','k')
end

max_y = 5*ceil(max(tuning_curve.means+tuning_curve.stds/sqrt(length(tuning_curve.data{ij}))))/5;
%plot(tuning_curve.x_vals,tuning_curve.means,'LineWidth',2)
%plot(tuning_curve.x_vals,(tuning_curve.means+tuning_curve.stds))
%plot(tuning_curve.x_vals,(tuning_curve.means-tuning_curve.stds))
ylim([0 max_y])
xlim([-2 max(tuning_curve.x_vals)+2])