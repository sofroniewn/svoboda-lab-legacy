clear all

anm_info.Scnn1a = {'171977';'171980';'171981';'173351';'174752';'174754';'174755';'178838'};
animal_names = anm_info.Scnn1a;


keep_label_array = {'clS1'};
laser_power_array = {[0 100]}; 
 cond_array = {'ff';'cl_laser'};


ij = 6 %1:numel(animal_names)
    
animal_name = animal_names{ij};
struct_name = ['ANM_0' animal_name];
load(['/Users/sofroniewn/Documents/svoboda_lab/OLD_COMPUTER/WGNR/DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);
cond_name = cond_array{2};
data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);
%keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{6;2;3;1;4;5;7},laser_power_array,{[0]});
%keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{6;2;3;1;4;5;7},laser_power_array,{[0]});
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{2;1;5},laser_power_array,{[0]});
%%


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

anm_info.Scnn1a = {'171977';'171980';'171981';'173351';'174752';'174754';'174755';'178838'};
animal_names = anm_info.Scnn1a;

keep_label_array = {'off';'basic';'clS1';'clV1';'clPPC'};
laser_power_array = {[0 0];[0 0];[0 100];[0 100];[0 100]}; 
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{[1 2 3 4 5 6 7]},laser_power_array,{[0]});


%cond_array = {'ff';'single';'none'};
%cond_col = [0 0 0;0 0 1;1 0 0];

% cond_array = {'ff';'none'};
% cond_col = [0 0 0;1 0 0];

cond_array = {'ff';'cl_laser'};
prop_str = 'run_angle';

dprime_run_angle = NaN(numel(animal_names),5);

for ij = 1:numel(animal_names)
    ij
animal_name = animal_names{ij};
struct_name = ['ANM_0' animal_name];
load(['/Users/sofroniewn/Documents/svoboda_lab/OLD_COMPUTER/WGNR/DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);

cond_name = cond_array{2};
data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{2},laser_power_array,{[0]});
tmp_2 = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{1},laser_power_array,{[0]});
tmp_1 = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{5},laser_power_array,{[0]});
tmp_5 = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);

cond_name = cond_array{1};
data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{2},laser_power_array,{[0]});
tmp_2b = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{1},laser_power_array,{[0]});
tmp_1b = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{5},laser_power_array,{[0]});
tmp_5b = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);

tmp_2{1} = tmp_2b{1};
tmp_1{1} = tmp_1b{1};
tmp_5{1} = tmp_5b{1};
	for ih = 1:5
		tmp_a = -(tmp_2{ih}.mean - tmp_1{ih}.mean)/sqrt(1/2*(tmp_2{ih}.std^2+tmp_1{ih}.std^2));
		tmp_b = -(tmp_1{ih}.mean - tmp_5{ih}.mean)/sqrt(1/2*(tmp_1{ih}.std^2+tmp_5{ih}.std^2));
		dprime_run_angle(ij,ih) = -(tmp_a + tmp_b)/2;
	end
end


%%
col_mat = [0 0 0;0 0 .5;0 .5 0;1 0 0];
str_labels = {'Walls';'S1';'V1/PPC';'Off'};

dprime_run_angle_mean = cell(1,4);
        tmp_data = [];    
    for ij = 1:numel(animal_names)
            tmp_data = [tmp_data;dprime_run_angle(ij,1)];
    end
    dprime_run_angle_mean{1} = trial_error(tmp_data,[0 25],10);
    dprime_run_angle_mean{1}.col_mat = col_mat(1,:);
    dprime_run_angle_mean{1}.label = str_labels{1};
    
            tmp_data = [];    
    for ij = 1:numel(animal_names)
            tmp_data = [tmp_data;dprime_run_angle(ij,3)];
    end
    dprime_run_angle_mean{2} = trial_error(tmp_data,[0 25],10);
    dprime_run_angle_mean{2}.col_mat = col_mat(2,:);
    dprime_run_angle_mean{2}.label = str_labels{2};
    
                tmp_data = [];    
    for ij = 1:3
            tmp_data = [tmp_data;dprime_run_angle(ij,5)];
    end
        for ij = 4:8
            tmp_data = [tmp_data;dprime_run_angle(ij,4)];
    end
    dprime_run_angle_mean{3} = trial_error(tmp_data,[0 25],10);
    dprime_run_angle_mean{3}.col_mat = col_mat(3,:);
    dprime_run_angle_mean{3}.label = str_labels{3};
    
            tmp_data = [];    
    for ij = 1:numel(animal_names)
            tmp_data = [tmp_data;dprime_run_angle(ij,2)];
    end
    dprime_run_angle_mean{4} = trial_error(tmp_data,[0 25],10);
    dprime_run_angle_mean{4}.col_mat = col_mat(4,:);
    dprime_run_angle_mean{4}.label = str_labels{4};
