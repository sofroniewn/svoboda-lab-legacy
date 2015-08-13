%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%animal_names = {'172933';'172934';'173081';'174949';'174950';'174947';'159346';'159667'};
% 172933, 172934, 173081 - single; others c1 - c3

clear all


animal_names = {'152332';'152333';'152334';'152335'}; %;'152332';'152333';'152334'};
%animal_names = {'152332';'152333';'152334'};

cond_array = {'uni_right';'uni_right';'uni_right';'uni_right'}; %'uni_left';'uni_left';'uni_left'};
%cond_array = {'uni_left';'uni_left';'uni_left'}; 

plot_params.x_var = 'space'; %%% 'time'
 keep_label_array = {'off';'rS1';'lS1';'S1'};
 %keep_label_array = {'lV1';'lV1';'lV1';'off';'rV1';'rV1';'rV1'};
 laser_power_array = {[0 0];[1 100];[1 100];[1 100]};
cond_col = [.2 .2 .2; .2 1 .2; .2 .2 1; 1 .2 .2];

keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{[1 2 3 4 5 6 7]},laser_power_array,{[0 1]});


%prop_str = 'final_position';
prop_str = 'run_angle_err';

err_run_angle = cell(numel(animal_names),4);
num_trials = NaN(numel(animal_names),4);

for ij = 1:numel(animal_names)
    ij
    if ij > 4
         keep_label_array = {'off';'lS1';'rS1';'S1'};
    else
         keep_label_array = {'off';'rS1';'lS1';'S1'};   
    end

animal_name = animal_names{ij};
struct_name = ['ANM_0' animal_name];
load(['/Users/sofroniewn/Documents/svoboda_lab/OLD_COMPUTER/WGNR/DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);
cond_name = cond_array{1};
data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);
err = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
err_run_angle{ij,1} = err{1};
err_run_angle{ij,1}.mean
err_run_angle{ij,2} = err{2};
err_run_angle{ij,2}.mean
err_run_angle{ij,3} = err{3};
err_run_angle{ij,3}.mean
cond_name = cond_array{4};
data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);
err = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
err_run_angle{ij,4} = err{4};
err_run_angle{ij,4}.mean
end


%%
col_mat = [0 0 0;0 .5 0;0 0 .5;1 0 0];
str_labels = {'Row';'ipsi';'contra';'bi'};

err_abs_run_angle_error_mean = cell(1,4);
for ih = 1:4
        tmp_data = [];    
    for ij = 1:numel(animal_names)
            tmp_data = [tmp_data;err_run_angle{ij,ih}.mean];
    end
    err_abs_run_angle_error_mean{ih} = trial_error(tmp_data,[0 25],10);
    err_abs_run_angle_error_mean{ih}.col_mat = col_mat(ih,:);
    err_abs_run_angle_error_mean{ih}.label = str_labels{ih};
end

%%
ideal_angle = -180/pi*[-atan(.3), -atan(.2), -atan(.1), 0, atan(.1), atan(.2), atan(.3)];



figure(46)
clf(46)
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
plot_params.y_lim = [0 15];
plot_params.x_label = '';
plot_params.x_lim = [0.5 numel(str_labels)+.5];
plot_params.x_vect = [1:numel(str_labels)];
plot_params.y_label = 'Angle error (deg)';
plot_params.error_bar_width = 1;
h = patch([0 0 26 26],[ideal_angle(2)*2/3 18 18 ideal_angle(2)*2/3],[0.85 0.85 0.85]);
set(h,'EdgeColor',[0.85 0.85 0.85])

wgnr_plot_error_no_fig(err_abs_run_angle_error_mean,plot_params);
set(gca,'XtickLabel',str_labels)
   set(gca,'LineWidth',2)
   set(gca,'layer','top')
set(gca,'TickDir','out')


local_python_save_path = '/Users/sofroniewn/Documents/DATA/ephys_python';
d = [];
d.row = err_abs_run_angle_error_mean{1}.data';
d.ipsi = err_abs_run_angle_error_mean{2}.data';
d.contra = err_abs_run_angle_error_mean{3}.data';
d.bi = err_abs_run_angle_error_mean{4}.data';
opt = [];
opt.NaN = 'NaN';
opt.Inf = 'NaN';
opt.FileName = fullfile(local_python_save_path,'silencingIpsi.json');
savejson('',d,opt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

animal_names = {'152332';'152333';'152334';'152335'}; %;'152332';'152333';'152334'};
%animal_names = {'152332';'152333';'152334'};

