%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

animal_names = {'172933';'172934';'173081';'174949';'174950';'174947';'159346';'159667'};

cond_array = {'sil_trim';'sil_trim';'sil_trim';'sil_none'};

plot_params.x_var = 'space'; %%% 'time'
 keep_label_array = {'off';'V1';'S1';'off'};
 %keep_label_array = {'lV1';'lV1';'lV1';'off';'rV1';'rV1';'rV1'};
 laser_power_array = {[0 0];[1 100];[1 100];[0 0]};
cond_col = [.2 .2 .2; .2 1 .2; .2 .2 1; 1 .2 .2];


%prop_str = 'final_position';
prop_str = 'run_angle';

dprime_run_angle = NaN(numel(animal_names),4);
for ij = 1:numel(animal_names)
    ij
animal_name = animal_names{ij};
struct_name = ['ANM_0' animal_name];
load(['/Users/sofroniewn/Documents/svoboda_lab/OLD_COMPUTER/WGNR/DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);
cond_name = cond_array{1};
data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{2},laser_power_array,{[0 1]});
angle_turn1 = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{1},laser_power_array,{[0 1]});
angle_straight = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{5},laser_power_array,{[0 1]});
angle_turn2 = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);

cond_name = cond_array{4};
data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{2},laser_power_array,{[0 1]});
tmp = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
angle_turn1{4} = tmp{4};
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{1},laser_power_array,{[0 1]});
tmp = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
angle_straight{4} = tmp{4};
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{5},laser_power_array,{[0 1]});
tmp = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
angle_turn2{4} = tmp{4};
	for ih = 1:4
		tmp_a = -(angle_turn2{ih}.mean - angle_straight{ih}.mean)/sqrt(1/2*(angle_turn2{ih}.std^2+angle_straight{ih}.std^2));
		tmp_b = -(angle_straight{ih}.mean - angle_turn1{ih}.mean)/sqrt(1/2*(angle_turn1{ih}.std^2+angle_straight{ih}.std^2));
		dprime_run_angle(ij,ih) = (tmp_a + tmp_b)/2;
	end
end


%%
col_mat = [0 0 0;0 .5 0;0 0 .5;1 0 0];
str_labels = {'Row';'V1';'S1';'None'};

dprime_run_angle_error_mean = cell(1,4);
for ih = 1:4
    dprime_run_angle_error_mean{ih} = trial_error(dprime_run_angle(:,ih),[0 25],10);
    dprime_run_angle_error_mean{ih}.col_mat = col_mat(ih,:);
    dprime_run_angle_error_mean{ih}.label = str_labels{ih};
end


figure(546)
clf(546)
set(gcf,'Color',[1 1 1])
fig_pos = [106 405 420 250];
set(gcf, 'Position',fig_pos)

hold on
prop_str = 'run_angle';
plot_params.window_pos = [440   102   542   674];
plot_params.style = 'indv_only'; %%% 'mean_std' 'mean_ste'  'indv'
plot_params.save_label = [cond_array{1} '_' cond_array{1} 'new'];
plot_params.cor_width = 30;
plot_params.x_var = 'space'; %%% 'time'
plot_params.animal_name = animal_name;
plot_params.prop_str = prop_str;
plot_params.style_extra = 'indv';
plot_params.xtick_label = cond_array;
plot_params.y_lim = [0 6];
plot_params.x_label = '';
plot_params.x_lim = [0.5 numel(str_labels)+.5];
plot_params.x_vect = [1:numel(str_labels)];
plot_params.y_label = 'D prime';
plot_params.error_bar_width = 1;

wgnr_plot_error_no_fig(dprime_run_angle_error_mean,plot_params);
set(gca,'XtickLabel',str_labels)
   set(gca,'LineWidth',2)
   set(gca,'layer','top')
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

animal_names = {'172933';'172934';'173081';'174949';'174950';'174947';'159346';'159667'};

cond_array = {'sil_trim';'sil_trim';'sil_trim';'sil_none'};

plot_params.x_var = 'space'; %%% 'time'
 keep_label_array = {'off';'V1';'S1';'off'};
 %keep_label_array = {'lV1';'lV1';'lV1';'off';'rV1';'rV1';'rV1'};
 laser_power_array = {[0 0];[1 100];[1 100];[0 0]};
cond_col = [.2 .2 .2; .2 1 .2; .2 .2 1; 1 .2 .2];


ij = 8;
animal_name = animal_names{ij};
struct_name = ['ANM_0' animal_name];
load(['/Users/sofroniewn/Documents/svoboda_lab/OLD_COMPUTER/WGNR/DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);
cond_name = cond_array{1};
data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);


plot_params.x_var = 'space'; %%% 'time'
keep_label_array = {'off'};
%keep_label_array = {'lV1';'lV1';'lV1';'off';'rV1';'rV1';'rV1'};
laser_power_array = {[0 0]};
cond_col = [.2 .2 .2; .2 1 .2; .2 .2 1; 1 .2 .2];
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{2;1;5},laser_power_array,{[0 1]});


