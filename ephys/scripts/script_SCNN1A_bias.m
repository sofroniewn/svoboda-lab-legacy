cd('/Users/sofroniewn/Documents/svoboda_lab/OLD_COMPUTER/WGNR/')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ig = 7;

animal_names = {'171977';'171980';'171981';'173351';'174752';'174754';'174755';'178838'};
animal_name = animal_names{ig};

struct_name = ['ANM_0' animal_name];

base_dir = '/Users/sofroniewn/Desktop/WGNR';
load(['./DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);

cond_name = 'ol_laser_scnn1a';

data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0)

if ig <= 3
    data.trial_stats.laser_power(data.trial_stats.laser_power<3) = data.trial_stats.laser_power(data.trial_stats.laser_power<3)*10;
else
end
%%
keep_stats_array = wgnr_generate_keep_stats_array({'off';'rS1'},{1},{[0 0];[6 20]},{[0 1]});

rand('seed',190)

prop_str_dist = 'cor_pos';
traj = wgnr_align_dist(data,prop_str_dist,keep_stats_array);
traj{2}.col_mat = [0 .5 0];

for ih = 1:2
    keep_trials = randperm(traj{ih}.num);
    if traj{ih}.num >= 50
        keep_trials = keep_trials(1:20);
        traj{ih}.indv = traj{ih}.indv(keep_trials,:);
    else
    end
end

plot_params.style = 'indv'; %%% 'mean_std' 'mean_ste'  'indv'
plot_params.x_var = 'space'; %%% 'time'
plot_params.prop_str = prop_str_dist;

plot_params.num_indv = 20;
wgnr_plot_traj(traj,plot_params);
xlim([20 149])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all

all_data_actv_S1 = cell(8,1);
model_slopes = zeros(8,3);
for ig = 1:8
    animal_names = {'171977';'171980';'171981';'173351';'174752';'174754';'174755';'178838'};
    animal_name = animal_names{ig};
    
    struct_name = ['ANM_0' animal_name];
    
    base_dir = '/Users/sofroniewn/Desktop/WGNR';
    load(['./DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);
    
    cond_name = 'ol_laser_scnn1a';
    
    data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0)
    plot_params.cor_width = 30;
    plot_params.save_label = cond_name;
    plot_params.animal_name = animal_name;
    
    if ig <= 3
        data.trial_stats.laser_power(data.trial_stats.laser_power<3) = data.trial_stats.laser_power(data.trial_stats.laser_power<3)*10;
        x_val = 2.5;
        %x_val = 1;
    else
        x_val = 2.9;
        %x_val = 2.0;
        
    end
    
    data.trial_stats.laser_power = data.trial_stats.laser_power/10;
    
    
    x_data = [];
    y_data = [];
    
    keep_inds = data.trial_stats.laser_power<40 & abs(data.trial_stats.x_mirror_pos-8)<.2;
    mean_bias = mean(data.trial_errors.final_cor_pos(keep_inds));
    plot(data.trial_stats.laser_power(keep_inds),data.trial_errors.final_cor_pos(keep_inds)-mean_bias,'.','MarkerSize',20,'MarkerEdgeColor',[.5 .5 .5])
    x_data = [x_data;data.trial_stats.laser_power(keep_inds)];
    y_data = [y_data;data.trial_errors.final_cor_pos(keep_inds)-mean_bias];
    
    keep_inds = data.trial_stats.laser_power<40 & abs(data.trial_stats.x_mirror_pos-x_val)<.2;
    plot(data.trial_stats.laser_power(keep_inds),data.trial_errors.final_cor_pos(keep_inds)-mean_bias,'.','MarkerSize',20,'MarkerEdgeColor',[.5 .5 .5])
    x_data = [x_data;data.trial_stats.laser_power(keep_inds)];
    y_data = [y_data;data.trial_errors.final_cor_pos(keep_inds)-mean_bias];
    
    keep_inds = data.trial_stats.laser_power<40 & abs(data.trial_stats.x_mirror_pos+x_val)<.2;
    plot(-data.trial_stats.laser_power(keep_inds),data.trial_errors.final_cor_pos(keep_inds)-mean_bias,'.','MarkerSize',20,'MarkerEdgeColor',[.5 .5 .5])
    x_data = [x_data;-data.trial_stats.laser_power(keep_inds)];
    y_data = [y_data;data.trial_errors.final_cor_pos(keep_inds)-mean_bias];
    
     all_data_actv_S1{ig}.y_data = y_data;
    all_data_actv_S1{ig}.x_data = x_data;    
end
%%%
all_data_actv_CC = cell(8,1);
model_slopes = zeros(8,3);
for ig = 1:8
    animal_names = {'171977';'171980';'171981';'173351';'174752';'174754';'174755';'178838'};
    animal_name = animal_names{ig};
    
    struct_name = ['ANM_0' animal_name];
    
    base_dir = '/Users/sofroniewn/Desktop/WGNR';
    load(['./DATA/ANM_0',animal_name,'/COMP_v3/0_summary/' animal_name '_data_ids.mat']);
    
    cond_name = 'ol_laser_scnn1a';
    
    data = wgnr_comp('/Users/sofroniewn/Desktop/WGNR',animal_name,data_ids.(struct_name).(cond_name).dates,data_ids.(struct_name).(cond_name).run_nums,'bv_rig',cond_name,0)
    plot_params.cor_width = 30;
    plot_params.save_label = cond_name;
    plot_params.animal_name = animal_name;
    
    if ig <= 3
        data.trial_stats.laser_power(data.trial_stats.laser_power<3) = data.trial_stats.laser_power(data.trial_stats.laser_power<3)*10;
        x_val = 2.5;
        x_val = 1;
    else
        x_val = 2.9;
        x_val = 2.0;
        
    end
    
    data.trial_stats.laser_power = data.trial_stats.laser_power/10;
    
    
    x_data = [];
    y_data = [];
    
    keep_inds = data.trial_stats.laser_power<40 & abs(data.trial_stats.x_mirror_pos-8)<.2;
    mean_bias = mean(data.trial_errors.final_cor_pos(keep_inds));
    plot(data.trial_stats.laser_power(keep_inds),data.trial_errors.final_cor_pos(keep_inds)-mean_bias,'.','MarkerSize',20,'MarkerEdgeColor',[.5 .5 .5])
    x_data = [x_data;data.trial_stats.laser_power(keep_inds)];
    y_data = [y_data;data.trial_errors.final_cor_pos(keep_inds)-mean_bias];
    
    keep_inds = data.trial_stats.laser_power<40 & abs(data.trial_stats.x_mirror_pos-x_val)<.2;
    plot(data.trial_stats.laser_power(keep_inds),data.trial_errors.final_cor_pos(keep_inds)-mean_bias,'.','MarkerSize',20,'MarkerEdgeColor',[.5 .5 .5])
    x_data = [x_data;data.trial_stats.laser_power(keep_inds)];
    y_data = [y_data;data.trial_errors.final_cor_pos(keep_inds)-mean_bias];
    
    keep_inds = data.trial_stats.laser_power<40 & abs(data.trial_stats.x_mirror_pos+x_val)<.2;
    plot(-data.trial_stats.laser_power(keep_inds),data.trial_errors.final_cor_pos(keep_inds)-mean_bias,'.','MarkerSize',20,'MarkerEdgeColor',[.5 .5 .5])
    x_data = [x_data;-data.trial_stats.laser_power(keep_inds)];
    y_data = [y_data;data.trial_errors.final_cor_pos(keep_inds)-mean_bias];
    
    all_data_actv_CC{ig}.y_data = y_data;
    all_data_actv_CC{ig}.x_data = x_data;
    
end




tmp_data_x = [];
tmp_data_y = [];
range = [0 20];
freq = 4;

err = cell(5,1);

for ig = 1:8
    tmp_data_x = [tmp_data_x;all_data_actv_S1{ig}.x_data];
    tmp_data_y = [tmp_data_y;all_data_actv_S1{ig}.y_data];
end
tmp_data_y(tmp_data_x<0) = -tmp_data_y(tmp_data_x<0);
tmp_data_x(tmp_data_x<0) = -tmp_data_x(tmp_data_x<0);

err{2} = trial_error(tmp_data_y(tmp_data_x==0),range,freq);
err{3} = trial_error(tmp_data_y(tmp_data_x>0 & tmp_data_x<=.75),range,freq);
err{4} = trial_error(tmp_data_y(tmp_data_x>.75 & tmp_data_x<=1.5),range,freq);
err{5} = trial_error(tmp_data_y(tmp_data_x>1.5 & tmp_data_x<=3),range,freq);

mean(tmp_data_x(tmp_data_x>0 & tmp_data_x<=.75))
mean(tmp_data_x(tmp_data_x>.75 & tmp_data_x<=1.5))
mean(tmp_data_x(tmp_data_x>1.5 & tmp_data_x<=3))

tmp_data_x = [];
tmp_data_y = [];
range = [0 20];
freq = 4;

% for ig = 1:11
%     tmp_data_x = [tmp_data_x;all_data_sil_S1{ig}.x_data];
%     tmp_data_y = [tmp_data_y;all_data_sil_S1{ig}.y_data];
% end
tmp_data_y(tmp_data_x<0) = -tmp_data_y(tmp_data_x<0);
tmp_data_x(tmp_data_x<0) = -tmp_data_x(tmp_data_x<0);

err{2} = trial_error([tmp_data_y(tmp_data_x==0);err{2}.data],range,freq);
err{1} = trial_error(tmp_data_y(tmp_data_x>5),range,freq);


err{1}.col_mat = [.8 0 .3];
err{2}.col_mat = [0 0 0];
err{3}.col_mat = [0 .5 0];
err{4}.col_mat = [0 .5 0];
err{5}.col_mat = [0 .5 0];
err{1}.label = '';
err{2}.label = '';
err{3}.label = '';
err{4}.label = '';
err{5}.label = '';
%% P value on bias
ih_1 = 5;
ih_2 = 2;

        [h p] = ttest2(err{ih_1}.data,err{ih_2}.data);
err{ih_1}.mean - err{ih_2}.mean
err{ih_1}.num + err{ih_2}.num

p

%%
figure(46)
clf(46)
set(gcf,'Color',[1 1 1])
fig_pos = [106   454   265   201];
set(gcf, 'Position',fig_pos)

hold on
prop_str = 'run_angle';
plot_params.window_pos = [440   102   542   674];
plot_params.style = 'ste'; %%% 'mean_std' 'mean_ste'  'indv'
plot_params.save_label = ['new'];
plot_params.cor_width = 30;
plot_params.x_var = 'space'; %%% 'time'
plot_params.animal_name = animal_name;
plot_params.prop_str = prop_str;
plot_params.style_extra = '';
plot_params.xtick_label = '1';
plot_params.y_lim = [-10 5];
plot_params.x_label = '';
plot_params.x_lim = [0.5 numel(err)+.5];
plot_params.x_vect = [1:numel(err)];
plot_params.y_label = '';
plot_params.error_bar_width = 1;
wgnr_plot_error_no_fig(err,plot_params);
set(gca,'XtickLabel',{'7.5';'0';'0.5';'1.2';'2.0'})
set(gca,'Xtick',[1:numel(err)])

set(gca,'LineWidth',2)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



tmp_data_x = [];
tmp_data_y = [];
range = [0 20];
freq = 4;

err = cell(5,1);

for ig = 1:8
    tmp_data_x = [tmp_data_x;all_data_actv_CC{ig}.x_data];
    tmp_data_y = [tmp_data_y;all_data_actv_CC{ig}.y_data];
end
tmp_data_y(tmp_data_x<0) = -tmp_data_y(tmp_data_x<0);
tmp_data_x(tmp_data_x<0) = -tmp_data_x(tmp_data_x<0);

err{2} = trial_error(tmp_data_y(tmp_data_x==0),range,freq);
err{3} = trial_error(tmp_data_y(tmp_data_x>0 & tmp_data_x<=.75),range,freq);
err{4} = trial_error(tmp_data_y(tmp_data_x>.75 & tmp_data_x<=1.5),range,freq);
err{5} = trial_error(tmp_data_y(tmp_data_x>1.5 & tmp_data_x<=3),range,freq);

mean(tmp_data_x(tmp_data_x>0 & tmp_data_x<=.75))
mean(tmp_data_x(tmp_data_x>.75 & tmp_data_x<=1.5))
mean(tmp_data_x(tmp_data_x>1.5 & tmp_data_x<=3))

tmp_data_x = [];
tmp_data_y = [];
range = [0 20];
freq = 4;

% for ig = 1:3
%     tmp_data_x = [tmp_data_x;all_data_sil_CC{ig}.x_data];
%     tmp_data_y = [tmp_data_y;all_data_sil_CC{ig}.y_data];
% end
tmp_data_y(tmp_data_x<0) = -tmp_data_y(tmp_data_x<0);
tmp_data_x(tmp_data_x<0) = -tmp_data_x(tmp_data_x<0);

err{2} = trial_error([tmp_data_y(tmp_data_x==0);err{2}.data],range,freq);
err{1} = trial_error(tmp_data_y(tmp_data_x>5),range,freq);


err{1}.col_mat = [.8 0 .3];
err{2}.col_mat = [0 0 0];
err{3}.col_mat = [0 .5 0];
err{4}.col_mat = [0 .5 0];
err{5}.col_mat = [0 .5 0];
err{1}.label = '';
err{2}.label = '';
err{3}.label = '';
err{4}.label = '';
err{5}.label = '';
%%
figure(146)
clf(146)
set(gcf,'Color',[1 1 1])
fig_pos = [106   454   265   201];
set(gcf, 'Position',fig_pos)

hold on
prop_str = 'run_angle';
plot_params.window_pos = [440   102   542   674];
plot_params.style = 'ste'; %%% 'mean_std' 'mean_ste'  'indv'
plot_params.save_label = ['new'];
plot_params.cor_width = 30;
plot_params.x_var = 'space'; %%% 'time'
plot_params.animal_name = animal_name;
plot_params.prop_str = prop_str;
plot_params.style_extra = '';
plot_params.xtick_label = '1';
plot_params.y_lim = [-10 5];
plot_params.x_label = '';
plot_params.x_lim = [0.5 numel(err)+.5];
plot_params.x_vect = [1:numel(err)];
plot_params.y_label = '';
plot_params.error_bar_width = 1;
wgnr_plot_error_no_fig(err,plot_params);
set(gca,'XtickLabel',{'7.5';'0';'0.5';'1.2';'2.0'})
set(gca,'Xtick',[1:numel(err)])
set(gca,'LineWidth',2)