cond_array = {'uni_right';'uni_right';'uni_right';'uni_right'}; %'uni_left';'uni_left';'uni_left'};
%cond_array = {'uni_left';'uni_left';'uni_left'}; 

plot_params.x_var = 'space'; %%% 'time'
 keep_label_array = {'off';'rS1';'lS1';'S1'};
 %keep_label_array = {'lV1';'lV1';'lV1';'off';'rV1';'rV1';'rV1'};
 laser_power_array = {[0 0];[1 100];[1 100];[1 100]};
cond_col = [.2 .2 .2; .2 1 .2; .2 .2 1; 1 .2 .2];


%prop_str = 'final_position';
prop_str = 'run_angle';

dprime_run_angle = NaN(numel(animal_names),4);
num_trials = NaN(numel(animal_names),4);

for ij = 1:numel(animal_names)
    ij
    if ij > 4
    	 keep_label_array = {'off';'lS1';'rS1';'S1'};
    else
    	 keep_label_array = {'off';'rS1';'lS1';'S1'};	
	end

animal_name = animal_names{ij};
struct_name = ['ANM_0' animal_name];
load(['/Users/sofroniewn/Documents/svoboda_lab/OLD_COMPUTER/WGNR/DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);
cond_name = cond_array{ij};
data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{2},laser_power_array,{[0 1]});
angle_turn1 = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{1},laser_power_array,{[0 1]});
angle_straight = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{5},laser_power_array,{[0 1]});
angle_turn2 = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
	for ih = 1:4
		tmp_a = -(angle_turn2{ih}.mean - angle_straight{ih}.mean)/sqrt(1/2*(angle_turn2{ih}.std^2+angle_straight{ih}.std^2));
		tmp_b = -(angle_straight{ih}.mean - angle_turn1{ih}.mean)/sqrt(1/2*(angle_turn1{ih}.std^2+angle_straight{ih}.std^2));
		dprime_run_angle(ij,ih) = (tmp_a + tmp_b)/2;
		num_trials(ij,ih) = angle_turn1{ih}.num+angle_straight{ih}.num+angle_turn2{ih}.num;
	end
end


%%
col_mat = [0 0 0;0 .5 0;0 0 .5;1 0 0];
str_labels = {'Row';'ipsi';'contra';'bi'};

dprime_run_angle_error_mean = cell(1,4);
for ih = 1:4
    dprime_run_angle_error_mean{ih} = trial_error(dprime_run_angle(:,ih),[0 25],10);
    dprime_run_angle_error_mean{ih}.col_mat = col_mat(ih,:);
    dprime_run_angle_error_mean{ih}.label = str_labels{ih};
end


figure(516)
clf(516)
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
plot_params.y_lim = [0 8];
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%

    1.7408
    1.1302
    2.8720
    3.6246

    2.1259
    1.6354
    2.1222
    3.2062
    2.3992
    2.6121
    3.3251
    2.3342

% all 2.4273 +/- 0.7418; 12
% narrow 2.4700 +/- 0.5673; 8
% wide 2.3419 +/- 1.1189; 4

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

animal_names = {'152332';'152333';'152334';'152335'}; %;'152332';'152333';'152334'};
%animal_names = {'152332';'152333';'152334'};

cond_array = {'uni_right';'uni_right';'uni_right';'uni_right'}; %'uni_left';'uni_left';'uni_left'};

plot_params.x_var = 'space'; %%% 'time'
 keep_label_array = {'off';'rS1';'lS1';'S1'};
 %keep_label_array = {'lV1';'lV1';'lV1';'off';'rV1';'rV1';'rV1'};
 laser_power_array = {[0 0];[1 100];[1 100];[1 100]};
cond_col = [.2 .2 .2; .2 1 .2; .2 .2 1; 1 .2 .2];



