function tuning_curve = get_tuning_curve(regVect,num_groups,responseVar)

tuning_curve.means = NaN(num_groups,1);
tuning_curve.std = NaN(num_groups,1);
tuning_curve.num_pts = zeros(num_groups,1);
tuning_curve.data = cell(num_groups,1);

for i_group = 1:num_groups
	tuning_curve.data{i_group} = responseVar(regVect==i_group);
	tuning_curve.means(i_group) = mean(tuning_curve.data{i_group});
	tuning_curve.std(i_group) = std(tuning_curve.data{i_group});
	tuning_curve.num_pts(i_group) = length(tuning_curve.data{i_group});
end