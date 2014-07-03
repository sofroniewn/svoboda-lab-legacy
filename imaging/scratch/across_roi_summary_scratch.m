

l4_sc = summary_ca;
l23_sc = summary_ca;
l23_trim_sc = summary_ca;


keep_inds = l4_sc{1}.tuning_param.estPrs(:,3) > 1 & l4_sc{1}.tuning_param.r2 > .1;
vals = l4_sc{1}.tuning_param.estPrs(keep_inds,1);

[x y] = hist(vals,[0:.5:25]);

figure(43);
clf(43)
hold on
plot(y,cumsum(x)/sum(x),'m')

keep_inds = l23_sc{1}.tuning_param.estPrs(:,3) > 1 & l23_sc{1}.tuning_param.r2 > .1;
vals = l23_sc{1}.tuning_param.estPrs(keep_inds,1);

[x y] = hist(vals,[0:.5:25]);

plot(y,cumsum(x)/sum(x),'g')

ylim([0 1])

set(gca,'ytick',[0:.2:1])



%%
type_id = 1;
stim_type_name = summary_ca{type_id}.tuning_param.stim_type_name;
keep_type_name = summary_ca{type_id}.tuning_param.keep_type_name;
trial_range = summary_ca{type_id}.tuning_param.trial_range;

keep_inds = summary_ca{type_id}.tuning_param.estPrs(:,3) > 1 & summary_ca{type_id}.tuning_param.r2 > .1;
vals = summary_ca{type_id}.tuning_param.estPrs(keep_inds,1);

keep_list = find(keep_inds);
for ij = 1:length(keep_list)
	[ij length(keep_list)]
	roi_id = keep_list(ij);
	tuning_curve{ij} = generate_tuning_curve(roi_id,stim_type_name,keep_type_name,trial_range);
end


tuning_means = NaN(length(keep_list),length(tuning_curve{1}.x_fit_vals));
for ij = 1:length(keep_list)
	roi_id = keep_list(ij);
%	tuning_means(ij,:) = tuning_curve{ij}.means./summary_ca{type_id}.tuning_param.estPrs(roi_id,3);
	tuning_means(ij,:) = tuning_curve{ij}.model_fit.curve./max(tuning_curve{ij}.model_fit.curve);
end

%vals_new = mean(tuning_means.*repmat(tuning_curve{1}.x_vals',length(keep_list),1),2);
vals_new = summary_ca{type_id}.tuning_param.estPrs(keep_inds,1) + 0.1*summary_ca{type_id}.tuning_param.estPrs(keep_inds,2);

[sort_vals Idx] = sort(vals_new);

figure(10)
clf(10)
imagesc(tuning_means(Idx,:))
%plot(tuning_means')



%%
figure(11)
clf(11)
corTune = summary_ca{1}.tuning_param.estPrs(:,1);
speedTune = summary_ca{2}.tuning_param.estPrs(:,1);
keep_inds = (summary_ca{1}.tuning_param.keep_val > 1 & summary_ca{1}.tuning_param.r2 > .1) | (summary_ca{2}.tuning_param.keep_val > 1 & summary_ca{2}.tuning_param.r2 > .1);

plot(corTune(keep_inds),speedTune(keep_inds),'.')