ij = 4;
animal_name = animal_names{ij};
struct_name = ['ANM_0' animal_name];
load(['/Users/sofroniewn/Documents/svoboda_lab/OLD_COMPUTER/WGNR/DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);
cond_name = cond_array{ij};
data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);


plot_params.x_var = 'space'; %%% 'time'
keep_label_array = {'off'};
%keep_label_array = {'lV1';'lV1';'lV1';'off';'rV1';'rV1';'rV1'};
laser_power_array = {[0 0]};
cond_col = [.2 .2 .2;.2 1 .2; .2 .2 1; 1 .2 .2];
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
traj{2}.col_mat = [.5 0 .5];
wgnr_plot_traj(traj,plot_params); 
 ideal_traj = wgnr_align_dist(data,'ideal_traj',keep_stats_array);
 plot(ideal_traj{1}.x_axis,ideal_traj{1}.mean,'k','LineWidth',3)
 plot(ideal_traj{2}.x_axis,ideal_traj{2}.mean,'k','LineWidth',3)
 plot(ideal_traj{3}.x_axis,ideal_traj{3}.mean,'k','LineWidth',3)
set(gcf, 'Position',[53   566   330   240])
ylim_val = get(gca,'ylim');

angle_turn{2}.col_mat = [.5 0 .5];
offset = 160+100*[0.05 0.05;.1 .1;0 0];
% figure(446)
% clf(446)
% hold on
for ih = 1:3
	plot(offset(ih,1),angle_turn{ih}.mean,'.','MarkerSize',25,'Color',angle_turn{ih}.col_mat)
	plot(offset(ih,:),[angle_turn{ih}.mean-angle_turn{ih}.std;angle_turn{ih}.mean+angle_turn{ih}.std],'Color',angle_turn{ih}.col_mat,'LineWidth',2)
end
% ylim(ylim_val)
% xlim([-.1 .2])
% set(gcf,'position',[386   566   128   240])
% set(gca,'visible','off')
% set(gca,'position',[0.1300    0.1100    0.7750    0.8150])


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
traj{2}.col_mat = [.5 0 .5];
wgnr_plot_traj(traj,plot_params); 
 ideal_traj = wgnr_align_dist(data,'ideal_traj',keep_stats_array);
 plot(ideal_traj{1}.x_axis,ideal_traj{1}.mean,'k','LineWidth',3)
 plot(ideal_traj{2}.x_axis,ideal_traj{2}.mean,'k','LineWidth',3)
 plot(ideal_traj{3}.x_axis,ideal_traj{3}.mean,'k','LineWidth',3)
set(gcf, 'Position',[53   566   330   240])

angle_turn{2}.col_mat = [.5 0 .5];
offset = 160+100*[0.05 0.05;.1 .1;0 0];
% figure(447)
% clf(447)
% hold on
for ih = 1:3
	plot(offset(ih,1),angle_turn{ih}.mean,'.','MarkerSize',25,'Color',angle_turn{ih}.col_mat)
	plot(offset(ih,:),[angle_turn{ih}.mean-angle_turn{ih}.std;angle_turn{ih}.mean+angle_turn{ih}.std],'Color',angle_turn{ih}.col_mat,'LineWidth',2)
end
%ylim(ylim_val)
%xlim([-.1 .2])
%set(gcf,'position',[386   566   128   240])
%set(gca,'visible','off')
%set(gca,'position',[0.1300    0.1100    0.7750    0.8150])

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

animal_names = {'152332';'152333';'152334';'152335'}; %;'152332';'152333';'152334'};
%animal_names = {'152332';'152333';'152334'};

cond_array = {'uni_right';'uni_right';'uni_right';'uni_right'}; %'uni_left';'uni_left';'uni_left'};

plot_params.x_var = 'space'; %%% 'time'
 keep_label_array = {'off';'rS1';'lS1';'S1'};
 %keep_label_array = {'lV1';'lV1';'lV1';'off';'rV1';'rV1';'rV1'};
 laser_power_array = {[0 0];[1 100];[1 100];[1 100]};
cond_col = [.2 .2 .2; .2 1 .2; .2 .2 1; 1 .2 .2];



ij = 3;
animal_name = animal_names{ij};
struct_name = ['ANM_0' animal_name];
load(['/Users/sofroniewn/Documents/svoboda_lab/OLD_COMPUTER/WGNR/DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);
cond_name = cond_array{ij};
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

prop_str_dist = 'cor_pos';
traj = wgnr_align_dist(data,prop_str_dist,keep_stats_array);
prop_str = 'final_position';
angle_turn = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);

% traj{1} = [];
% traj{3} = [];
% traj{5} = [];
% traj{7} = [];
plot_params.style = 'indv'; %%% 'mean_std' 'mean_ste'  'indv'
plot_params.save_label = cond_name;
plot_params.cor_width = max(data.trial_stats.max_cor_pos);
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
prop_str_dist = 'cor_pos';
traj = wgnr_align_dist(data,prop_str_dist,keep_stats_array);
prop_str = 'final_position';
angle_turn = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);

% traj{1} = [];
% traj{3} = [];
% traj{5} = [];
% traj{7} = [];
plot_params.style = 'indv'; %%% 'mean_std' 'mean_ste'  'indv'
plot_params.save_label = cond_name;
plot_params.cor_width = max(data.trial_stats.max_cor_pos);
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