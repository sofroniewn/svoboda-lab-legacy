function plot_tuning_curves(tuning_curve)

figure(3)
clf(3)
hold on
plot(tuning_curve.x_vals,tuning_curve.means,'LineWidth',2)
plot(tuning_curve.x_vals,(tuning_curve.means+tuning_curve.stds))
plot(tuning_curve.x_vals,(tuning_curve.means-tuning_curve.stds))
