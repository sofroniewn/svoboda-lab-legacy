function title_handle = plot_summary_tuning(fig_id,tuning_param,col_mat)

figure(fig_id)
clf(fig_id)
hold on
%set(gcf,'Position',[720    -1   345   239])

keep_ind = tuning_param.estPrs(:,3) > 1;
r2_val = tuning_param.r2;
r2_val(r2_val<.1) = -1;
r2_val(~keep_ind) = -1;
h_plot = plot(tuning_param.estPrs(:,1),r2_val,'.','Color',col_mat,'MarkerSize',15);
set(h_plot,'ButtonDownFcn',@update_tuning_summary_plot);

ylim([0 .05+max(tuning_param.r2)])
xlim([tuning_param.x_range])
xlabel(tuning_param.x_label)
ylabel('r2')
title_handle = title(tuning_param.title);

handles_roi_tuning_curve.highlighted_roi_title = title_handle;