%% PVALUES S1 vs Control

% 1 is walls
% 2 is off
% 3 is S1
% 4 is V1
% 5 is PPC

% tmp_data = [];

%     for ij = 1:3
% [h p] = ttest2(err_run_angle{ij,3}.data,err_run_angle{ij,5}.data);
% tmp_data = [tmp_data; [p err_run_angle{ij,3}.mean-err_run_angle{ij,5}.mean]];
%     end
%     for ij = 4:8
% [h p] = ttest2(err_run_angle{ij,3}.data,err_run_angle{ij,4}.data);
% tmp_data = [tmp_data; [p err_run_angle{ij,3}.mean-err_run_angle{ij,4}.mean]];
%     end
    
%     tmp_data

%%

figure(846)
clf(846)
set(gcf,'Color',[1 1 1])
fig_pos = [106 405 420*4/4 250];
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

wgnr_plot_error_no_fig(dprime_run_angle_mean,plot_params);
set(gca,'XtickLabel',str_labels)
   set(gca,'LineWidth',2)
set(gca,'TickDir','out')
   %set(gca,'layer','top')







% clear all

% anm_info.Scnn1a = {'171977';'171980';'171981';'173351';'174752';'174754';'174755';'178838'};
% animal_names = anm_info.Scnn1a;

% keep_label_array = {'off';'basic';'clS1';'clV1';'clPPC'};
% laser_power_array = {[0 0];[0 0];[0 100];[0 100];[0 100]}; 
% keep_stats_array = wgnr_generate_keep_stats_array(keep_label_array,{[1 2 3 4 5 6 7]},laser_power_array,{[0]});


% %cond_array = {'ff';'single';'none'};
% %cond_col = [0 0 0;0 0 1;1 0 0];

% % cond_array = {'ff';'none'};
% % cond_col = [0 0 0;1 0 0];

% cond_array = {'ff';'cl_laser'};
% prop_str = 'run_angle_err';

% err_run_angle = cell(numel(animal_names),5);

% for ij = 1:numel(animal_names)
%     ij
% animal_name = animal_names{ij};
% struct_name = ['ANM_0' animal_name];
% load(['/Users/sofroniewn/Documents/svoboda_lab/OLD_COMPUTER/WGNR/DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);
% cond_name = cond_array{1};
% data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);
% err = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
% err_run_angle{ij,1} = err{1};
% cond_name = cond_array{2};
% data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0);
% err = wgnr_align_param(data,prop_str,keep_stats_array,[-25 25],10);
% err_run_angle{ij,2} = err{2};
% err_run_angle{ij,3} = err{3};
% err_run_angle{ij,4} = err{4};
% err_run_angle{ij,5} = err{5};

% end


% %%
% col_mat = [0 0 0;0 0 .5;0 .5 0;1 0 0];
% str_labels = {'Walls';'S1';'V1/PPC';'Off'};

% err_abs_run_angle_error_mean = cell(1,4);
%         tmp_data = [];    
%     for ij = 1:numel(animal_names)
%             tmp_data = [tmp_data;err_run_angle{ij,1}.mean];
%     end
%     err_abs_run_angle_error_mean{1} = trial_error(tmp_data,[0 25],10);
%     err_abs_run_angle_error_mean{1}.col_mat = col_mat(1,:);
%     err_abs_run_angle_error_mean{1}.label = str_labels{1};
    
