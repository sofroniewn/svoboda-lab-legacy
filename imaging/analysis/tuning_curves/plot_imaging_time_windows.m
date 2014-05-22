function [tuning_curve raster] = plot_imaging_time_windows(test_var,phys,extracted_times,group_ids,max_time,col_mat,plot_on)

if phys
	start_col = 4;
else
	start_col = 2;	
end

ind_dur_trial = extracted_times(:,start_col+1) - extracted_times(:,start_col);
max_dur = max(ind_dur_trial);


groups = extracted_times(:,6);
num_groups = length(group_ids);

if plot_on
	figure(14)
	clf(14)
	hold on
end

tuning_curve.means = NaN(num_groups,1);
tuning_curve.stds = NaN(num_groups,1);
tuning_curve.num_pts = zeros(num_groups,1);
tuning_curve.data = cell(num_groups,1);

raster = cell(num_groups,1);

max_psth = 0;
for i_group = 1:num_groups
	repeat_ids = find(groups == group_ids(i_group));
	num_repeats = length(repeat_ids);
	raster{i_group} = NaN(num_repeats,max_dur);
	tuning_curve.data{i_group} = zeros(num_repeats,1);
	for i_trial = 1:num_repeats
		tmp = test_var(extracted_times(i_trial,start_col):extracted_times(i_trial,start_col+1))';
		raster{i_group}(i_trial,1:length(tmp)) = tmp;
		tuning_curve.data{i_group}(i_trial) = mean(tmp)/max_time;
	end
	tuning_curve.means(i_group) = mean(tuning_curve.data{i_group});
	tuning_curve.stds(i_group) = std(tuning_curve.data{i_group});
	tuning_curve.num_pts(i_group) = length(tuning_curve.data{i_group});		
	if plot_on && num_repeats>0
		plot([0:max_dur]/max_dur*max_time,nanmean(raster{i_group},1),'LineWidth',2,'Color',col_mat(i_group,:));
	end
end


