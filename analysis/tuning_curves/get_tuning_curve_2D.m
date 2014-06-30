function tuning_curve = get_tuning_curve_2D(regVect_1,num_groups_1,regVect_2,num_groups_2,responseVar)

tuning_curve.means = NaN(num_groups_1,num_groups_2);
tuning_curve.std = NaN(num_groups_1,num_groups_2);
tuning_curve.num_pts = zeros(num_groups_1,num_groups_2);
tuning_curve.data = cell(num_groups_1,num_groups_2);

for i_group = 1:num_groups_1
	for j_group = 1:num_groups_2
		tuning_curve.data{i_group,j_group} = responseVar(regVect_1==i_group & regVect_2==j_group);
		tuning_curve.means(i_group,j_group) = mean(tuning_curve.data{i_group,j_group});
		tuning_curve.std(i_group,j_group) = std(tuning_curve.data{i_group,j_group});
		tuning_curve.num_pts(i_group,j_group) = length(tuning_curve.data{i_group,j_group});
	end
end