%             tmp_data = [];    
%     for ij = 1:numel(animal_names)
%             tmp_data = [tmp_data;err_run_angle{ij,3}.mean];
%     end
%     err_abs_run_angle_error_mean{2} = trial_error(tmp_data,[0 25],10);
%     err_abs_run_angle_error_mean{2}.col_mat = col_mat(2,:);
%     err_abs_run_angle_error_mean{2}.label = str_labels{2};
    
%                 tmp_data = [];    
%     for ij = 1:3
%             tmp_data = [tmp_data;err_run_angle{ij,5}.mean];
%     end
%         for ij = 4:8
%             tmp_data = [tmp_data;err_run_angle{ij,4}.mean];
%     end
%     err_abs_run_angle_error_mean{3} = trial_error(tmp_data,[0 25],10);
%     err_abs_run_angle_error_mean{3}.col_mat = col_mat(3,:);
%     err_abs_run_angle_error_mean{3}.label = str_labels{3};
    
%             tmp_data = [];    
%     for ij = 1:numel(animal_names)
%             tmp_data = [tmp_data;err_run_angle{ij,2}.mean];
%     end
%     err_abs_run_angle_error_mean{4} = trial_error(tmp_data,[0 25],10);
%     err_abs_run_angle_error_mean{4}.col_mat = col_mat(4,:);
%     err_abs_run_angle_error_mean{4}.label = str_labels{4};
% %% PVALUES S1 vs Control

% % 1 is walls
% % 2 is off
% % 3 is S1
% % 4 is V1
% % 5 is PPC

% tmp_data = [];

%     for ij = 1:3
% [h p] = ttest2(err_run_angle{ij,3}.data,err_run_angle{ij,5}.data);
% tmp_data = [tmp_data; [p err_run_angle{ij,3}.mean-err_run_angle{ij,5}.mean]];
%     end
%     for ij = 4:8
% [h p] = ttest2(err_run_angle{ij,3}.data,err_run_angle{ij,4}.data);
% tmp_data = [tmp_data; [p err_run_angle{ij,3}.mean-err_run_angle{ij,4}.mean]];
%     end
    
%     tmp_data

% %%
% ideal_angle = -180/pi*[-atan(.3), -atan(.2), -atan(.1), 0, atan(.1), atan(.2), atan(.3)];
% chance_angle = ideal_angle(2)*2/7 + ideal_angle(1)*2/7 + ideal_angle(3)*2/7;
% figure(846)
% clf(846)
% set(gcf,'Color',[1 1 1])
% fig_pos = [106 405 420*4/4 250];
% set(gcf, 'Position',fig_pos)

% hold on
% prop_str = 'run_angle';
% plot_params.window_pos = [440   102   542   674];
% plot_params.style = 'indv_only'; %%% 'mean_std' 'mean_ste'  'indv'
% plot_params.save_label = [cond_array{1} '_' cond_array{1} 'new'];
% plot_params.cor_width = 30;
% plot_params.x_var = 'space'; %%% 'time'
% plot_params.animal_name = animal_name;
% plot_params.prop_str = prop_str;
% plot_params.style_extra = 'indv';
% plot_params.xtick_label = cond_array;
% plot_params.y_lim = [0 20];
% plot_params.x_label = '';
% plot_params.x_lim = [0.5 numel(str_labels)+.5];
% plot_params.x_vect = [1:numel(str_labels)];
% plot_params.y_label = 'Angle error (deg)';
% plot_params.error_bar_width = 1;
% h = patch([0 0 26 26],[chance_angle 18 18 chance_angle],[0.85 0.85 0.85]);
% set(h,'EdgeColor',[0.85 0.85 0.85])

% wgnr_plot_error_no_fig(err_abs_run_angle_error_mean,plot_params);
% set(gca,'XtickLabel',str_labels)
%    set(gca,'LineWidth',2)






