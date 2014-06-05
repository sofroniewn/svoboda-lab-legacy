function title_handle = plot_summary_tuning(fig_id,tuning_param,col_mat)

figure(fig_id)
clf(fig_id)
hold on
%set(gcf,'Position',[720    -1   345   239])

h_plot = plot(tuning_param.estPrs(:,1),tuning_param.r2,'.','Color',col_mat);
set(h_plot,'ButtonDownFcn',@update_tuning_summary_plot);

ylim([0 .05+max(tuning_param.r2)])
xlim([tuning_param.x_range])
xlabel(tuning_param.x_label)
ylabel('r2')
title_handle = title(tuning_param.title);

handles_roi_tuning_curve.highlighted_roi_title = title_handle;