figure(346)
clf(346)
hold on
set(gcf,'Color',[1 1 1])
%set(gcf, 'Position',[16 428 1407 338])

prop_str_dist = 'ball_pos_y';
traj = wgnr_align_dist(data,prop_str_dist,keep_stats_array);
prop_str = 'final_position';
angle_turn = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);

% traj{1} = [];
% traj{3} = [];
% traj{5} = [];
% traj{7} = [];
plot_params.style = 'indv'; %%% 'mean_std' 'mean_ste'  'indv'
plot_params.save_label = cond_name;
plot_params.cor_width = 30;
plot_params.num_indv = 20;
plot_params.x_var = 'space'; %%% 'time'
plot_params.animal_name = animal_name;
plot_params.prop_str = prop_str_dist;
wgnr_plot_traj(traj,plot_params); 
% ideal_traj = wgnr_align_dist(data,'ideal_traj',keep_stats_array);
% plot(ideal_traj{1}.x_axis,ideal_traj{1}.mean,'k','LineWidth',3)
% plot(ideal_traj{2}.x_axis,ideal_traj{2}.mean,'k','LineWidth',3)
% plot(ideal_traj{3}.x_axis,ideal_traj{3}.mean,'k','LineWidth',3)
set(gcf, 'Position',[53   566   330   240])
ylim_val = get(gca,'ylim');

offset = [0 0;.1 .1;0 0];
figure(446)
clf(446)
hold on
for ih = 1:3
	plot(offset(ih,1),angle_turn{ih}.mean,'.','MarkerSize',25,'Color',angle_turn{ih}.col_mat)
	plot(offset(ih,:),[angle_turn{ih}.mean-angle_turn{ih}.std;angle_turn{ih}.mean+angle_turn{ih}.std],'Color',angle_turn{ih}.col_mat,'LineWidth',2)
end
ylim(ylim_val)
xlim([-.1 .2])
set(gcf, 'Position',[383   566   330   240])
set(gca,'visible','off')



animal_name = animal_names{ij};
struct_name = ['ANM_0' animal_name];
load(['/Users/sofroniewn/Documents/svoboda_lab/OLD_COMPUTER/WGNR/DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);
cond_name = cond_array{1};
data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);


plot_params.x_var = 'space'; %%% 'time'
keep_label_array = {'S1'};
%keep_label_array = {'lV1';'lV1';'lV1';'off';'rV1';'rV1';'rV1'};
laser_power_array = {[1 100]};
cond_col = [.2 .2 .2; .2 1 .2; .2 .2 1; 1 .2 .2];
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{2;1;5},laser_power_array,{[0 1]});


figure(347)
clf(347)
hold on
set(gcf,'Color',[1 1 1])
%set(gcf, 'Position',[16 428 1407 338])
prop_str_dist = 'ball_pos_y';
traj = wgnr_align_dist(data,prop_str_dist,keep_stats_array);
prop_str = 'final_position';
angle_turn = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);

% traj{1} = [];
% traj{3} = [];
% traj{5} = [];
% traj{7} = [];
plot_params.style = 'indv'; %%% 'mean_std' 'mean_ste'  'indv'
plot_params.save_label = cond_name;
plot_params.cor_width = 30;
plot_params.num_indv = 20;
plot_params.x_var = 'space'; %%% 'time'
plot_params.animal_name = animal_name;
plot_params.prop_str = prop_str_dist;
wgnr_plot_traj(traj,plot_params); 
% ideal_traj = wgnr_align_dist(data,'ideal_traj',keep_stats_array);
% plot(ideal_traj{1}.x_axis,ideal_traj{1}.mean,'k','LineWidth',3)
% plot(ideal_traj{2}.x_axis,ideal_traj{2}.mean,'k','LineWidth',3)
% plot(ideal_traj{3}.x_axis,ideal_traj{3}.mean,'k','LineWidth',3)
set(gcf, 'Position',[53   566   330   240])

offset = [0 0;.1 .1;0 0];
figure(447)
clf(447)
hold on
for ih = 1:3
	plot(offset(ih,1),angle_turn{ih}.mean,'.','MarkerSize',25,'Color',angle_turn{ih}.col_mat)
	plot(offset(ih,:),[angle_turn{ih}.mean-angle_turn{ih}.std;angle_turn{ih}.mean+angle_turn{ih}.std],'Color',angle_turn{ih}.col_mat,'LineWidth',2)
end
ylim(ylim_val)
xlim([-.1 .2])
set(gcf, 'Position',[383   566   330   240])
set(gca,'visible','off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%