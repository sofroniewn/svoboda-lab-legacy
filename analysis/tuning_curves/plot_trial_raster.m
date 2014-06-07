function plot_trial_raster(fig_id,trial_raster)

trial_raster_comb_traj = NaN(1,trial_raster.num_samples);
trial_raster_comb_response = NaN(1,trial_raster.num_samples);
trial_raster_avg_traj = NaN(trial_raster.num_groups,trial_raster.num_samples);
trial_raster_avg_response = NaN(trial_raster.num_groups,trial_raster.num_samples);

for ij = 1:trial_raster.num_groups
	trial_raster_comb_traj = [trial_raster_comb_traj; trial_raster.traj{ij}; NaN(1,trial_raster.num_samples)];
	trial_raster_comb_response = [trial_raster_comb_response; trial_raster.response{ij}; NaN(1,trial_raster.num_samples)];
    if ~isempty(trial_raster.traj{ij})
        trial_raster_avg_traj(ij,:) = nanmean(trial_raster.traj{ij},1);
        trial_raster_avg_response(ij,:) = nanmean(trial_raster.response{ij},1);
    end
end



col_mat = colormap('jet');
c_inds = linspace(1,size(col_mat,1),trial_raster.num_groups);
col_mat = col_mat(round(c_inds),:);

figure(fig_id)
clf(fig_id)
hax = axes('Position',[.1 .27 .38 .69]);
h = imagesc(trial_raster_comb_traj);
axis off
set(h, 'AlphaData', ~isnan(trial_raster_comb_traj))
title(trial_raster.title_1)

hax = axes('Position',[.1 .07 .38 .19]);
hold on
for ij = 1:trial_raster.num_groups
	plot(trial_raster.x_vect,trial_raster_avg_traj(ij,:),'Color',col_mat(ij,:))
end
xlim([0 max(trial_raster.x_vect)])
xlabel(trial_raster.x_label)
ylabel(trial_raster.y_label)
ylim(trial_raster.y_range)

hax = axes('Position',[.6 .27 .38 .69]);
h = imagesc(trial_raster_comb_response);
axis off
set(h, 'AlphaData', ~isnan(trial_raster_comb_response))
title(trial_raster.title_2)

hax = axes('Position',[.6 .07 .38 .19]);
hold on
for ij = 1:trial_raster.num_groups
	plot(trial_raster.x_vect,trial_raster_avg_response(ij,:),'Color',col_mat(ij,:))
end
xlim([0 max(trial_raster.x_vect)])
xlabel(trial_raster.x_label)
ylabel(trial_raster.activity_label)

%ylim([0 max_y])
%xlim([tuning_curve.x_range])
%xlabel(tuning_curve.x_label)
%ylabel(tuning_curve.y_label)
%title(trial_raster.title)