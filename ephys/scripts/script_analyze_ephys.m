%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MERGE EPHYS & BEHAVIOUR
clear all
close all
drawnow
all_anm_id = {'270331'}; %,'270329','270331'
%'235585','237723','245918','249872','246702','250492','250494','250495','247871','250496','256043','252776','252778','266642','266644','270330'
local_save_path = '/Users/sofroniewn/Documents/DATA/ephys_summary_rev11';
merge_ephys_behaviour(all_anm_id,local_save_path);

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
%% LOAD PROCESSED DATA
clear all
close all
drawnow
local_save_path = '/Users/sofroniewn/Documents/DATA/ephys_summary_rev11';
cd(local_save_path);

all_anm_id = {'235585','237723','245918','249872','246702','250492','250494','250495','247871','252776','250496','256043','252778','266642','266644','270330','270329','270331'}; % ,'256043','252776'};

for ih = 1:numel(all_anm_id)
  anm_id = all_anm_id{ih}
  all_anm.data{ih} = load(['./' anm_id '_d'],'d');
  [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
  all_anm.data{ih}.d.anm_params = anm_params;
end

all_anm.names = all_anm_id;
global ps;
global rasters;
[ps curves rasters data] = extract_additional_ephys_vars_paper(all_anm.data,all_anm.names); all_anm.data = data; clear data;


save('matlab_session_all.mat','-v7.3')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all_anm_id = {'235585','237723','245918','249872','246702','250492','250494','250495','247871','252776','250496','256043','252778','266642','266644','270330','270329','270331'}; % ,'256043','252776'};
p_labels = all_anm.data{1}.d.p_labels;

ik = 0;
for ih = 1:numel(all_anm_id)
  anm_id = all_anm_id{ih}
  [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
  all_anm.data{ih}.d.anm_params = anm_params;
    for ij = 1:numel(all_anm.data{ih}.d.summarized_cluster)
        ik = ik+1
        s_ind = find(strcmp(p_labels,'chan_depth'));
        peak_channel = all_anm.data{ih}.d.p_nj(ij,s_ind);
        
        layer_4_dist = (anm_params.layer_4_corr - peak_channel)*20;
        
    
    boundaries = anm_params.boundaries;
    boundaries(isnan(boundaries)) = -Inf;
    layer_id = find(boundaries<layer_4_dist,1,'last');
        
        ps.layer_4_dist_FINAL(ik) = layer_4_dist;
        ps.layer_id_FINAL(ik) = layer_id;
    end
end
ps.layer_id_FINAL = ps.layer_id_FINAL';
ps.layer_4_dist_FINAL = ps.layer_4_dist_FINAL';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOAD SESSION
clear all
close all
drawnow
local_save_path = '/Users/sofroniewn/Documents/DATA/ephys_summary_rev13';
cd(local_save_path);
load('matlab_session_all2.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PUBLISH UNIT INFORMATION

plot_clusters_tuning_paper2(all_anm,ps,order)


dir_name = '/Users/sofroniewn/Documents/DATA/ephys_summary_rev13';
if exist(dir_name)~=7
   mkdir(dir_name);
end
cd(dir_name);

%% PUBLISH ALL ANIMALS one by one
 for ij = 11:numel(all_anm_id)
      anm_id = all_anm.names{ij}
      anm_num = str2num(anm_id);
      keep_spikes = ps.anm_id == anm_num;
      order_sort = ps.total_order(keep_spikes,:);
      [val ind] = sort(order_sort(:,4));
      order = order_sort(ind,:);
      outputDir = ['ALL_opto' anm_id];
      publish('publish_all_ephys3.m','showCode',false,'outputDir',outputDir); close all;
 end

% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L2/3, L4
%keep_spikes = ~ps.c1c2 & (ps.layer_23 | ps.layer_4) & ps.clean_clusters;
keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6 & (ps.layer_23 | ps.layer_4);
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['ACCEPT_all_AB_sup'];
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;


% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L2/3, L4
%keep_spikes = ~ps.c1c2 & (ps.layer_23 | ps.layer_4) & ps.clean_clusters;
keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6 & ~(ps.layer_23 | ps.layer_4);
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['ACCEPT_all_AB_deep'];
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;


% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L2/3, L4
%keep_spikes = ~ps.c1c2 & (ps.layer_23 | ps.layer_4) & ps.clean_clusters;
keep_spikes = ps.clean_clusters & ps.regular_spikes & ~(ps.c1c2 | ps.v1);
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['ACCEPT_other_barrel_S'];
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;

% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L5a, L5b, L6
keep_spikes = ~(ps.layer_23 | ps.layer_4) & ~ps.clean_clusters;
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['REJECT_deep'];
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;

% %PUBLISH ALL SNR VIOLATORS % Publish all stability violations % PUBLISH ALL ISI VIOLATORS
start_ind = 1;
iter = 1;
keep_spikes = ~ps.clean_clusters & ps.regular_spikes & ~ps.v1 & (ps.layer_23|ps.layer_4);
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order_sort = order_sort(ind,:);
while start_ind <= size(order_sort,1);
     end_ind = min(size(order_sort,1),start_ind+30);
     order = order_sort(start_ind:end_ind,:);
     outputDir = ['REJECT_L234_part_' num2str(iter)];
     publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;
     start_ind = end_ind+1;
     iter = iter+1;
end

% %PUBLISH ALL SNR VIOLATORS % Publish all stability violations % PUBLISH ALL ISI VIOLATORS
start_ind = 1;
iter = 1;
keep_spikes = ps.clean_clusters & ps.regular_spikes & ~(ps.c1c2 | ps.v1);
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order_sort = order_sort(ind,:);
while start_ind <= size(order_sort,1);
     end_ind = min(size(order_sort,1),start_ind+45);
     order = order_sort(start_ind:end_ind,:);
     outputDir = ['ACCEPT_other_barrel_part_' num2str(iter)];
     publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;
     start_ind = end_ind+1;
     iter = iter+1;
end


% %PUBLISH ALL SNR VIOLATORS % Publish all stability violations % PUBLISH ALL ISI VIOLATORS
start_ind = 1;
iter = 1;
keep_spikes = ps.clean_clusters & ~ps.regular_spikes & ~(ps.v1);
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order_sort = order_sort(ind,:);
while start_ind <= size(order_sort,1);
     end_ind = min(size(order_sort,1),start_ind+45);
     order = order_sort(start_ind:end_ind,:);
     outputDir = ['ACCEPT_fast_part_' num2str(iter)];
     publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;
     start_ind = end_ind+1;
     iter = iter+1;
end


% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L2/3, L4
%keep_spikes = ~ps.c1c2 & (ps.layer_23 | ps.layer_4) & ps.clean_clusters;
keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1;
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['ACCEPT_all_barrel'];
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;


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
%%%%%%%%% FIGURE 2 sensory variables

output = summarize_tuning_sig(all_anm.data{1}.d,1);

%
output = summarize_tuning(all_anm.data{1}.d,1);

figure(312); clf(312);
hold on
x_vals = repmat(linspace(0,4,2001),12,1);
scatter(x_vals(:),output.sense_mat_avg(:),[],30-output.sense_mat_avg(:),'filled')

c_map = zeros(64,3);
c_map(1:24,1) = linspace(144,(253+144)/2,24)/256;
c_map(1:24,2) = linspace(185,(174+185)/2,24)/256;
c_map(1:24,3) = linspace(247,(107+247)/2,24)/256;
c_map(24:42,1) = linspace((253+144)/2,253,19)/256;
c_map(24:42,2) = linspace((174+185)/2,174,19)/256;
c_map(24:42,3) = linspace((107+247)/2,107,19)/256;
c_map(42:64,1) = linspace(253,239,23)/256;
c_map(42:64,2) = linspace(174,101,23)/256;
c_map(42:64,3) = linspace(107,72,23)/256;
set(gcf,'colormap',c_map)
%set(gca,'ydir','rev')
set(gca,'visible','off')
scatter(linspace(0,4,2001),output.sense_mat_avg(3,:),[],'k','filled')

figure; plot(output.sense_trace_time,'k','LineWidth',2)
set(gca,'visible','off'); xlim([1 500]); ylim([8 22.5])
%plot(linspace(0,4,2001),output.sense_mat_avg(3,:),'k','LineWidth',3)

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
%%%%%%%%% FIGURE 2 WALL DIST TUNING

ih = 10; % all on
plot_clusters_tuning_paper4(all_anm,ps,ps.total_order(ih,:),1,rasters)

ih = 168; % tuned on
plot_clusters_tuning_paper4(all_anm,ps,ps.total_order(ih,:),1,rasters)

ih = 208; % all off
plot_clusters_tuning_paper4(all_anm,ps,ps.total_order(ih,:),1,rasters)

ih = 32; % tuned off
plot_clusters_tuning_paper4(all_anm,ps,ps.total_order(ih,:),1,rasters)

ih = 13; % towards on
plot_clusters_tuning_paper4(all_anm,ps,ps.total_order(ih,:),1,rasters)

ih = 59; % mixed
plot_clusters_tuning_paper4(all_anm,ps,ps.total_order(ih,:),1,rasters)

ih = 76; % mixed
plot_clusters_tuning_paper4(all_anm,ps,ps.total_order(ih,:),1,rasters)

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
%%%%%%%%% FIGURE 2 WALL DIST TUNING

keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6;

mod_up = keep_spikes & ps.tc_mod >=0;
tc = curves.tuning_curve(mod_up,:);
max_loc = ps.act_loc(mod_up);
[ord ind] = sort(max_loc');
tc = zscore(tc')';
%plot(ps.touch_max_loc(keep_spikes),ps.touch_peak_rate(keep_spikes),'.k')
tc_sort = tc(ind,:);
%tc_sort(tc_sort<-1.5) = -1.5;

mod_down = keep_spikes & ps.tc_mod <0;
tc = curves.tuning_curve(mod_down,:);
min_loc = ps.sup_loc(mod_down);
[ord ind] = sort(min_loc','descend');
tc = zscore(tc')';
%plot(ps.touch_max_loc(keep_spikes),ps.touch_peak_rate(keep_spikes),'.k')
tc_sort = cat(1,tc_sort,tc(ind,:));
tc_sort(tc_sort>3) = 3;
tc_sort(tc_sort<-2) = -2;

figure(22)
clf(22)
set(gcf,'Position',[394   366   516   440])
imagesc(tc_sort)
%cmap = cbrewer('seq','Greys',64);
cmap = cbrewer('div','RdYlBu',64);
cmap = flipdim(cmap,1);
colormap(cmap);
set(gca,'visible','off')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc = curves.tuning_curve(keep_spikes,:);
layer_id_red = ps.layer_id(keep_spikes);
[coeff,score,latent] = pca(tc);

[score,coeff] = nnmf(tc,2);
coeff = coeff';
%
figure; plot(coeff(:,1:2))
figure; hold on;
plot(score(layer_id_red>3,1),score(layer_id_red>3,2),'.k')
plot(score(layer_id_red<=3,1),score(layer_id_red<=3,2),'.r')

figure; plot(coeff(:,4))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% FIGURE 2 TEMPORAL TUNING

keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6;

mod_up = keep_spikes; % & abs(ps.dir_mod) <=0.2;
tc = [curves.trace_towards(mod_up,:) curves.trace_away(mod_up,:)];
[max_val ind_max] = max(tc');
%ind_max(ind_max>500) = 1000 - ind_max(ind_max>500);
[ord ind] = sort(ind_max');
tc = zscore(tc')';
%plot(ps.touch_max_loc(keep_spikes),ps.touch_peak_rate(keep_spikes),'.k')
tc_sort = [tc(ind,:)];
%tc_sort(tc_sort<-1.5) = -1.5;

figure(23)
clf(23)
set(gcf,'Position',[911   366   516/2   440])
imagesc(tc_sort(:,1:500))
%cmap = cbrewer('seq','Greys',64);
cmap = cbrewer('div','RdYlBu',64);
cmap = flipdim(cmap,1);
colormap(cmap);
set(gca,'visible','off')

figure(24)
clf(24)
set(gcf,'Position',[1169   366   516/2   440])
imagesc(tc_sort(:,501:end))
%cmap = cbrewer('seq','Greys',64);
cmap = cbrewer('div','RdYlBu',64);
cmap = flipdim(cmap,1);
colormap(cmap);
set(gca,'visible','off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% FIGURE 2 SUMMARY SCATTER PLOTS

keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6;
sum(keep_spikes)

%%
figure(6); clf(6)
hold on
set(gcf,'Position',[   440   648   408   408])
act = ps.act(keep_spikes);
sup = ps.sup(keep_spikes);
act(act>20) = 20;
plot(act,sup,'.k','MarkerSize',15)
xlabel('Activation (Hz)','FontSize',20)
ylabel('Supression (Hz)','FontSize',20)
set(gca,'box','off')
set(gca,'TickDir','out')
set(gca,'position',[0.2163    0.1635    0.7    0.7])
xlim([0 20]); ylim([0 20]);
set(gca,'xtick',[0:5:20])
set(gca,'ytick',[0:5:20])
set(gca,'FontSize',20)

%%
figure(9); clf(9);
set(gcf,'Position',[   440   648   408   408])
set(gca,'position',[0.2163    0.1635    0.7    0.7])
hold on;
plot(ps.towards(keep_spikes),ps.away(keep_spikes),'.k','MarkerSize',15)
%plot([0 30],[0 30],'r','LineWidth',2)
xlabel('Towards (Hz)','FontSize',20)
ylabel('Away (Hz)','FontSize',20)
set(gca,'box','off')
set(gca,'TickDir','out')
xlim([0 30]); ylim([0 30]);
set(gca,'FontSize',20)

figure(8); clf(8);
set(gcf,'Position',[   440   648   408   408])
hold on;
plot([-1 1],[0 0],'r'); plot([0 0],[-1 1],'r');
plot(ps.tc_mod(keep_spikes),ps.dir_mod(keep_spikes),'.k','MarkerSize',15)
ylabel('Direction modulation index','FontSize',20); xlabel('Tuning modulation index','FontSize',20)
xlim([-1 1]); ylim([-1 1]);
set(gca,'box','off')
set(gca,'TickDir','out')
set(gca,'position',[0.2163    0.1635    0.7    0.7])
set(gca,'FontSize',20)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6;
sum(keep_spikes)

figure; hold on;
plot([-300 500],[0 0],'r');
plot(ps.layer_4_dist_CSD(keep_spikes),ps.tc_mod(keep_spikes),'.k')



figure; hold on;
plot([-300 500],[0 0],'r');
plot(ps.layer_4_dist_FINAL(keep_spikes),ps.dir_mod(keep_spikes),'.k')


keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6;
edges = [-250:100:450];
firingrate_vs_depth_new(ps.layer_4_dist_FINAL(keep_spikes),ps.tc_mod(keep_spikes),edges)
plot(ps.layer_4_dist_FINAL(keep_spikes),ps.tc_mod(keep_spikes),'.k')
xlim([-250 450])

keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6;
edges = [-250:100:450];
firingrate_vs_depth_new(ps.layer_4_dist_FINAL(keep_spikes),ps.dir_mod(keep_spikes),edges)
plot(ps.layer_4_dist_FINAL(keep_spikes),ps.dir_mod(keep_spikes),'.k')
xlim([-250 450])

keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6;
edges = [-250:100:450];
firingrate_vs_depth_new(ps.layer_4_dist_FINAL(keep_spikes),ps.baseline(keep_spikes),edges)
plot(ps.layer_4_dist_FINAL(keep_spikes),ps.baseline(keep_spikes),'.k')
xlim([-250 450])

keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6;
edges = [-250:100:450];
firingrate_vs_depth_new(ps.layer_4_dist_FINAL(keep_spikes),ps.baseline(keep_spikes) + ps.act(keep_spikes),edges)
plot(ps.layer_4_dist_FINAL(keep_spikes),ps.baseline(keep_spikes) + ps.act(keep_spikes),'.k')
xlim([-250 450])

keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6;
edges = [-250:100:450];
firingrate_vs_depth_new(ps.layer_4_dist_FINAL(keep_spikes),ps.layer_4_dist_FINAL(keep_spikes),edges)
xlim([-250 450])


keep_spikes = ~ps.v1 & ps.r2 > 0.6 & (ps.layer_4_dist_FINAL > -250 & ps.layer_4_dist_FINAL < 450);
edges = [-250:100:450];
firingrate_vs_depth_new(ps.layer_4_dist_FINAL(keep_spikes),ps.dir_mod(keep_spikes),edges)
plot(ps.layer_4_dist_FINAL(keep_spikes),ps.dir_mod(keep_spikes),'.k')
xlim([-250 450])

keep_spikes = ~ps.v1 & ps.r2 > 0.6 & (ps.layer_4_dist_FINAL > -250 & ps.layer_4_dist_FINAL < 450);
edges = [-250:100:450];
firingrate_vs_depth_new(ps.layer_4_dist_FINAL(keep_spikes),ps.tc_mod(keep_spikes),edges)
plot(ps.layer_4_dist_FINAL(keep_spikes),ps.tc_mod(keep_spikes),'.k')
xlim([-250 450])

keep_spikes = ~ps.v1 & ps.r2 > 0.6 & (ps.layer_4_dist_FINAL > -250 & ps.layer_4_dist_FINAL < 450);
edges = [-250:100:450];
firingrate_vs_depth_new(ps.layer_4_dist_FINAL(keep_spikes),ps.baseline(keep_spikes),edges)
plot(ps.layer_4_dist_FINAL(keep_spikes),ps.baseline(keep_spikes),'.k')
xlim([-250 450])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% FIGURE 3

edges = [-1:.25:1];
sup_mod = hist(ps.tc_mod(keep_spikes & (ps.layer_4 | ps.layer_23)),edges);
sup_mod = sup_mod/sum(sup_mod);
deep_mod = hist(ps.tc_mod(keep_spikes & (ps.layer_5a | ps.layer_5b)),edges);
deep_mod = deep_mod/sum(deep_mod);
figure(1); clf(1); hold on;
set(gcf,'Position',[306   651   3*187   3*155])
subplot(2,1,2)
hd = bar(edges,deep_mod);
set(hd,'FaceColor','k');
set(hd,'EdgeColor','k');
xlim([-1.2 1.2])
ylim([0 1])
set(gca,'FontSize',20)
subplot(2,1,1)
hs = bar(edges,sup_mod);
set(hs,'FaceColor','r');
set(hs,'EdgeColor','r');
xlim([-1.2 1.2])
ylim([0 1])
set(gca,'FontSize',20)


edges = [-1:.25:1];
sup_mod = hist(ps.dir_mod(keep_spikes & (ps.layer_4 | ps.layer_23)),edges);
sup_mod = sup_mod/sum(sup_mod);
deep_mod = hist(ps.dir_mod(keep_spikes & (ps.layer_5a | ps.layer_5b)),edges);
deep_mod = deep_mod/sum(deep_mod);
figure(2); clf(2); hold on;
set(gcf,'Position',[494   651   3*187   3*155])
subplot(2,1,2)
hd = bar(edges,deep_mod);
set(hd,'FaceColor','k');
set(hd,'EdgeColor','k');
xlim([-1.2 1.2])
ylim([0 .5])
set(gca,'FontSize',20)
subplot(2,1,1)
hs = bar(edges,sup_mod);
set(hs,'FaceColor','r');
set(hs,'EdgeColor','r');
xlim([-1.2 1.2])
ylim([0 .5])
set(gca,'FontSize',20)


edges = [0:1:8];
sup_mod = hist(ps.baseline(keep_spikes & (ps.layer_4 | ps.layer_23)),edges);
sup_mod = sup_mod/sum(sup_mod);
deep_mod = hist(ps.baseline(keep_spikes & (ps.layer_5a | ps.layer_5b)),edges);
deep_mod = deep_mod/sum(deep_mod);
figure(3); clf(3); hold on;
set(gcf,'Position',[119   651   3*187   3*155])
subplot(2,1,2)
hd = bar(edges,deep_mod);
set(hd,'FaceColor','k');
set(hd,'EdgeColor','k');
xlim([-0.5 8.5])
ylim([0 .75])
set(gca,'FontSize',20)
subplot(2,1,1)
hs = bar(edges,sup_mod);
set(hs,'FaceColor','r');
set(hs,'EdgeColor','r');
xlim([-0.5 8.5])
ylim([0 .75])
set(gca,'FontSize',20)


ps.peak = ps.baseline + ps.act;
edges = [0:2:14];
sup_mod = hist(ps.peak(keep_spikes & (ps.layer_4 | ps.layer_23)),edges);
sup_mod = sup_mod/sum(sup_mod);
deep_mod = hist(ps.peak(keep_spikes & (ps.layer_5a | ps.layer_5b)),edges);
deep_mod = deep_mod/sum(deep_mod);
figure(4); clf(4); hold on;
set(gcf,'Position',[681   651   3*187   3*155])
subplot(2,1,2)
hd = bar(edges,deep_mod);
set(hd,'FaceColor','k');
set(hd,'EdgeColor','k');
xlim([-0.5 15.5])
ylim([0 .75])
set(gca,'FontSize',20)
subplot(2,1,1)
hs = bar(edges,sup_mod);
set(hs,'FaceColor','r');
set(hs,'EdgeColor','r');
xlim([-0.5 15.5])
ylim([0 .75])
set(gca,'FontSize',20)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
anm_id = all_anm.names{13}
anm_num = str2num(anm_id);
keep_spikes = ps.anm_id == anm_num;
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);

plot_clusters_tuning_paper_opto(all_anm,ps,order(1,:),1,[])



plot_clusters_tuning_paper_opto(all_anm,ps,ps.total_order(284,:),1,[])
plot_clusters_tuning_paper_opto(all_anm,ps,ps.total_order(338,:),1,[])

plot_clusters_tuning_only(all_anm,ps,ps.total_order(335,:),0)
plot_clusters_tuning_only(all_anm,ps,ps.total_order(338,:),0)

plot_clusters_tuning_only(all_anm,ps,ps.total_order(258,:),0)
plot_clusters_tuning_only(all_anm,ps,ps.total_order(262,:),0)


plot_clusters_tuning_paper3_both(all_anm,ps,ps.total_order(258,:),1,rasters)


i_anm = 11;
i_c1 = 6;
i_c2 = 10;

amp_1 = all_anm.data{i_anm}.d.summarized_cluster{i_c1}.mean_spike_amp;
amp_2 = all_anm.data{i_anm}.d.summarized_cluster{i_c2}.mean_spike_amp;

figure;
clf;
hold on
plot(amp_1,'k')
plot(amp_2,'b')

mean_spike_amp


i_anm = 13;
i_c1 = 2;
spike_times = all_anm.data{i_anm}.d.summarized_cluster{i_c1}.spike_times_ephys;
spike_trials = all_anm.data{i_anm}.d.summarized_cluster{i_c1}.spike_trials;
trial_range = [all_anm.data{i_anm}.d.anm_params.trial_range_start(1):min(all_anm.data{i_anm}.d.anm_params.trial_range_end(1),4000)];
laser_data = all_anm.data{i_anm}.laser_data;
first_only = 0;
RASTER = get_evoked_spike_probability(spike_times,spike_trials,trial_range,laser_data,first_only)
figure; plot_spk_psth([],RASTER)
figure; plot_spk_raster([],RASTER,[],[],[])




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dir_name = '/Users/sofroniewn/Documents/DATA/ephys_summary_rev14';
if exist(dir_name)~=7
   mkdir(dir_name);
end
cd(dir_name);

%% PUBLISH ALL ANIMALS one by one
ps.opto_anm = zeros(length(ps.anm_id),1);
 for ij = 11:numel(all_anm_id)
      anm_id = all_anm.names{ij}
      anm_num = str2num(anm_id);
      ps.opto_anm = ps.opto_anm | (ps.anm_id == anm_num);
end

keep_spikes = ps.opto_anm & ps.clean_clusters;
      order_sort = ps.total_order(keep_spikes,:);
      [val ind] = sort(order_sort(:,4));
      order = order_sort(ind,:);
      outputDir = ['ALL_both_clean'];
      publish('publish_all_ephys3.m','showCode',false,'outputDir',outputDir); close all;
 
dir_name = '/Users/sofroniewn/Documents/DATA/ephys_summary_rev14';
if exist(dir_name)~=7
   mkdir(dir_name);
end
cd(dir_name);

% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L2/3, L4
%keep_spikes = ~ps.c1c2 & (ps.layer_23 | ps.layer_4) & ps.clean_clusters;
keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6 & (ps.layer_23 | ps.layer_4);
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['ACCEPT_all_tune_sup'];
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;

% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L2/3, L4
%keep_spikes = ~ps.c1c2 & (ps.layer_23 | ps.layer_4) & ps.clean_clusters;
keep_spikes = ~ps.clean_clusters & ~ps.v1 & ps.r2 > 0.6 & (ps.layer_23 | ps.layer_4);
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['REJECT_all_tune_sup'];
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;

% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L2/3, L4
%keep_spikes = ~ps.c1c2 & (ps.layer_23 | ps.layer_4) & ps.clean_clusters;
keep_spikes = ~ps.clean_clusters & ~ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6 & (ps.layer_23 | ps.layer_4);
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['REJECT_FS_all_tune_sup'];
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;

% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L2/3, L4
%keep_spikes = ~ps.c1c2 & (ps.layer_23 | ps.layer_4) & ps.clean_clusters;
keep_spikes = ps.clean_clusters & ~ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6 & (ps.layer_23 | ps.layer_4);
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['ACCEPT_FS_all_tune_sup'];
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;


% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L2/3, L4
%keep_spikes = ~ps.c1c2 & (ps.layer_23 | ps.layer_4) & ps.clean_clusters;
keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.v1 & ps.r2 > 0.6 & ~(ps.layer_23 | ps.layer_4);
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['ACCEPT_all_tune_deep'];
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;

% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L2/3, L4
%keep_spikes = ~ps.c1c2 & (ps.layer_23 | ps.layer_4) & ps.clean_clusters;
keep_spikes = ps.clean_clusters & ~ps.v1 & ps.opto_anm;
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['ACCEPT_with_fs_opto'];
publish('publish_all_ephys3.m','showCode',false,'outputDir',outputDir); close all;

% PUBLISH ALL CLEAN CLUSTERS IN C1C2, L2/3, L4
%keep_spikes = ~ps.c1c2 & (ps.layer_23 | ps.layer_4) & ps.clean_clusters;
keep_spikes = ~ps.clean_clusters & ~ps.v1 & ps.opto_anm;
sum(keep_spikes)
order_sort = ps.total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order = order_sort(ind,:);
outputDir = ['REJECT_with_fs_opto'];
publish('publish_all_ephys3.m','showCode',false,'outputDir',outputDir); close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ij = 11:numel(all_anm_id)
  [base_dir anm_params] = ephys_anm_id_database(all_anm.names{ij},0)
  trial_range =  [anm_params.trial_range_start(1):min(anm_params.trial_range_end(1),4000)];
  [laser_data] = func_extract_laser_power(base_dir, trial_range, 'laser_data_all', 1);
  all_anm.data{ij}.laser_data = laser_data;
end


clust_id = 13;

spike_times = all_anm.data{12}.d.summarized_cluster{clust_id}.ephys_time;
spike_trials = all_anm.data{12}.d.summarized_cluster{clust_id}.trial_num;
first_only = 0;
RASTER = get_evoked_spike_probability(spike_times,spike_trials,trial_range,laser_data,first_only)
figure; plot_spk_psth([],RASTER)
figure; plot_spk_raster([],RASTER)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




curves.onset(curves.onset < 0) = 0;
curves.offset(curves.offset < 0) = 0;

figure(1);
clf(1)
hold on
temp_asym = zeros(size(curves.offset,1),1);
for ind_1 = 1:size(curves.offset,1);
%figure(1);
%clf(1)
%hold on
%plot(curves.offset(ind_1,:))
%plot(curves.onset(ind_1,:))
curves_mod = (curves.onset(ind_1,:) - curves.offset(ind_1,:))./(curves.onset(ind_1,:) + curves.offset(ind_1,:));
curves_acc = max([curves.onset(ind_1,:);curves.offset(ind_1,:)])>1; 
curves_mod(~curves_acc) = NaN;
temp_asym(ind_1) = nanmean(curves_mod);
%plot(curves_mod,'r')
end

temp_asym(isnan(temp_asym)) = 0;
temp_asym = abs(temp_asym);

avg_on = mean(curves.onset(:,1:40),2);
avg_off = mean(curves.offset(:,1:40),2);

temp_asym = (avg_on - avg_off);
temp_tot = (avg_off + avg_on);

temp_mod = abs(temp_asym)>2.1;
%temp_asym = abs(temp_asym);
%temp_asym = temp_asym./temp_tot;


thresh = [0:.1:10];
frac_fn_thresh = zeros(length(thresh),4);
keep_spikes = ps.regular_spikes & ~ps.v1 & ps.clean_clusters & ps.mod_up < 1 & ps.mod_down > 1;
for ij = 1:length(thresh)
  frac_fn_thresh(ij,1) = sum(keep_spikes & ps.layer_23 & abs(temp_asym)>thresh(ij))/sum(keep_spikes & ps.layer_23);
  frac_fn_thresh(ij,2) = sum(keep_spikes & ps.layer_4 & abs(temp_asym)>thresh(ij))/sum(keep_spikes & ps.layer_4);
  frac_fn_thresh(ij,3) = sum(keep_spikes & ps.layer_5a & abs(temp_asym)>thresh(ij))/sum(keep_spikes & ps.layer_5a);
  frac_fn_thresh(ij,4) = sum(keep_spikes & ps.layer_5b & abs(temp_asym)>thresh(ij))/sum(keep_spikes & ps.layer_5b);
end

figure(111)
clf(111)
hold on
col_mat = [1 0 0;0 1 0;0 0 1;0 0 0];
for ij = 1:4
plot(thresh',frac_fn_thresh(:,ij)','Color',col_mat(ij,:))
end




thresh = [0:.1:10];
frac_fn_thresh = zeros(length(thresh),2);
keep_spikes = ps.regular_spikes & ~ps.v1 & ps.clean_clusters & ps.mod_up > 1 & ps.mod_down < 1;
for ij = 1:length(thresh)
  frac_fn_thresh(ij,1) = sum(keep_spikes & (ps.layer_23 | ps.layer_4) & abs(temp_asym)>thresh(ij))/sum(keep_spikes & (ps.layer_23 | ps.layer_4));
  frac_fn_thresh(ij,2) = sum(keep_spikes & (ps.layer_5a | ps.layer_5b) & abs(temp_asym)>thresh(ij))/sum(keep_spikes & (ps.layer_5a | ps.layer_5b));
end

figure(111)
clf(111)
hold on
col_mat = [1 0 0;0 0 0];
for ij = 1:2
plot(thresh',1-frac_fn_thresh(:,ij)','Color',col_mat(ij,:))
end




thresh = [0:.1:10];
frac_fn_thresh = zeros(length(thresh),2);
keep_spikes = ps.regular_spikes & ~ps.v1 & ps.clean_clusters; % & ps.mod_up > 1 & ps.mod_down < 1;
for ij = 1:length(thresh)
  frac_fn_thresh(ij,1) = sum(keep_spikes & (ps.layer_23 | ps.layer_4) & ps.mod_up > thresh(ij) & ps.mod_down > thresh(ij))/sum(keep_spikes & (ps.layer_23 | ps.layer_4));
  frac_fn_thresh(ij,2) = sum(keep_spikes & (ps.layer_5a | ps.layer_5b) & ps.mod_up > thresh(ij) & ps.mod_down > thresh(ij))/sum(keep_spikes & (ps.layer_5a | ps.layer_5b));
end

figure(112)
clf(112)
hold on
col_mat = [1 0 0;0 0 0];
for ij = 1:2
plot(thresh',1-frac_fn_thresh(:,ij)','Color',col_mat(ij,:))
end




temp_mod = (avg_on./avg_off); %abs(temp_asym)>2;
y_mat = [temp_mod];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
keep_spikes = ps.regular_spikes & ~ps.v1 & ps.clean_clusters & ps.mod_up > 1 & ps.mod_down < 1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,keep_spikes,1,0)


ind_1 = 3;
figure(1);
clf(1)
hold on
plot(curves.offset(ind_1,:))
plot(curves.onset(ind_1,:))
curves_mod = (curves.onset(ind_1,:) - curves.offset(ind_1,:))./(curves.onset(ind_1,:) + curves.offset(ind_1,:));
curves_acc = max([curves.onset(ind_1,:);curves.offset(ind_1,:)])>1; 
curves_mod(~curves_acc) = NaN;
plot(curves_mod,'r')

figure
hold on
keep_spikes = ps.regular_spikes & ~ps.v1 & ps.clean_clusters & ps.mod_up > 1 & ps.mod_down < 1;
plot(temp_tot(keep_spikes),temp_asym(keep_spikes),'.k')

  45
   167
   171
   270

figure
keep_spikes = ps.regular_spikes & ~ps.v1 & ps.clean_clusters;
plot(temp_asym(keep_spikes),ps.mod_down(keep_spikes),'.k')





% log running and touch modulation by layer
y_mat = [ps.mod_up > 1 & ps.mod_down <= 1, ps.mod_up > 1 & ps.mod_down > 1, ps.mod_up <= 1 & ps.mod_down > 1];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
keep_spikes = ps.regular_spikes & ps.c1c2 & ps.clean_clusters & ~(ps.mod_up <= 1 & ps.mod_down <= 1);
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,keep_spikes,1,0)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TUNING CURVES
keep_spikes = ps.clean_clusters & ps.touch_peak_rate>2 & ps.regular_spikes & (ps.layer_4|ps.layer_23);
sum(keep_spikes)
tc = 1.6648*curves.mean_tuning_curves(keep_spikes,:);
%max_val = max(tc')';
%tc = bsxfun(@rdivide,tc,max_val);
%tc = zscore(tc')';

f_nc = tc;
[perf_sup rate_sup N_sup] = decode_population(f_nc,[1:2:40]);

keep_spikes = ps.clean_clusters & ps.touch_peak_rate>2 & ps.regular_spikes & ~(ps.layer_4|ps.layer_23);
sum(keep_spikes)
tc = curves.mean_tuning_curves(keep_spikes,:);
%max_val = max(tc')';
%tc = bsxfun(@rdivide,tc,max_val);
%tc = zscore(tc')';

f_nc = tc;
[perf_deep rate_deep N_deep] = decode_population(f_nc,[1:2:40]);



figure;
subplot(1,2,1)
hold on
plot(N_sup,mean(perf_sup,2),'r')
plot(N_deep,mean(perf_deep,2),'k')
subplot(1,2,2)
hold on
plot(N_sup,mean(rate_sup,2),'r')
plot(N_deep,mean(rate_deep,2),'k')


figure;
hold on
subplot(1,2,1)
hold on
plot([1:size(f_nc,2)]/2,perf_sup(end,:),'r')
plot([1:size(f_nc,2)]/2,perf_deep(end,:),'k')
subplot(1,2,2)
hold on
plot([1:size(f_nc,2)]/2,rate_sup(end,:),'r')
plot([1:size(f_nc,2)]/2,rate_deep(end,:),'k')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TUNING CURVES
keep_spikes = ps.clean_clusters & ps.touch_peak_rate>2 & ps.regular_spikes;
sum(keep_spikes)
tc = curves.mean_tuning_curves(keep_spikes,:);
%max_val = max(tc')';
%tc = bsxfun(@rdivide,tc,max_val);
%tc = zscore(tc')';

f_nc = tc;
[perf_sup rate_sup N_sup] = decode_population(f_nc,[1:4:40]);


figure;
hold on
plot(N_sup,mean(perf_sup,2),'r')
plot(N_sup,mean(rate_sup,2),'g')


figure;
hold on
plot([1:size(f_nc,2)]/2,perf_sup(end,:),'r')
plot([1:size(f_nc,2)]/2,rate_sup(end,:),'g')





figure
keep_spikes = (ps.layer_4|ps.layer_23) & ps.clean_clusters & ps.touch_peak_rate>2 & ps.mod_down < 1;
tc = curves.mean_tuning_curves(keep_spikes,:);
[max_val ind_max] = max(tc');
max_loc = ps.touch_max_loc(keep_spikes);
[ord ind] = sort(ind_max');
max_val = max(tc')';
tc = bsxfun(@rdivide,tc,max_val);
%plot(ps.touch_max_loc(keep_spikes),ps.touch_peak_rate(keep_spikes),'.k')
imagesc(tc(ind,:))

figure
keep_spikes = ps.clean_clusters & ps.touch_peak_rate>2 & ps.mod_down < 1;
tc = curves.mean_tuning_curves(keep_spikes,:);
[max_val ind_max] = max(tc');
max_loc = ps.touch_max_loc(keep_spikes);
[ord ind] = sort(ind_max');
max_val = max(tc')';
%max_val = bsxfun(@max,max_val,2);
tc = zscore(tc')';
%tc = bsxfun(@rdivide,tc,max_val);
%plot(ps.touch_max_loc(keep_spikes),ps.touch_peak_rate(keep_spikes),'.k')
imagesc(tc(ind,:),[-2.5 2.5])

figure
keep_spikes = ps.clean_clusters & ps.touch_peak_rate>2 & ps.mod_down >= 1;
tc = curves.mean_tuning_curves(keep_spikes,:);
[max_val ind_max] = min(tc');
[ord ind] = sort(ind_max');
max_val = max(tc')';
%max_val = bsxfun(@max,max_val,2);
%tc = zscore(tc);
%tc = bsxfun(@rdivide,tc,max_val);
tc = zscore(tc')';

%plot(ps.touch_max_loc(keep_spikes),ps.touch_peak_rate(keep_spikes),'.k')
imagesc(tc(ind,:))


figure
keep_spikes = ps.clean_clusters & ps.touch_peak_rate>2 & ps.mod_down < 1;
% tc = mean_tuning_curves(keep_spikes,:);
% [max_val ind_max] = min(tc');
% [ord ind] = sort(ind_max');
% max_val = max(tc')';
% %max_val = bsxfun(@max,max_val,2);
% %tc = zscore(tc);
% %tc = bsxfun(@rdivide,tc,max_val);
% tc = zscore(tc')';

half_width = zeros(size(curves.mean_tuning_curves,1),1);
max_loc = zeros(size(curves.mean_tuning_curves,1),1);
for ij = 1:size(curves.mean_tuning_curves,1)
    tc = curves.mean_tuning_curves(ij,:);
    tc = tc - mean(tc(40:end));
    [max_val_i ind_max] = max(tc);
    ind_2 = find(tc(ind_max:end)<max_val_i/2,1,'first')+ind_max-1;
    ind_1 = find(tc(1:ind_max)<max_val_i/2,1,'last');
    if ~isempty(ind_1) & ~isempty(ind_2)
        half_width(ij) = ind_2 - ind_1;
    else
        half_width(ij) = NaN;
    end
    max_loc(ij) = ind_max;
end
keep_spikes = keep_spikes & ~isnan(half_width);
scatter(max_loc(keep_spikes)/2,half_width(keep_spikes)/2,[],ps.mod_up(keep_spikes))
%imagesc(tc(ind,:))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


keep_spikes = ps.clean_clusters & ps.regular_spikes & (ps.layer_4 | ps.layer_23);
figure;
hold on
plot([0 25],[0 25],'r')
plot(ps.no_walls_still_rate(keep_spikes),ps.no_walls_run_rate(keep_spikes),'.k')
xlim([0 25])
ylim([0 25])


keep_spikes = ps.clean_clusters & ps.regular_spikes & ~(ps.layer_4 | ps.layer_23);
figure;
hold on
plot([0 25],[0 25],'r')
plot(ps.no_walls_still_rate(keep_spikes),ps.no_walls_run_rate(keep_spikes),'.k')
xlim([0 25])
ylim([0 25])

keep_spikes = ps.clean_clusters & ps.regular_spikes & ~ps.d_row;
figure;
hold on
plot([0 25],[0 25],'r')
plot(ps.no_walls_still_rate(keep_spikes),ps.no_walls_run_rate(keep_spikes),'.k')
xlim([0 25])
ylim([0 25])


% Spike tau
keep_spikes = clean_clusters;
figure(1)
clf(1)
hist(ps.spike_tau(keep_spikes),[0:20:900])
xlabel('Spike tau (us)')
xlim([0 900])

figure(1)
clf(1)
hold on
keep_spikes = clean_clusters & fast_spikes;
plot(time_vect,norm_waves(keep_spikes,:),'r')
keep_spikes = clean_clusters & intermediate_spikes;
plot(time_vect,norm_waves(keep_spikes,:),'k')
keep_spikes = clean_clusters & regular_spikes_fast;
plot(time_vect,norm_waves(keep_spikes,:),'g')
keep_spikes = clean_clusters & regular_spikes_slow;
plot(time_vect,norm_waves(keep_spikes,:),'b')
xlabel('Time (us)')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DISTANCE FROM LAYER 4 OF RECORDINGS
keep_spikes = clean_clusters;
figure(1)
clf(1)
edges = [-600:50:600];
n = histc(ps.layer_4_dist(keep_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlabel('Distance from layer 4 (mm)')
xlim([-600 600])

% LAYER ID OF RECORDINGS
keep_spikes = clean_clusters & c1_close;
figure(34)
clf(34)
edges = unique(ps.layer_id);
n = histc(ps.layer_id(keep_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlim([1 7])
set(gca,'xtick',[2:6])
set(gca,'xticklabel',{'L2/3', 'L4', 'L5a', 'L5b', 'L6'})

% INSIDE BARREL vs OUTSIDE BARREL
keep_spikes = clean_clusters;
figure(34)
clf(34)
insideC1C2 = ismember(ps.barrel_loc,[1 2]);
surround = ismember(ps.barrel_loc,[3:7]);
outside = ismember(ps.barrel_loc,[8]);
h = bar([2 3 4],[sum(insideC1C2(keep_spikes)) sum(surround(keep_spikes)) sum(outside(keep_spikes))]);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlim([1 5])
set(gca,'xtick',[2:4])
set(gca,'xticklabel',{'C1/C2', 'surround', 'outside'})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% number of units by depth
y_mat = [ones(length(ps.anm_id),1) ones(length(ps.anm_id),1) ones(length(ps.anm_id),1)];
keep_mat = [ps.regular_spikes_slow, ps.regular_spikes_fast, ps.fast_spikes];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~ps.layer_6 & ps.clean_clusters,0,1)






% log running and touch modulation
run_mod = ps.no_walls_run_rate./ps.no_walls_still_rate;
run_mod(isinf(run_mod) | isnan(run_mod)) = 10;
touch_mod = ps.touch_peak_rate./ps.no_walls_run_rate;
touch_mod(isinf(touch_mod) | isnan(touch_mod)) = 10;


% log running and touch modulation by barrel
y_mat = log([run_mod touch_mod]);
y_mat(isinf(y_mat)) = 0;
keep_mat = [];
x_labels = {'B/C row', 'D row', 'V1'};
x_vec = barrel_id+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & clean_clusters,1,0)

% log running and touch modulation by layer
y_mat = log([run_mod touch_mod]);
y_mat(isinf(y_mat) | isnan(y_mat)) = 0;
keep_mat = [regular_spikes & (c_row | b_row | d_row), regular_spikes & (c_row | b_row | d_row)];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & clean_clusters,1,0)



% touch distance preference by arc
y_mat = [ps.touch_max_loc];
keep_mat = [];
x_labels = {'C1', 'C2', 'C3', 'C4'};
x_vec = ps.barrel_loc+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & c_row & ps.mod_up > 3 & clean_clusters,1,0)



% log running and touch modulation by layer
y_mat = [ps.no_walls_run_rate ps.walls_run_rate];
y_mat = [abs(temp_asym)];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
keep_spikes = ps.regular_spikes & ps.c1c2 & ps.clean_clusters;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,keep_spikes,1,0)


% log running and touch modulation by layer
y_mat = [ps.touch_min_rate ps.touch_baseline_rate ps.touch_peak_rate];
y_mat(y_mat<0) = 0;
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
keep_spikes = ps.regular_spikes & (ps.c_row | ps.b_row | ps.d_row) & ps.clean_clusters;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,keep_spikes,1,0)


y_mat = [ps.spk_amplitude];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat, clean_clusters,1,0)


% log running and touch modulation by layer
y_mat = [ps.mod_up > 1 & ps.mod_down <= 1, ps.mod_up > 1 & ps.mod_down > 1, ps.mod_up <= 1 & ps.mod_down > 1, ps.mod_up <= 1 & ps.mod_down <= 1];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,keep_spikes,1,0)

y_mat = [ps.mod_up > .5 & ps.mod_down <= .5, ps.mod_up > .5 & ps.mod_down > .5, ps.mod_up <= .5 & ps.mod_down > .5, ps.mod_up <= .5 & ps.mod_down <= .5];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & ~c1_close & regular_spikes & clean_clusters,1,0)


stable_spikes = abs(ps.stab_amp)<1.5 & abs(ps.stab_fr)<1.75;
clean_isi = ps.isi_violations < 1;
good_snr = ps.waveform_SNR > 6;
good_tuning = ps.SNR > 20;

clean_clusters = good_tuning & stable_spikes & clean_isi & good_snr;



% log running and touch modulation by layer
y_mat = ~clean_clusters;
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,true(length(clean_clusters),1),1,0)




y_mat = [choice_prob_all];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & (c_row | b_row | d_row) & clean_clusters,1,0)

y_mat = [choice_prob_all];
keep_mat = [];
x_labels = {'C1', 'C2', 'C3', 'C4'};
x_vec = ps.barrel_loc+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & c_row & clean_clusters,1,0)

% log running and touch modulation by barrel
y_mat = choice_prob_all;
keep_mat = [];
x_labels = {'B/C row', 'D row', 'V1'};
x_vec = barrel_id+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & clean_clusters,1,0)



% figure(1)
% clf(1)
% hold on
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==1 & ps.mod_up > 3 ;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'b');
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==2 & ps.mod_up > 3 ;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'g');
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==3 & ps.mod_up > 3 ;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'r');
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==4 & ps.mod_up > 3;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'c');


figure(1)
clf(1)
hold on
keep_spikes = clean_clusters ;
tc = mean(mean_tuning_curves(keep_spikes,:));
plot(x_fit_vals,tc,'k');
keep_spikes = ~layer_6 & clean_clusters & ~v1 & ps.mod_up > 3 ;
tc = mean(mean_tuning_curves(keep_spikes,:));
plot(x_fit_vals,tc,'b');
keep_spikes = ~layer_6 & clean_clusters & ~v1 & ps.mod_down > 1 & ps.mod_up < 1;
tc = mean(mean_tuning_curves(keep_spikes,:));
plot(x_fit_vals,tc,'r');


% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==2 & ps.mod_up > 3 ;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'g');
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==3 & ps.mod_up > 3 ;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'r');
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==4 & ps.mod_up > 3;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'c');

%
keep_spikes = clean_clusters;
figure(19)
clf(19)
subplot(4,1,1)
hist(ps.spk_amplitude(clean_clusters & layer_23),[0:20:600])
subplot(4,1,2)
hist(ps.spk_amplitude(clean_clusters & layer_4),[0:20:600])
subplot(4,1,3)
hist(ps.spk_amplitude(clean_clusters & layer_5a),[0:20:600])
subplot(4,1,4)
hist(ps.spk_amplitude(clean_clusters & layer_5b),[0:20:600])




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% SPIKE FIRING RATE STABILITY METRIC
figure(1)
clf(1)
hist(abs(ps.stab_fr),[0:.1:3])
xlabel('stability metric')
xlim([0 3])

% WAVEFORM SNR
figure(1)
clf(1)
hist(ps.waveform_SNR,[0:.3:30])
xlabel('waveform SNR')
xlim([0 30])

% ISI VIOLATIONS
figure(1)
clf(1)
hist(ps.isi_violations,[0:.1:5])
xlabel('% isi violations')
xlim([-0.1 5])

% waveform SNR vs ISI
figure(1)
clf(1)
plot(ps.isi_violations,ps.waveform_SNR,'.k')
xlabel('% isi violations')
ylabel('waveform SNR')
xlim([0 70])
ylim([0 30])


% Spike amplitude
figure(1)
clf(1)
hist(ps.spk_amplitude,[0:10:300])
xlabel('spike amplitude (uV)')
xlim([0 300])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



figure(1)
clf(1)
hist(ps.num_spikes,[0:100:10000])
xlabel('tuning SNR')
xlim([0 10000])

figure(1)
clf(1)
plot(ps.isi_violations,ps.waveform_SNR,'.k')
xlabel('% isi violations')
ylabel('waveform SNR')
xlim([0 70])
ylim([0 30])

figure(1)
clf(1)
plot(ps.spk_amplitude,ps.waveform_SNR,'.k')
xlabel('spike amplitude')
ylabel('waveform SNR')
xlim([0 300])
ylim([0 30])

figure(1)
clf(1)
plot(ps.SNR,ps.num_spikes,'.k')




figure(1)
clf(1)
hist(abs(ps.stab_fr),[0:.1:3])
xlabel('% stability')
xlim([0 3])

figure(1)
clf(1)
plot(abs(ps.stab_fr),abs(ps.stab_amp),'.k')

figure(1)
clf(1)
plot(ps.touch_mean_rate,ps.ste./ps.touch_mean_rate,'.k')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%order = order_sort(109:end,:);

%plot_clusters(all_anm,order);

%num2clip(p)

% q = [ps.touch_baseline_rate, log(ps.touch_peak_rate - ps.touch_baseline_rate), log(ps.touch_baseline_rate - ps.touch_min_rate)];

% %q = curves.onset;

% keep_spikes = ps.spike_tau>500 & ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & SNR > 2.5;
% q = q(keep_spikes,:);
% %q = zscore(q);

% %q = cat(2,q,H');
% idx = kmeans(zscore(q),3);

% gplotmatrix(q,q,idx);

% y_mat = [idx==1,idx==2,idx==3,idx==4,idx==5];
% keep_mat = [];
% firingrate_vs_depth(ps,y_mat,keep_mat,1);
%%



% base_rate
resp_type = p(:,17);
figure;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500 & num_trials > 40 & SNR > 2.5;
scatter(layer_4_dist(keep_spikes),spike_tau(keep_spikes),40*run_rate(keep_spikes).^(.2),isi_peak(keep_spikes),'fill')

figure
plot(log(run_rate(keep_spikes)),resp_type(keep_spikes),'.k')

% peak rate
figure;
hist(peak_rate,[0:100])
xlim([0 100])
% spike amp hist - all units

% histogram by depth - high quality units
figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60;
edges= [100:50:900];
hist(spike_tau(keep_spikes),edges)

% From now on hq units only
% tau histogram - split into RS and FS
figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60;
edges= [-550:50:550];
hist(layer_4_dist(keep_spikes),edges)

% histogram by depth rs, fs
figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau < 350;
edges= [-550:50:550];
hist(layer_4_dist(keep_spikes),edges)

% histogram by depth rs, fs
figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
edges= [-550:50:550];
hist(layer_4_dist(keep_spikes),edges)

figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500 & spike_tau < 700;
edges= [-550:50:550];
m = hist(layer_4_dist(keep_spikes),edges)

% histogram by depth rs, fs
figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 700;
edges= [-550:50:550];
n = hist(layer_4_dist(keep_spikes),edges);

figure
q = n./(n+m);
hold on
h = bar(edges,q);
set(h,'FaceColor','b')
set(h,'EdgeColor','b')
h = bar(edges,q-1);
set(h,'FaceColor','g')
set(h,'EdgeColor','g')

% isi_viol wave_snr - all units
figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500 & layer_4_dist >= -50;
plot(spike_tau(keep_spikes),isi_peak(keep_spikes),'.k')
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500 & layer_4_dist < -50;
plot(spike_tau(keep_spikes),isi_peak(keep_spikes),'.g')


figure
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
plot(spike_amp(keep_spikes),spike_tau(keep_spikes),'.g')



% cdf firing rate rs, fs (base_line / peak)

figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
n = hist(base_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'b')
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau < 350;
n = hist(base_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'r')

figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
n = hist(peak_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'b')
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau < 350;
n = hist(peak_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'r')

run_rate = base_rate.*run_mod;
figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
n = hist(run_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'b')
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau < 350;
n = hist(run_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'r')




firingrate_vs_depth(p,p_labels,'baseline');
firingrate_vs_depth(p,p_labels,'peak');
firingrate_vs_depth(p,p_labels,'run_rate');



firingrate_vs_depth(p,p_labels,'peak_isi');








% histogram by depth rs, fs
figure;
hold on
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
edges= [-550:100:550];
n = hist(layer_4_dist(keep_spikes),edges);
n1 = hist(layer_4_dist(keep_spikes & add_vec > 1),edges)./n;
n2 = hist(layer_4_dist(keep_spikes & add_vec < -1),edges)./n;

h = bar(edges,n1);
set(h,'FaceColor','b')
set(h,'EdgeColor','b')
h = bar(edges,-n2);
set(h,'FaceColor','r')
set(h,'EdgeColor','r')
xlim([-600 600])
ylim([-1 1])









ps.chan_depth

mod_up  = ps.touch_peak_rate - ps.touch_baseline_rate;
mod_down  = ps.touch_baseline_rate - ps.touch_min_rate;

figure(2)
clf(2)
set(gcf,'position',[74         520        1316         278])
subplot(1,2,1)
hold on

keep_spikes = ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spike_tau > 500 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & SNR > 2.5;

edges= [-550:100:550];

depth = ps.layer_4_dist(keep_spikes);
[bincounts_0 inds] = histc(depth,edges);


depth = ps.layer_4_dist(keep_spikes & mod_up > .5 & mod_down < .5);
[bincounts_1 inds] = histc(depth,edges);


depth = ps.layer_4_dist(keep_spikes & mod_down > .5);
[bincounts_2 inds] = histc(depth,edges);


bincounts = bincounts_1./(bincounts_0);
bincounts(isinf(bincounts)) = 0;
h = bar(edges,bincounts);
set(h,'FaceColor','b')
set(h,'EdgeColor','b')

bincounts = -bincounts_2./(bincounts_0);
bincounts(isinf(bincounts)) = 0;
h = bar(edges,bincounts);
set(h,'FaceColor','r')
set(h,'EdgeColor','r')
xlim([-550 550])


subplot(1,2,2)
bincounts = (bincounts_0);
h = bar(edges,bincounts);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlim([-550 550])
ylim([0 30])


ps.SNR = SNR;

mod_thresh = 0.5;
mod_thresh = 0.5;

y_mat = [ps.mod_up>mod_thresh & ps.mod_down<mod_thresh, ps.mod_down>mod_thresh];
firingrate_vs_layer(ps,y_mat,[],0)

y_mat = [mod_up>mod_thresh & mod_down <= mod_thresh,  mod_up > mod_thresh & mod_down > mod_thresh, mod_up <= mod_thresh & mod_down > mod_thresh];

y_mat = cp;
keep_mat = ~isnan(cp);
firingrate_vs_layer(ps,y_mat,keep_mat,1);


y_mat = [ps.touch_max_loc, ps.touch_min_loc];
keep_mat = [mod_up>mod_thresh, mod_down>mod_thresh];
firingrate_vs_layer(ps,y_mat,keep_mat,0);

y_mat = [ps.touch_max_loc - ps.touch_min_loc];
keep_mat = [mod_up>mod_thresh & mod_down>mod_thresh];
firingrate_vs_layer(ps,y_mat,keep_mat,0);

%%
keep_spikes = ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spike_tau > 500 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & SNR > 2.5;


y_mat = [ps.no_walls_still_rate, ps.no_walls_run_rate];
firingrate_vs_layer(ps,y_mat,[],1);


y_mat = [ps.touch_peak_rate, ps.touch_baseline_rate, ps.touch_min_rate];
firingrate_vs_layer(ps,y_mat,[],1);

y_mat = [mod_up, mod_down];
keep_mat = [];
firingrate_vs_layer(ps,y_mat,keep_mat,1);


run_mod = ps.no_walls_run_rate - ps.no_walls_still_rate;
y_up = run_mod>0.5;
y_down = run_mod<-0.5;
firingrate_vs_depth(ps,y_up,y_down,[],[]);


ps.adapt = 2*nanmean(curves.onset,2)./(nanmean(curves.onset,2) + nanmean(curves.offset,2))-1;
ps.adapt(isnan(ps.adapt)) = 0;



y_mat = [ps.adapt];
keep_mat = [];
firingrate_vs_layer(ps,y_mat,keep_mat,1)

y_mat = [ps.adapt ps.adapt ps.adapt];
keep_mat = [mod_up>mod_thresh & mod_down <= mod_thresh,  mod_up > mod_thresh & mod_down > mod_thresh, mod_up <= mod_thresh & mod_down > mod_thresh];
firingrate_vs_layer(ps,y_mat,keep_mat,1)




y_mat = [ps.adapt, ps.adapt];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);





y_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
keep_mat = [ps.spike_tau > 500, ps.spike_tau > 500];
firingrate_vs_layer(ps,y_mat,keep_mat,0);

y_mat = [ps.spike_tau>700,  ps.spike_tau<=500, ps.spike_tau>500 & ps.spike_tau<=700];
keep_mat = [];
firingrate_vs_depth(ps,y_mat,keep_mat,0);


y_mat = [ps.no_walls_still_rate, ps.no_walls_still_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);

y_mat = [ps.no_walls_run_rate, ps.no_walls_run_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);

y_mat = [ps.no_walls_run_rate - ps.no_walls_still_rate, ps.no_walls_run_rate - ps.no_walls_still_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);


y_mat = [ps.touch_peak_rate, ps.touch_peak_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);

y_mat = [ps.touch_peak_rate - ps.touch_baseline_rate, ps.touch_peak_rate - ps.touch_baseline_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);

y_mat = [ps.touch_baseline_rate - ps.touch_min_rate, ps.touch_baseline_rate - ps.touch_min_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);


%mod_up>mod_thresh & mod_down>mod_thresh

y_mat = [mod_up>mod_thresh & mod_down>mod_thresh, mod_up>mod_thresh & mod_down>mod_thresh];
keep_mat = [ps.spike_tau>700 , ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_depth(ps,y_mat,keep_mat,1);

y_mat = [mod_up<=mod_thresh & mod_down>mod_thresh, mod_up<=mod_thresh & mod_down>mod_thresh];
keep_mat = [ps.spike_tau>700 , ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_depth(ps,y_mat,keep_mat,1);

y_mat = [mod_up>mod_thresh & mod_down<=mod_thresh, mod_up>mod_thresh & mod_down<=mod_thresh];
keep_mat = [ps.spike_tau>700 , ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_depth(ps,y_mat,keep_mat,1);



y_mat = [ps.touch_max_loc, ps.touch_max_loc];
keep_mat = [ps.spike_tau>700 & mod_up>mod_thresh, ps.spike_tau>500 & ps.spike_tau<=700 & mod_up>mod_thresh];
firingrate_vs_depth(ps,y_mat,keep_mat,1);



y_mat = [ps.touch_min_loc, ps.touch_min_loc];
keep_mat = [ps.spike_tau>700 & mod_down>mod_thresh, ps.spike_tau>500 & ps.spike_tau<=700 & mod_down>mod_thresh];
firingrate_vs_depth(ps,y_mat,keep_mat,1);


%%
ps.touch_baseline_rate(ps.touch_baseline_rate<0) = 0;
ps.touch_min_rate(ps.touch_min_rate<0) = 0;

mod_up_new = (ps.touch_peak_rate - ps.touch_baseline_rate)./(ps.touch_peak_rate + ps.touch_baseline_rate);
mod_up_new(isnan(mod_up_new) | isinf(mod_up_new)) = 0;

mod_down_new = (ps.touch_baseline_rate - ps.touch_min_rate)./(ps.touch_min_rate + ps.touch_baseline_rate);
mod_down_new(isnan(mod_down_new) | isinf(mod_down_new)) = 0;

figure(5);
clf(5)
hold on
keep_spikes = ~layer_6 & regular_spikes & clean_clusters & (c_row | b_row);
%plot([0 25],[1 1],'r')
%plot([1 1],[0 25],'r')
%plot([0 25],[0 25],'r')
plot(mod_up_new(keep_spikes),mod_down_new(keep_spikes),'.k')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
%set(gca,'yscale','log')
%set(gca,'xscale','log')
set(gca,'FontSize',16)

%%

figure(5);
clf(5)
hold on

keep_spikes = clean_clusters & c1_close;

plot([0 25],[.5 .5],'k')
plot([.5 .5],[0 25],'k')
plot([0 25],[0 25],'k')

scatter(ps.mod_up(keep_spikes),ps.mod_down(keep_spikes),[],'r','fill')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
%set(gca,'yscale','log')
%set(gca,'xscale','log')
xlim([0 25])

%%

figure(5);
clf(5)
hold on

keep_spikes = ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spike_tau > 500 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & SNR > 2.5;

plot([0 25],[.5 .5],'k')
plot([.5 .5],[0 25],'k')
plot([0 25],[0 25],'k')

scatter(mod_up(keep_spikes),mod_down(keep_spikes),[],ps.adapt(keep_spikes),'fill')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
%set(gca,'yscale','log')
%set(gca,'xscale','log')
xlim([0 25])


%%%%%%%%%%%%%%%%%%%%%%%%
adapt_curve = curves.onset - curves.offset;

figure
plot(adapt_curve(3,:)')

figure
hold on
plot(curves.onset(1,:),'b')
plot(curves.offset(1,:),'r')


ps.adapt = 2*nanmean(curves.onset,2)./(nanmean(curves.onset,2) + nanmean(curves.offset,2))-1;
ps.adapt(isnan(ps.adapt)) = 0;




%%
mod_thresh = 1;

figure(5);
clf(5)
hold on

keep_spikes = ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spike_tau < 350 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & SNR > 2.5;

plot([0 50],[mod_thresh mod_thresh],'k')
plot([mod_thresh mod_thresh],[0 50],'k')
plot([0 50],[0 50],'k')

plot(mod_up(keep_spikes & mod_up <= mod_thresh & mod_down <= mod_thresh),mod_down(keep_spikes & mod_up <= mod_thresh & mod_down <= mod_thresh),'.k','MarkerSize',20)
plot(mod_up(keep_spikes & mod_up > mod_thresh & mod_down <= mod_thresh),mod_down(keep_spikes & mod_up > mod_thresh & mod_down <= mod_thresh),'.b','MarkerSize',20)
plot(mod_up(keep_spikes & mod_up <= mod_thresh & mod_down > mod_thresh),mod_down(keep_spikes & mod_up <= mod_thresh & mod_down > mod_thresh),'.r','MarkerSize',20)
plot(mod_up(keep_spikes & mod_up > mod_thresh & mod_down > mod_thresh),mod_down(keep_spikes & mod_up > mod_thresh & mod_down > mod_thresh),'.g','MarkerSize',20)

xlabel('Peak - Baseline')
ylabel('Baseline - Min')
%set(gca,'yscale','log')
%set(gca,'xscale','log')
xlim([0 50])
ylim([0 50])



figure(2)
clf(2)
set(gcf,'position',[74         520        1316         278])
subplot(1,2,1)
hold on
x_range = diff(x_lim);
y_range = diff(y_lim_ex);
cur_pos = get(gca,'Position');
scale = y_range/x_range*cur_pos(4)/cur_pos(3);

spike_rate = dependent_var(p(:,7)>5&p(:,6)<.11 & p(:,9)>500 & p(:,16)>1);
depth = p(p(:,7)>5 & p(:,6)<.11 & p(:,9)>500 & p(:,16)>1,4);
edges= [-575:50:575];
[bincounts inds] = histc(depth,edges);
vals = accumarray(inds,spike_rate,[length(edges) 1],@prod);
vals = vals.^(1./bincounts);
h = bar(edges+mean(diff(edges))/2,vals);
set(h,'FaceColor','b')
set(h,'EdgeColor','b')

if type_log
  h = plot(depth,spike_rate,'.k');
  set(h,'MarkerEdgeColor', [0.5 0.5 0.5]);
else
  h = transparentScatter(depth,spike_rate,5,scale,0.5,[0 0 0]);
end

spike_rate = dependent_var(p(:,7)>5&p(:,6)<.11 & p(:,9)>500 & p(:,16)<1);
depth = p(p(:,7)>5 & p(:,6)<.11 & p(:,9)>500 & p(:,16) < 1,4);
edges= [-575:50:575];
[bincounts inds] = histc(depth,edges);
vals = accumarray(inds,spike_rate,[length(edges) 1],@prod);
vals = vals.^(1./bincounts);
h = bar(edges+mean(diff(edges))/2,vals);
set(h,'FaceColor','r')
set(h,'EdgeColor','r')

if type_log
  h = plot(depth,spike_rate,'.k');
  set(h,'MarkerEdgeColor', [0.5 0.5 0.5]);
else
  h = transparentScatter(depth,spike_rate,5,scale,0.5,[0 0 0]);
end

xlim(x_lim)
ylim(y_lim_ex)
if type_log
  set(gca,'yscale','log')
end


%%
figure(3);
clf(3)
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau > 500 & peak_rate > 2 & spike_amp >= 60 & num_trials > 40 & SNR > 2.5;
plot3([0:.1:30],[0:.1:30],[0:.1:30],'k','linewidth',2)
plot3(add_vec_new(keep_spikes,2),add_vec_new(keep_spikes,1),add_vec_new(keep_spikes,3),'.r')
xlabel('Baseline')
ylabel('Peak')
zlabel('Min')
xlim([0 30])
ylim([0 30])
zlim([0 30])


%%
figure(4);
clf(4)
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau > 500 & peak_rate > 2 & spike_amp >= 60 & num_trials > 40 & SNR > 2.5;
plot3([0:.1:30],[0:.1:30],[0:.1:30],'k','linewidth',2)
plot3(add_vec_new(keep_spikes,1)-add_vec_new(keep_spikes,2),add_vec_new(keep_spikes,2)-add_vec_new(keep_spikes,3),add_vec_new(keep_spikes,2),'.r')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
zlabel('Baseline')
xlim([0 30])
ylim([0 30])
zlim([0 30])

%

mod_up = add_vec_new(:,1)-add_vec_new(:,2);
mod_down = add_vec_new(:,2)-add_vec_new(:,3);

%mod_down(mod_down<.5) = 0;
%mod_up(mod_up<.5) = 0;

%%
figure(5);
clf(5)
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau > 500 & peak_rate > 2 & spike_amp >= 60 & num_trials > 40 & SNR > 2.5;
plot([0 5],[.5 .5],'k')
plot([.5 .5],[0 5],'k')

plot(mod_up(keep_spikes),mod_down(keep_spikes),'.r')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
xlim([0 5])
ylim([0 5])



figure(5);
clf(5)
hold on


keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau > 500 & peak_rate > 2 & spike_amp >= 60 & num_trials > 40 & SNR > 2.5;
plot((add_vec_new(keep_spikes,1)-add_vec_new(keep_spikes,2))./add_vec_new(keep_spikes,4),(add_vec_new(keep_spikes,2)-add_vec_new(keep_spikes,3))./add_vec_new(keep_spikes,4),'.r')

plot((add_vec_new(keep_spikes,1)-add_vec_new(keep_spikes,2))./add_vec_new(keep_spikes,4),(add_vec_new(keep_spikes,2)-add_vec_new(keep_spikes,3))./add_vec_new(keep_spikes,4),'.r')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
xlim([0 5])
ylim([0 5])


%%
figure
hist(add_vec_new(keep_spikes,1)-add_vec_new(keep_spikes,2),[0:.2:30])

figure
hist(add_vec_new(keep_spikes,2)-add_vec_new(keep_spikes,3),[0:.2:30])


%scatter(mod_vec(keep_spikes,1),mod_vec(keep_spikes,2),[],add_vec_new(keep_spikes,2),'fill')
%plot(add_vec_new(keep_spikes,3),add_vec_new(keep_spikes,1),'.b')





figure(10)
clf(10)
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau > 700 & peak_rate > 2 & spike_amp >= 60;
plot(time_vect,norm_waves(keep_spikes,:)','b')

keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau <= 700 & spike_tau >= 500 & peak_rate > 2 & spike_amp >= 60;
plot(time_vect,norm_waves(keep_spikes,:)','g')

keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau <= 500 & spike_tau >= 350 & peak_rate > 2 & spike_amp >= 60;
plot(time_vect,norm_waves(keep_spikes,:)','k')

keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
plot(time_vect,norm_waves(keep_spikes,:)','r')


% NEW TAU DIST.
figure(11)
clf(11)
hist(1000*tau_new,[0:50:900])


x = time_vect(20:30)';
y = -norm_waves(1,20:30)';
f = fit(x,y,'exp1');

x = time_vect(:)';
y = norm_waves(1,:)';


yy = smooth(y,5,'sgolay',1);

figure;
hold on
plot(x,y,'b','LineWidth',2)
plot(x,yy,'r','LineWidth',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NNMF on tuning curves


%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
keep_index = find(keep_spikes);

order_sort = total_order(keep_spikes,4);
[val ind] = sort(order_sort);
keep_index = keep_index(ind,:);

num_keep_neurons = sum(keep_spikes);
length_tuning_curve = length(all_anm{1}.d.summarized_cluster{1}.TOUCH_TUNING.regressor_obj.x_fit_vals);

X = zeros(num_keep_neurons,length_tuning_curve);
y = zeros(num_keep_neurons,1);

anm_num = p(:,1);
[a b c] = unique(anm_num);

% for ij = 1:num_keep_neurons
% 	neuron_num = keep_index(ij);
% 	anm_num = total_order(neuron_num,1);
% 	clust_num = total_order(neuron_num,2);
% 	layer_4_dist(neuron_num)
% 	tuning = all_anm{anm_num}.d.summarized_cluster{clust_num}.TOUCH_TUNING;
%     tune_curve = tuning.model_fit.curve;
% 	X(ij,:) = tune_curve;
% end

 for ij = 1:num_keep_neurons
 	neuron_num = keep_index(ij);
 	layer_4_dist(neuron_num)
 	X(ij,:) = [curves.onset(neuron_num,:)];
 end


X(X<0) = 0;
remove = sum(isnan(X),2);
keep_index(remove>0) = [];
X(remove>0,:) = [];

Y = bsxfun(@rdivide,X,sum(X,2));

figure
imagesc(X)

figure
plot(X')

[W,H] = nnmf(X',3);

figure;
plot(W)


figure
plot3(H(1,:),H(2,:),H(3,:),'.r')


[coeff,score] = pca(X);


figure;
plot(coeff(:,1:4))

figure
plot3(score(:,1),score(:,2),score(:,3),'.r')


figure;
hold on
plot(layer_4_dist(keep_index),H(1,:),'.b')
plot(layer_4_dist(keep_index),H(2,:),'.g')
plot(layer_4_dist(keep_index),H(3,:),'.r')

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stability analysis


ih = 2;

figure;
hold on
for ij = 1:numel(all_anm.data{ih}.d.summarized_cluster)
	trial_range = [all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_range(1):all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_range(2)];
	plot(trial_range,all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_firing_rate)
first_third = round(length(all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_firing_rate)/3);
start_fr = mean(all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_firing_rate(1:first_third))
end_fr = mean(all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_firing_rate(end-first_third:end))
tot_fr = mean(all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_firing_rate(:))
mod_fr = (start_fr - end_fr)/tot_fr
end







%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Choice prob
choice_prob_all = choice_probabilities(ps,all_anm.data,[],[],12);

figure
hold on
keep_spikes_out = clean_clusters & ismember(ps.barrel_loc,[3 4 6 7]) & ~v1;
keep_spikes = clean_clusters & ismember(ps.barrel_loc,[1 2 5]) & ~v1;
n_out = hist(choice_prob_all(keep_spikes_out,1),[0:.05:1])
n = hist(choice_prob_all(keep_spikes,1),[0:.05:1])
h = bar([0:.05:1],n/sum(n));
set(h,'FaceColor','g')
set(h,'EdgeColor','g')
h = bar([0:.05:1],n_out/sum(n_out));
plot([0.5 0.5],[0 .1],'r')
nanmean(choice_prob_all(keep_spikes_out,:))
nanstd(choice_prob_all(keep_spikes_out,:))/sqrt(sum(keep_spikes_out))
nanmean(choice_prob_all(keep_spikes,:))
nanstd(choice_prob_all(keep_spikes,:))/sqrt(sum(keep_spikes))


figure
hold on
keep_spikes_out = clean_clusters & ismember(ps.barrel_loc,[3 4 6 7]) & ~v1;
keep_spikes = clean_clusters & ismember(ps.barrel_loc,[1 2 5]) & ~v1;
n_out = hist(choice_prob_all(keep_spikes_out,1),[0:.1:1])
n = hist(choice_prob_all(keep_spikes,1),[0:.1:1])
h = bar([0:.1:1],n/sum(n));
set(h,'FaceColor','g')
set(h,'EdgeColor','g')
h = bar([0:.1:1],n_out/sum(n_out),.5);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
aa = nanmean(choice_prob_all(keep_spikes_out,:))
plot([aa(1) aa(1)],[0 .35],'c','linewidth',2)
nanstd(choice_prob_all(keep_spikes_out,:))/sqrt(sum(keep_spikes_out))
aa = nanmean(choice_prob_all(keep_spikes,:))
plot([aa(1) aa(1)],[0 .35],'m','linewidth',2)
nanstd(choice_prob_all(keep_spikes,:))/sqrt(sum(keep_spikes))
xlabel('Choice probability','FontSize',16)
set(gca,'FontSize',16)

figure
hold on
keep_spikes_out = clean_clusters & ismember(ps.barrel_loc,[8]);
keep_spikes = clean_clusters & ismember(ps.barrel_loc,[3 4 6 7 1 2 5]);
n_out = hist(choice_prob_all(keep_spikes_out,1),[0:.1:1])
n = hist(choice_prob_all(keep_spikes,1),[0:.1:1])
h = bar([0:.1:1],n/sum(n));
set(h,'FaceColor','g')
set(h,'EdgeColor','g')
h = bar([0:.1:1],n_out/sum(n_out),.3);
plot([0.5 0.5],[0 .1],'r')
nanmean(choice_prob_all(keep_spikes_out,:))
nanstd(choice_prob_all(keep_spikes_out,:))/sqrt(sum(keep_spikes_out))
nanmean(choice_prob_all(keep_spikes,:))
nanstd(choice_prob_all(keep_spikes,:))/sqrt(sum(keep_spikes))




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

refPeriods = [2.5 2.25 2.0 1.75 1.5];
all_viol = []
for ih = 1:numel(all_anm.data)
	for ij = 1:numel(all_anm.data{ih}.d.spike_times_cluster.spike_times_cluster)
		viols = zeros(1,length(refPeriods));
		for ik = 1:length(refPeriods)
			ISI = get_isi(all_anm.data{ih}.d.spike_times_cluster.spike_times_cluster{ij},refPeriods(ik)/1000);
			viols(ik) = ISI.violations;
		end
		all_viol = [all_viol;viols];
	end
end


figure;
hold on
plot(all_viol(:,1),all_viol(:,3),'.k')
plot(all_viol(examine==2,1),all_viol(examine==2,4),'.r')
xlabel('2.5 ms ISI')
ylabel('2.25 ms ISI')

all_viol(examine==2,4)

keep_spikes = examine==2 & all_viol(:,4) < 1.5;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
hold on
for ik = [0:2:10]

keep = all_anm.data{1}.d.u_ck(10,:)' == ik & all_anm.data{1}.d.u_ck(1,:)' <= 12;

r_t = mean(squeeze(all_anm.data{1}.d.r_ntk(1,:,keep)),2);
plot(r_t);

end



figure(1);
clf(1);
hold on
keep = all_anm.data{1}.d.u_ck(10,:)' <= 30 & all_anm.data{1}.d.u_ck(1,:)' <= 12;
r_t = mean(squeeze(all_anm.data{1}.d.r_ntk(13,:,keep)),2);
r_t = zscore(smooth(r_t,50,'sgolay',2));
plot(r_t)

Cxy = mscohere(r_t,s_t);
figure
plot(Cxy)



figure(1);
clf(1);
hold on
keep = all_anm.data{1}.d.u_ck(10,:)' <= 30 & all_anm.data{1}.d.u_ck(1,:)' <= 12;
r_t = mean(squeeze(all_anm.data{1}.d.r_ntk(11,:,keep)),2);
r_t = zscore(smooth(r_t,50,'sgolay',2));
plot(r_t)
s_t = mean(squeeze(all_anm.data{1}.d.s_ctk(6,:,keep)),2);
s_t = zscore(smooth(s_t,50,'sgolay',2));
plot(s_t,'r')
r_t = mean(squeeze(all_anm.data{1}.d.r_ntk(13,:,keep)),2);
r_t = zscore(smooth(r_t,50,'sgolay',2));
plot(r_t,'k')




figure(1);
clf(1);
hold on
ind = 12;
anm_name = total_order(ind,1);
clust_id = total_order(ind,2)-2;
anm_ind = find(ismember(all_anm.names,num2str(anm_name)));
target_dist = round(ps.touch_max_loc(ind)/2)*2
keep = ismember(all_anm.data{anm_ind}.d.u_ck(10,:)',target_dist-2:2:target_dist+2) & all_anm.data{anm_ind}.d.u_ck(1,:)' <= 12;
r_t = mean(squeeze(all_anm.data{anm_ind}.d.r_ntk(clust_id+2,:,keep)),2)*500;
r_t = smooth(r_t,25,'sgolay',1);
baseline = mean(r_t(150:250));
peak = mean(r_t(450:550));
adpat_val = mean(r_t(1300:1400));
(peak-adpat_val)./(peak+adpat_val)


plot(r_t)
target_dist = round(ps.touch_min_loc(ind)/2)*2
keep = ismember(all_anm.data{anm_ind}.d.u_ck(10,:)',target_dist-2:2:target_dist+2) & all_anm.data{anm_ind}.d.u_ck(1,:)' <= 12;
r_t = mean(squeeze(all_anm.data{anm_ind}.d.r_ntk(clust_id+2,:,keep)),2)*500;
r_t = smooth(r_t,25,'sgolay',1);
plot(r_t,'r')
baseline = mean(r_t(150:250));
peak = mean(r_t(450:550));
adpat_val = mean(r_t(1300:1400));
(peak-adpat_val)./(peak+adpat_val)


xlim([0 2000])

figure(3)
clf(3)
plot_tuning_curve_ephys([],all_anm.data{anm_ind}.d.summarized_cluster{clust_id}.TOUCH_TUNING)

figure(4)
clf(4)
plot_spk_raster([],all_anm.data{anm_ind}.d.summarized_cluster{clust_id}.RUNNING_RASTER)


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
% ANALYSIS IN PCA SPACE

d = all_anm.data{1}.d; 
anm_id = all_anm.names{1};
    [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
    run_thresh = anm_params.run_thresh;
    trial_range_start = anm_params.trial_range_start;
    trial_range_end = anm_params.trial_range_end;
    cell_reject = anm_params.cell_reject;
    exp_type = anm_params.exp_type;
    layer_4_CSD = anm_params.layer_4;
    boundaries = anm_params.boundaries;
    boundary_labels = anm_params.boundary_labels;
    layer_4 = anm_params.layer_4_corr;
trial_range = trial_range_start(1):min(4000,trial_range_end(1));

time_range = [0 4];

  


id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
u_ind = find(strcmp(d.u_labels,'trial_num'));
raw_trial_nums = d.u_ck(u_ind,:);
keep_trials = raw_trial_nums(keep_trials_tmp);
[group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type,[]);
groups_RASTER = d.u_ck(1,keep_trials_tmp);
g_tmp = zeros(4000,1);
g_tmp(keep_trials) = groups_RASTER;
groups_RASTER = g_tmp;

mean_ds = 1;
temp_smooth = 80;

all_psth = [];
%tmp = []
for clust_id = 1:numel(spike_times_cluster)
    RASTER = get_spk_raster(spike_times_cluster{clust_id}.spike_times_ephys,spike_times_cluster{clust_id}.spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);
    tmpP = RASTER.psth(:,50:end-50);
    all_psth = cat(3,all_psth,tmpP);
%    tmp = cat(2,tmp,tmpP(:));
end

time = RASTER.time(:,50:end-50);

id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
groups = d.u_ck(1,keep_trials_tmp);
group_ids = unique(groups);
inds = d.u_ck(1,:);

avg_s = zeros(size(d.s_ctk,1),size(d.s_ctk,2),length(group_ids));
avg_r = zeros(size(d.r_ntk,1),size(d.r_ntk,2),length(group_ids));
for ij = 1:length(group_ids)
    sum(inds == ij & keep_trials_tmp)
    avg_s(:,:,ij) = squeeze(mean(d.s_ctk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
    avg_r(:,:,ij) = squeeze(mean(d.r_ntk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
end


% avg_s = zeros(size(d.s_ctk,1),size(d.s_ctk,2),length(group_ids));
% avg_r = zeros(size(d.r_ntk,1),size(d.r_ntk,2),length(group_ids));
avg_s = d.s_ctk(:,:,keep_trials_tmp);
avg_r = d.r_ntk(:,:,keep_trials_tmp);

avg_r = convn(avg_r,ones(1,temp_smooth,1)/temp_smooth,'same');

avg_r = avg_r(:,50:end-50,:);
avg_s = avg_s(:,50:end-50,:);
avg_r = permute(avg_r,[3 2 1]);
avg_s = permute(avg_s,[3 2 1]);

%avg_r = avg_r(:,:,d.p_nj(:,4)>50);

%avg_r = avg_r(:,:,8:9);

%%%%avg_r = squeeze(mean(avg_r,1));
 % X = reshape(avg_r,[size(avg_r,1)*size(avg_r,2), size(avg_r,3)]);
 % X = zscore(X,1);
 %X = bsxfun(@minus,X,mean(X,2));
 % [coeff,score,latent] = pca(X);

 % Y = reshape(score,[size(avg_r,1), size(avg_r,2), size(avg_r,3)]);

X = reshape(avg_r,[size(avg_r,1)*size(avg_r,2), size(avg_r,3)]);
X = bsxfun(@minus,X,mean(X,2));
X = bsxfun(@minus,X,mean(X,1));
[coeff,score,latent] = pca(X);
%score = X*coeff;
Z = reshape(score,[size(avg_r,1), size(avg_r,2), size(avg_r,3)]);


figure
hold on
set(gca,'visible','off')
set(gcf,'Color',[1 1 1])
keep_ij = find(avg_s(:,600,1)>-2 & avg_s(:,600,1)<200);
for ijk =  1:length(keep_ij) %% 3:size(avg_s,1)-3
    ij = keep_ij(ijk);
   %  traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
   %  norm_traj_x = traj(120,1);
   %  norm_traj_y = traj(120,2);
   %  rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
   %  traj = traj*rot;

   %  tmp = traj(:,2);
   %  tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
   % tmp = filtfilt(b,a,tmp);
   %  tmp = tmp(501:end-1000);
   %  tmp = diff(tmp);
   %  tmp = -[0;tmp];
       
        theta = atan2(Z(ij,:,2),Z(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        % inds = 1:length(theta);
        % theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;
t_shift = 0;
    %    dist = sqrt(Z(ij,:,1).^2+Z(ij,:,2).^2);
  %      scatter3([1:1300],Z(ij,1:1300,1),Z(ij,1:1300,2),[],avg_s(ij,1:1300,1))
        scatter(Z(ij,1:1300,1),Z(ij,1:1300,2),[],30-avg_s(ij,1:1300,1))
     %  scatter3([1:1300]-t_shift,Z(ij,1:1300,8),Z(ij,1:1300,9),[],time(1:1300))
        %scatter3([1:1902]-t_shift,Z(ij,1:1902,1),Z(ij,1:1902,2),[],avg_s(ij,1:1902,3))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
    %     scatter3([1:1300],avg_s(ij,1:1300,2),theta(1:1300),[],avg_s(ij,1:1300,2))
%        col_vec = -[diff(Y(ij,:,3)) 0];
  %      col_vec = Y(ij,:,8);

    %  scatter3([1:1300]-t_shift,Y(ij,1:1300,1),repmat(0,1300,1),[],'k')
    %  scatter3([1:1300]-t_shift,Y(ij,1:1300,2),repmat(1,1300,1),[],'b')
    % scatter3(avg_s(ij,1:1300,6),avg_s(ij,1:1300,1),theta(1:1300),[],avg_s(ij,1:1300,6))
    %  scatter3(avg_s(ij,1:1902,1),theta(1:1902),dist(1:1902),[],avg_s(ij,1:1902,3))
      %  scatter3([1:1300]-t_shift,theta(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,1))
end  
xlim([-0.2 0.2])
ylim([-0.2 0.2])

avg_all = squeeze(mean(Z(:,800:1300,:),2));

avg_1 = mean(Z(:,800:1300,1),2);
avg_2 = mean(Z(:,800:1300,2),2);
theta = atan2(avg_2,avg_1);
%theta = unwrap(theta)*180/pi;
dist = sqrt(avg_1.^2+avg_2.^2);
%plot3(repmat(2000,12,1),theta,dist,'k','linewidth',2)
plot3(repmat(1300,12,1),avg_1,avg_2,'k','linewidth',2)
plot3(1300,0,0,'.k','MarkerSize',50)


wall_vals = squeeze(avg_s(:,700,1))

figure
hold on
plot(wall_vals,avg_all(:,1),'Color','b','LineWidth',2)
plot(wall_vals,avg_all(:,2),'Color','k','LineWidth',2)
plot(wall_vals,avg_all(:,3),'Color','r','LineWidth',2)


p = 10^-1;
curve1 = csaps(wall_vals,avg_1,p,x_fit_vals);
curve2 = csaps(wall_vals,avg_2,p,x_fit_vals);
curve3 = csaps(wall_vals,avg_all(:,3),p,x_fit_vals);
plot(x_fit_vals,curve1,'Color','b','LineWidth',2)
plot(x_fit_vals,curve2,'Color','k','LineWidth',2)
plot(x_fit_vals,curve3,'Color','r','LineWidth',2)


           
figure
hold on
plot(curve1,curve2,'Color','b','LineWidth',2)
plot(avg_1,avg_2,'Color','k','LineWidth',2)



figure
subplot(1,3,1)
hold on
plot(x_fit_vals,curve1,'Color','b','LineWidth',2)
subplot(1,3,2)
hold on
plot(x_fit_vals,curve2,'Color','b','LineWidth',2)
plot(x_fit_vals,[diff(curve1) 0]*10,'Color','k','LineWidth',2)
subplot(1,3,3)
hold on
plot(x_fit_vals,zscore(curve3),'Color','b','LineWidth',2)
plot(x_fit_vals,-zscore([diff(curve2) 0]),'Color','k','LineWidth',2)


coeff_mod = coeff;

coeff_mod(abs(coeff_mod)<.4) = 0;
figure
hold on
plot(coeff(:,1),coeff(:,2),'.k')
plot(coeff_mod(:,1),coeff_mod(:,2),'.b')


find(coeff_mod(:,1))
coeff_mod(abs(coeff_mod(:,1))>0,1)
find(coeff_mod(:,2))
coeff_mod(abs(coeff_mod(:,2))>0,2)











figure
hold on
for ij = 1:size(avg_s,1)
        traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;
%    scatter3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),[],traj(:,2))
    scatter3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),[],avg_s(ij,:,1))
end

figure
hold on
for ij = 1:12
scatter3([1:1802],avg_s(ij,:,5) - mean(avg_s(ij,1:100,5)),avg_s(ij,:,1),[],avg_s(ij,:,4))
end

figure
hold on
for ij = 1:12
plot(avg_s(ij,:,1),avg_s(ij,:,5),[],avg_s(ij,:,5))
end


norm_traj_x = sum(avg_s(12,:,4))/500;
norm_traj_y = sum(avg_s(12,:,5))/500;

rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
figure
hold on
for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(200,1);
    norm_traj_y = traj(200,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;
    %traj = bsxfun(@minus,traj,mean(traj(1:50,:)));
    scatter3(traj(:,1),traj(:,2),avg_s(ij,:,1),[],Y(ij,:,1))
    plot3(traj(200,1),traj(200,2),avg_s(ij,200,1),'.','MarkerEdgeColor','k','MarkerSize',20)
end



d_F = fdesign.lowpass('N,Fc',4,1,500);
H_bp = design(d_F,'butter');
[b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);
    

figure
hold on
for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
   tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = [0;tmp];
    t_shift = find(Y(ij,:,1)>.01,1,'first');
    if isempty(t_shift) || t_shift > 600
        t_shift = 500;
    else
        avg_s(ij,t_shift,1)
        tmp(t_shift)
        scatter3([1:size(traj,1)]-t_shift,tmp,Y(ij,:,2),[],avg_s(ij,:,1))
    end
end


figure
hold on
for ij = 1:1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
   tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = -[0;tmp];
    t_shift = find(tmp>.002,1,'first');
    if isempty(t_shift) || t_shift > 300
        t_shift = 500;
    else
        theta = atan2(Z(ij,:,2),Z(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        inds = 1:length(theta);
        theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;

        dist = sqrt(Z(ij,:,1).^2+Z(ij,:,2).^2);
      %  scatter3([1:1300]-t_shift,Y(ij,1:1300,1),Y(ij,1:1300,2),[],avg_s(ij,1:1300,1))
    %    scatter3([1:1902]-t_shift,Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
        %scatter3([1:1300]-t_shift,theta(1:1300),dist(1:1300),[],avg_s(ij,1:1300,1))
%        col_vec = -[diff(Y(ij,:,3)) 0];
        col_vec = avg_s(ij,1:1300,1);

   %    scatter3([1:t_shift+250] - t_shift,Y(ij,1:t_shift+250,3),Y(ij,1:t_shift+250,6),[],tmp(1:t_shift+250)-mean(tmp(1:t_shift)))
       scatter3([1:t_shift+250] - t_shift,tmp(1:t_shift+250)-mean(tmp(1:t_shift)),col_vec(1:t_shift+250),[],col_vec(1:t_shift+250))
    %    scatter3(avg_s(ij,1:1300,1),theta(1:1300),tmp(1:1300),[],avg_s(ij,1:1300,1))
  %      scatter3([1:1300]-t_shift,dist(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,6))
    end
end   



figure
hold on
for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
   tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = -[0;tmp];
    t_shift = find(Y(ij,:,1)>.01,1,'first');
    if isempty(t_shift) || t_shift > 600
        t_shift = 500;
    else
        theta = atan2(Y(ij,:,2),Y(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        inds = 1:length(theta);
        theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;

        dist = sqrt(Y(ij,:,1).^2+Y(ij,:,2).^2);
    %    scatter3([1:1300]-t_shift,Y(ij,1:1300,1),Y(ij,1:1300,2),[],avg_s(ij,1:1300,1))
    %    scatter3([1:1902]-t_shift,Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
       % scatter3([1:1300],avg_s(ij,1:1300,2),dist(1:1300),[],avg_s(ij,1:1300,2))
%        col_vec = -[diff(Y(ij,:,3)) 0];
  %      col_vec = Y(ij,:,8);

     %  scatter3([1:1300]-t_shift,Y(ij,1:1300,1),repmat(0,1300,1),[],'k')
     %  scatter3([1:1300]-t_shift,Y(ij,1:1300,2),repmat(1,1300,1),[],'b')
  %      scatter3(avg_s(ij,1:1300,1),theta(1:1300),tmp(1:1300),[],avg_s(ij,1:1300,1))
        scatter3([1:1300]-t_shift,theta(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,1))
    end
end  

d_F = fdesign.lowpass('N,Fc',4,1,500);
H_bp = design(d_F,'butter');
[b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);
  
for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
    tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = -[0;tmp];

    avg_s(ij,:,6) = tmp;
end


figure
hold on
y = zeros(size(avg_s,1),1);
w = zeros(32,1);
w(1) = 1;
keep_ij = find(avg_s(:,600,1)>-2 & avg_s(:,600,1)<200);
for ijk =  1:length(keep_ij) %% 3:size(avg_s,1)-3
    ij = keep_ij(ijk);
    
    y(ij) = mean(tmp(300:400));
    t_shift = find(Z(ij,:,1)>.01,1,'first');
    if isempty(t_shift) || t_shift > 600
        t_shift = 500;
    else
        theta = atan2(Z(ij,:,2),Z(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        inds = 1:length(theta);
        theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;

        dist = sqrt(Z(ij,:,1).^2+Z(ij,:,2).^2);
      %  scatter3([1:1300]-t_shift,Y(ij,1:1300,1),Y(ij,1:1300,2),[],avg_s(ij,1:1300,1))
    %    scatter3([1:1902]-t_shift,Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
        %scatter3([1:1300]-t_shift,theta(1:1300),dist(1:1300),[],avg_s(ij,1:1300,1))
%        col_vec = -[diff(Y(ij,:,3)) 0];
        %col_vec = Z(ij,:,1);
        col_vec = squeeze(Z(ij,:,:))*w;
        col_vec = avg_s(ij,1:700,1);
        %col_vec = theta;
        %col_vec = -squeeze(avg_r(ij,:,:))*w;
%col_vec(col_vec<-0.1) = -.1;
%col_vec(col_vec>0.1) = 0.1;
   %    scatter3([1:1300],avg_s(ij,1:1300,1),tmp(1:1300),[],col_vec(1:1300))
        scatter([1:700],avg_s(ij,1:700,6),[],col_vec(1:700))
    %   scatter3(avg_s(ij,1:1300,1),theta(1:1300),tmp(1:1300),[],avg_s(ij,1:1300,1))
  %     scatter3([1:1300]-t_shift,dist(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,6))
    end
end   










d_F = fdesign.lowpass('N,Fc',4,1,500);
H_bp = design(d_F,'butter');
[b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);
  

for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)/500));
    norm_traj_x = traj(250,1);
    norm_traj_y = traj(250,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
    tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = -[0;tmp];
    
    avg_s(ij,:,6) = tmp;
end



traj = squeeze(cumsum(avg_s(:,:,4:5),2))/500;

figure
plot(traj(:,700,1),traj(:,700,2),'.k')

figure
hold on
y = zeros(size(avg_s,1),1);
w = zeros(size(avg_r,3),1);
w(1) = 1;
keep_ij = find(avg_s(:,600,1)>2 & avg_s(:,600,1)<20 & traj(:,700,1)>15);
for ijk =  1:length(keep_ij) %% 3:size(avg_s,1)-3
    ij = keep_ij(ijk);
    

        theta = atan2(Z(ij,:,2),Z(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        inds = 1:length(theta);
        theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;

      %  dist = sqrt(Z(ij,:,1).^2+Z(ij,:,2).^2);
      %  scatter3([1:1300]-t_shift,Y(ij,1:1300,1),Y(ij,1:1300,2),[],avg_s(ij,1:1300,1))
    %    scatter3([1:1902]-t_shift,Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
        %scatter3([1:1300]-t_shift,theta(1:1300),dist(1:1300),[],avg_s(ij,1:1300,1))
%        col_vec = -[diff(Y(ij,:,3)) 0];
        col_vec = Z(ij,:,2);
        %col_vec = squeeze(Z(ij,:,:))*w;
        %col_vec = avg_s(ij,1:700,1);
        %col_vec = theta;
        %col_vec = -squeeze(avg_r(ij,:,:))*w;
%col_vec(col_vec<-0.1) = -.1;
%col_vec(col_vec>0.1) = 0.1;
       scatter3([1:5:1300],avg_s(ij,1:5:1300,6),avg_s(ij,1:5:1300,1),[],col_vec(1:5:1300))
    %    scatter([1:700],avg_s(ij,1:700,6),[],col_vec(1:700))
   %     scatter(traj(1:700,1)+ij,traj(1:700,2),[],col_vec(1:700))

    %   scatter3(avg_s(ij,1:1300,1),theta(1:1300),tmp(1:1300),[],avg_s(ij,1:1300,1))
  %     scatter3([1:1300]-t_shift,dist(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,6))
end   






run_angle = mean(avg_s(:,690:700,6),2);
wall_pos = mean(avg_s(:,600:700,1),2);
%col_vec = squeeze(mean(Z(:,100:700,1:2),2));
%col_vec = atan2(col_vec(:,2),col_vec(:,1));
%col_vec = 2*pi - mod(col_vec+pi/2,2*pi);

col_vec = squeeze(mean(mean(avg_r(:,100:700,abs(d.p_nj(:,4))<100),3),2));

%col_vec(col_vec<pi) = col_vec(col_vec<pi)+2*pi;
        %theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;

%col_vec = sqrt(col_vec(:,1).^2+col_vec(:,2).^2);

%col_vec = squeeze(mean(Z(:,100:700,1),2));
    traj = squeeze(cumsum(avg_s(:,:,4:5),2))/500;

wall_pos(wall_pos>20) = 20;
col_vec = col_vec(wall_pos>0&wall_pos<=20 & traj(:,700,1)>15);
run_angle = run_angle(wall_pos>0&wall_pos<=20 & traj(:,700,1)>15);
wall_pos_n = wall_pos(wall_pos>0&wall_pos<=20 & traj(:,700,1)>15);


[wall_vals b inds] = unique(wall_pos_n);
vals = accumarray(inds,run_angle,[length(wall_vals) 1],@mean,nan);
      
mdl = LinearModel.fit(wall_pos_n,run_angle);
%vals = feval(mdl,wall_vals);
mean_run_angle = vals(inds);

vals = accumarray(inds,col_vec,[length(wall_vals) 1],@mean,nan);
mdl = LinearModel.fit(wall_pos_n,col_vec)
%vals = feval(mdl,wall_vals);
mean_col_vec = vals(inds);


norm_act = squeeze(mean(avg_r(:,100:700,:),2));
norm_act_mod = [];
for ij = 1:size(norm_act,2)
    tmp = norm_act(:,ij);
    tmp = tmp(wall_pos>0&wall_pos<=20 & traj(:,700,1)>15);
    vals = accumarray(inds,tmp,[length(wall_vals) 1],@mean,nan);
    tmp_n = vals(inds);
    norm_act_mod(:,ij) = tmp; % - tmp_n;
end
%w = regress(run_angle-mean_run_angle,norm_act_mod);
w = regress(run_angle,norm_act_mod);

col_vec = norm_act_mod*w;
%col_vec = col_vec(wall_pos>0&wall_pos<=20 & traj(:,700,1)>15);
wall_pos = wall_pos_n;

vals = accumarray(inds,col_vec,[length(wall_vals) 1],@mean,nan);
mean_col_vec = vals(inds);



figure(16)
clf(16)
subplot(1,4,1)
scatter(wall_pos,run_angle,[],col_vec)
subplot(1,4,2)
plot(col_vec-mean_col_vec,run_angle-mean_run_angle,'.k')
subplot(1,4,3)
plot(wall_pos,col_vec,'.k')
subplot(1,4,4)
plot(col_vec,run_angle,'.k')


mdl = LinearModel.fit(wall_pos,run_angle)

mdl = LinearModel.fit(wall_pos,col_vec)

mdl = LinearModel.fit(col_vec,run_angle)

mdl = LinearModel.fit(col_vec-mean_col_vec,run_angle-mean_run_angle)


w_run = regress(run_angle,norm_act_mod);
w_wall = regress(wall_pos,norm_act_mod);


figure(16)
clf(16)
subplot(1,4,1)
col_vec = norm_act_mod*w_run;
scatter(wall_pos,run_angle,[],col_vec)
subplot(1,4,2)
col_vec = norm_act_mod*w_wall;
scatter(wall_pos,run_angle,[],col_vec)
subplot(1,4,3)
col_vec = norm_act_mod*w_wall;
plot(wall_pos,col_vec,'.k')
mdl = LinearModel.fit(wall_pos,col_vec)
subplot(1,4,4)
col_vec = norm_act_mod*w_run;
plot(col_vec,run_angle,'.k')
mdl = LinearModel.fit(col_vec,run_angle)



figure
plot(w_run,w_wall,'.k')


%A = squeeze(mean(Z(:,800:1300,:),2));
A = squeeze(mean(avg_r(:,300:400,:),2));
%y = squeeze(mean(avg_s(:,800:1300,1),2));
w = regress(y,A);

figure;
plot(A*w,y,'.k')

avg_1 = mean(Y(:,300:400,1),2);
avg_2 = mean(Y(:,800:400,2),2);
theta = atan2(avg_2,avg_1);
%theta = unwrap(theta)*180/pi;
dist = sqrt(avg_1.^2+avg_2.^2);
%plot3(repmat(2000,12,1),theta,dist,'k','linewidth',2)
plot3(repmat(1300,12,1),avg_1,avg_2,'k','linewidth',2)
plot3(1300,0,0,'.k','MarkerSize',50)


wall_vals = squeeze(avg_s(:,700,1))

figure
hold on
plot(wall_vals,avg_1,'Color','b','LineWidth',2)
plot(wall_vals,avg_2,'Color','k','LineWidth',2)




figure
hold on
for ij = 2:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
   tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = [0;tmp];
%    t_shift = find(Y(ij,:,1)>.01,1,'first');
    shift_vec = Y(ij,1:1750,1);
    t_shift = find(shift_vec>0,1,'last')
    if isempty(t_shift) %|| t_shift > 600
        t_shift = 500;
    else
        theta = atan2(Y(ij,:,2),Y(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        inds = 1:length(theta);
        theta(inds<1500&theta<1) = theta(inds<1500&theta<1)+2*pi;
        
        dist = sqrt(Y(ij,:,1).^2+Y(ij,:,2).^2);
     %   scatter3([1:1902]-t_shift,Y(ij,1:end,1),Y(ij,1:end,2),[],avg_s(ij,1:end,1))
        %scatter3([1:1300]-t_shift,theta(1:1300),dist(1:1300),[],avg_s(ij,1:1300,1))
        scatter3([1301:1902]-t_shift,theta(1301:1902),avg_s(ij,1301:1902,1),[],avg_s(ij,1301:1902,1))
  %      scatter3([1:1300]-t_shift,theta(1:1300),tmp(1:1300),[],avg_s(ij,1:1300,1))
  %      scatter3([1:1300]-t_shift,dist(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,6))
    end
end
     



avg_1 = mean(Y(:,800:1300,1),2);
avg_2 = mean(Y(:,800:1300,2),2);

theta = atan2(avg_2,avg_1);
theta = unwrap(theta)*180/pi
dist = sqrt(avg_1.^2+avg_2.^2)

figure
hold on
%plot(avg_1,avg_2)
plot(theta)








figure
hold on
for ij = 1:12
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;
    %traj = bsxfun(@minus,traj,mean(traj(1:50,:)));
    plot(traj(:,2),Y(ij,:,2),'r')
end





figure;
plot(squeeze(BV(3,:,:)))

time = RASTER.time(:,50:end-50);
row_psth = squeeze(mean(all_psth,3));
X = reshape(all_psth,[size(all_psth,1)*size(all_psth,2), size(all_psth,3)]);
X = bsxfun(@minus,X,mean(X,2));
[coeff,score,latent] = pca(X);

Y = reshape(score,[size(all_psth,1), size(all_psth,2), size(all_psth,3)]);

wall_mat = zeros(length(group_ids_RASTER),4000);
for ij = 1:length(group_ids_RASTER)
    ind = find(d.u_ck(1,:) == ij,1,'first');
    wall_val = d.u_ck(11,ind);
    wall_mat(ij,1:1000) = linspace(30,wall_val,1000);
    wall_mat(ij,1001:3000) = wall_val;
    wall_mat(ij,3001:4000) = linspace(wall_val,30,1000);
end
wall_mat = wall_mat(:,time(1)*1000:time(1)*1000+length(time)-1);
wall_vel = diff(wall_mat,[],2);
wall_vel = cat(2,wall_vel(:,1),wall_vel);

col_mat = zeros(12,3);
col_mat(:,3) = linspace(1,0,12);
figure
hold on
for ij = 1:12
plot3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),'Color',col_mat(ij,:))
end

figure
hold on
for ij = 1:12
scatter3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),[],time)
end

figure
hold on
for ij = [1 12]
scatter3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),[],wall_mat(ij,:))
time_ind = find(time==1);
plot3(Y(ij,time_ind,1),Y(ij,time_ind,2),Y(ij,time_ind,3),'.','MarkerEdgeColor','k','MarkerSize',20)
time_ind = find(time==3);
plot3(Y(ij,time_ind,1),Y(ij,time_ind,2),Y(ij,time_ind,3),'.','MarkerEdgeColor','k','MarkerSize',20)
end

figure
hold on
for ij = 1:12
scatter3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),[],wall_vel(ij,:))
end


scatter3(Y(3,:,1),Y(3,:,2),Y(3,:,3),[],time)


figure
plot_spk_raster([],RASTER)
figure
plot_spk_psth([],RASTER);


order = d.p_nj(d.p_nj(:,10)>500,4);
[ind val] = sort(order);

id_type = 'olR';
time_range = [0 1];
%SPK_CORR_ALL = get_full_trial_spk_corr(1:numel(spike_times_cluster),1:numel(spike_times_cluster),spike_times_cluster,d,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
SPK_CORR_ALL = get_full_trial_spk_corr(val,val,spike_times_cluster,d,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
stim_name = 'corPos';

figure; plot_spk_corr([],SPK_CORR_ALL);


clust_id1 = 9;
clust_id2 = 21;
plot_tuning_and_corr;

plot_depth_all(d,spike_times_cluster)


spike_times = cat(1,spike_times_cluster{10}.spike_times,spike_times_cluster{11}.spike_times);
spike_times = sort(spike_times);
ISI = get_isi(spike_times,[]);
figure; plot_isi([],ISI)



AMPLITUDES = spike_times_cluster{1}.interp_amp;
figure; plot_depth_amp([],AMPLITUDES)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANALYSIS IN PCA SPACE

anm_name = '249872'; 

anm_id = find(strcmp(all_anm.names,anm_name));
d = all_anm.data{anm_id}.d;
    [base_dir anm_params] = ephys_anm_id_database(anm_name,0);
    run_thresh = anm_params.run_thresh;
    trial_range_start = anm_params.trial_range_start;
    trial_range_end = anm_params.trial_range_end;
    cell_reject = anm_params.cell_reject;
    exp_type = anm_params.exp_type;
    layer_4_CSD = anm_params.layer_4;
    boundaries = anm_params.boundaries;
    boundary_labels = anm_params.boundary_labels;
    layer_4 = anm_params.layer_4_corr;
    trial_range = trial_range_start(1):min(4000,trial_range_end(1));


time_range = [0 4];
id_type = 'olR';
stim_name = 'corPos';
clust_id1 = 15;
clust_id2 = 22;
plot_tuning_and_corr




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
keep_name = 'base';
spike_times_cluster = get_all_LFP_hist(spike_times_cluster,lfp_data,d,keep_name,exp_type,id_type,time_range,trial_range,run_thresh)


clust_id = 9;
figure;
hold on
edges = linspace(-pi,pi,16);
curve = histc(spike_times_cluster{clust_id}.spike_phase,edges);
curve = curve(1:end-1);
edges = edges(1:end-1) + mean(diff(edges))/2;
curve = curve/sum(curve);
h = bar(edges,curve)
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
p = 10^-.5;
edges_int = linspace(-pi,pi,40);
model_fit_curve = csaps(edges,curve,p,edges_int);
plot(edges_int,model_fit_curve,'linewidth',2,'color','b')
xlim([-pi pi])

figure;
for clust_id = [8 9];
hold on
edges = linspace(-pi,pi,16);
curve = histc(spike_times_cluster{clust_id}.spike_phase,edges);
curve = curve(1:end-1);
edges = edges(1:end-1) + mean(diff(edges))/2;
curve = curve/sum(curve);
%h = bar(edges,curve)
plot(edges,curve,'linewidth',2,'color','k')
xlim([-pi pi])
end


p = 10^-.5;
edges_int = linspace(-pi,pi,40);
model_fit_curve = csaps(edges,curve,p,edges_int);
           
figure
hold on
plot(edges,curve,'linewidth',2,'color','r')
plot(edges_int,model_fit_curve,'linewidth',2,'color','k')





figure;
for clust_id = [8 9 21 26];
hold on
edges = linspace(-pi,pi,16);
curve = histc(spike_times_cluster{clust_id}.spike_phase,edges);
curve = curve(1:end-1);
edges = edges(1:end-1) + mean(diff(edges))/2;
curve = curve/sum(curve);
curve = zscore(curve);
%h = bar(edges,curve)
p = 10^-.5;
edges_int = linspace(-pi,pi,40);
model_fit_curve = csaps(edges,curve,p,edges_int);
plot(edges_int,model_fit_curve,'linewidth',2,'color','b')
xlim([-pi pi])
end
for clust_id = [2 5 15 18 25 27];
hold on
edges = linspace(-pi,pi,16);
curve = histc(spike_times_cluster{clust_id}.spike_phase,edges);
curve = curve(1:end-1);
edges = edges(1:end-1) + mean(diff(edges))/2;
curve = curve/sum(curve);
curve = zscore(curve);
%h = bar(edges,curve)
p = 10^-.5;
edges_int = linspace(-pi,pi,40);
model_fit_curve = csaps(edges,curve,p,edges_int);
plot(edges_int,model_fit_curve,'linewidth',2,'color','k')
xlim([-pi pi])
end

[l_ctk l_labels] = get_behaviour_LFP(d,lfp_data)

%%
figure
hold on
plot(zscore(lfp_data.flt_vlt_ephys{1}))
plot(angle(hilbert(lfp_data.flt_vlt_ephys{1})),'r')


figure;
hold on
plot(zscore(l_ctk(1,:,17)))
plot(zscore(l_ctk(2,:,17)),'r')
plot(zscore(ex_ctk(4,:,17)),'g')

aa = squeeze(l_ctk(4,:,:));
bb = squeeze(ex_ctk(3,:,:));
cc = squeeze(d.s_ctk(3,:,:));
X = [aa(:) bb(:)];
y = cc(:);

n2 = hist3(X(y>5,:),[20 20]);
figure
imagesc(n2)


             freq = 500;
             d_F = fdesign.bandpass('N,Fc1,Fc2',4,2,8,freq);
             H_bp = design(d_F,'butter');
             [b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);
             d_F2 = fdesign.bandpass('N,Fc1,Fc2',4,12,25,freq);
             H_bp2 = design(d_F2,'butter');
             [b2 a2] = sos2tf(H_bp2.sosMatrix,H_bp2.scaleValues);
        
      
      ex_ctk = zeros(4,size(d.s_ctk,2),size(d.s_ctk,3));
for ij = 1:size(d.s_ctk,3)
    x = d.s_ctk(3,:,ij);
    tmp = filtfilt(b,a,x);
    ex_ctk(1,:,ij) = tmp;
    tmp = filtfilt(b2,a2,x);
    ex_ctk(2,:,ij) = tmp;
    ex_ctk(3,:,ij) = angle(hilbert(ex_ctk(1,:,ij)));
    ex_ctk(4,:,ij) = angle(hilbert(ex_ctk(2,:,ij)));
end

Cxy_all = zeros(size(d.s_ctk,3),513);
for ij = 1:size(d.s_ctk,3)
    x = squeeze(d.s_ctk(3,:,ij));
    y = squeeze(l_ctk(1,:,ij));
    [Cxy F] = mscohere(x,y,hamming(500),450,1024,500);;
    Cxy_all(ij,:) = Cxy;
end

n = mean(Cxy_all(d.u_ck(2,:)>5,:));

figure
plot(F,n)


Cxy_all = zeros(size(d.s_ctk,3),513);
for ij = 1:size(d.s_ctk,3)-1
    x = squeeze(d.s_ctk(5,:,ij));
    y = squeeze(l_ctk(1,:,ij));
    [Cxy F] = mscohere(x,y,hamming(500),450,1024,500);
    Cxy_all(ij,:) = Cxy;
end

n = mean(Cxy_all(d.u_ck(2,:)>5,:));

figure
plot(F,n)
xlim([0 40])






figure
plot(sorted_spikes{1}.ephys_index,sorted_spikes{1}.ephys_time,'.k')


sorted_spikes{33}.clust_id = 34;
sorted_spikes{33}.detected_chan = sorted_spikes{10}.detected_chan;
sorted_spikes{33}.trial_num = cat(1,sorted_spikes{10}.trial_num,sorted_spikes{11}.trial_num);
sorted_spikes{33}.session_id_num = cat(1,sorted_spikes{10}.session_id_num,sorted_spikes{11}.session_id_num);
sorted_spikes{33}.ephys_index = cat(1,sorted_spikes{10}.ephys_index,sorted_spikes{11}.ephys_index);
sorted_spikes{33}.ephys_time = cat(1,sorted_spikes{10}.ephys_time,sorted_spikes{11}.ephys_time);
sorted_spikes{33}.bv_index = cat(1,sorted_spikes{10}.bv_index,sorted_spikes{11}.bv_index);
sorted_spikes{33}.laser_power = cat(1,sorted_spikes{10}.laser_power,sorted_spikes{11}.laser_power);
sorted_spikes{33}.spike_amp = cat(1,sorted_spikes{10}.spike_amp,sorted_spikes{11}.spike_amp);
sorted_spikes{33}.session_time = cat(1,sorted_spikes{10}.session_time,sorted_spikes{11}.session_time);
sorted_spikes{33}.spike_waves = cat(1,sorted_spikes{10}.spike_waves,sorted_spikes{11}.spike_waves);
sorted_spikes{33}.mean_spike_amp = (sorted_spikes{10}.mean_spike_amp+sorted_spikes{11}.mean_spike_amp)/2;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPEN / CLOSED LOOP COMPARISION

gap = [0.08 0.06];
marg_h = [0.07 0.02];
marg_w = [0.03 0.02];
2
clust_id = 23;
figure
set(gcf,'position',[38   594   962   204])
id_type = 'olR';
keep_name = 'running';
tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
curve1 = tuning_curve.model_fit.curve;
subtightplot(1,4,1,gap,marg_h,marg_w);
plot_tuning_curve_ephys([],tuning_curve)
id_type = 'clR';
keep_name = 'running';
subtightplot(1,4,2,gap,marg_h,marg_w);
tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
curve2 = tuning_curve.model_fit.curve;
plot_tuning_curve_ephys([],tuning_curve)
subtightplot(1,4,3,gap,marg_h,marg_w);
hold on
plot(x_fit_vals,curve1,'Color',[0 0 0],'LineWidth',2)
plot(x_fit_vals,curve2,'Color',[0 0 .6],'LineWidth',2)
xlim([tuning_curve.regressor_obj.x_range])
xlabel(tuning_curve.regressor_obj.x_label)
ylabel('firing rate')
set(gca,'xtick',tuning_curve.regressor_obj.x_tick)
subtightplot(1,4,4,gap,marg_h,marg_w);
hold on
plot(x_fit_vals,zscore(curve1),'Color',[0 0 0],'LineWidth',2)
plot(x_fit_vals,zscore(curve2),'Color',[0 0 .6],'LineWidth',2)
xlim([tuning_curve.regressor_obj.x_range])
xlabel(tuning_curve.regressor_obj.x_label)
ylabel('z-score firing rate')
set(gca,'xtick',tuning_curve.regressor_obj.x_tick)





%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike corr analysis
X_all = [];
for ikk = 1:numel(all_anm.data)
d = all_anm.data{ikk}.d; 
anm_id = all_anm.names{ikk};
spike_times_cluster = d.spike_times_cluster.spike_times_cluster;
    [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
    run_thresh = anm_params.run_thresh;
    trial_range_start = anm_params.trial_range_start;
    trial_range_end = anm_params.trial_range_end;
    cell_reject = anm_params.cell_reject;
    exp_type = anm_params.exp_type;
    layer_4_CSD = anm_params.layer_4;
    boundaries = anm_params.boundaries;
    boundary_labels = anm_params.boundary_labels;
    layer_4 = anm_params.layer_4_corr;
trial_range = trial_range_start(1):min(4000,trial_range_end(1));

time_range = [0 4];

  
id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
groups = d.u_ck(1,keep_trials_tmp);
group_ids = unique(groups);
inds = d.u_ck(1,:);

avg_s = zeros(size(d.s_ctk,1),size(d.s_ctk,2),length(group_ids));
avg_r = zeros(size(d.r_ntk,1),size(d.r_ntk,2),length(group_ids));
for ij = 1:length(group_ids)
    sum(inds == ij & keep_trials_tmp)
    avg_s(:,:,ij) = squeeze(mean(d.s_ctk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
    avg_r(:,:,ij) = squeeze(mean(d.r_ntk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
end

% avg_s = zeros(size(d.s_ctk,1),size(d.s_ctk,2),length(group_ids));
% avg_r = zeros(size(d.r_ntk,1),size(d.r_ntk,2),length(group_ids));
% avg_s = d.s_ctk(:,:,keep_trials_tmp);
% avg_r = d.r_ntk(:,:,keep_trials_tmp);


avg_r = convn(avg_r,ones(1,temp_smooth,1)/temp_smooth,'same');

avg_r = avg_r(:,50:end-50,:);
avg_s = avg_s(:,50:end-50,:);
avg_r = permute(avg_r,[3 2 1]);
avg_s = permute(avg_s,[3 2 1]);

X = reshape(avg_r,[size(avg_r,1)*size(avg_r,2), size(avg_r,3)]);
X = bsxfun(@minus,X,mean(X,2));

X_all = cat(2,X_all,X);
end

[coeff,score,latent] = pca(X_all);

Y = reshape(score,[size(avg_r,1), size(avg_r,2), size(avg_r,3)]);





%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
% Dimensionality reduction simulation


norm_mat = zeros(200,300);
for ij = 1:200
    mu = rand*150;
    %mu = randn*70+150;                                %// Mean
    sigma = 50;                            %// Standard deviation
    %// Plot curve
    x = (-5 * sigma:0.01:5 * sigma) + mu;
    y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));

    x = round(x);
    ind = x>=1 & x <=300;
    norm_mat(ij,x(ind)) = y(ind);
end
figure; imagesc(norm_mat)

%[coeff,score,latent] = pca(norm_mat');
[W,H] = nnmf(norm_mat',30)
score = W;
score = bsxfun(@minus,score,mean(score));
figure
hold on
plot([1 size(norm_mat,2)],[0 0],'k','linewidth',2)
plot(score(:,1))
plot(score(:,2),'g')
%plot(score(:,3),'r')

figure
hold on
plot(0,0,'.k')
plot(score(:,1),score(:,2))



norm_mat = zeros(200,300);
for ij = 1:101
    mu = rand*150;
    %mu = randn*70+150;                                %// Mean
    sigma = 50;                            %// Standard deviation
    %// Plot curve
    x = (-5 * sigma:0.01:5 * sigma) + mu;
    y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));

    x = round(x);
    ind = x>=1 & x <=300;
    norm_mat(ij,x(ind)) = y(ind);
end
for ij = 101:200
    mu = rand*150;
    %mu = randn*70+150;                                %// Mean
    sigma = 50;                            %// Standard deviation
    %// Plot curve
    x = (-5 * sigma:0.01:5 * sigma) + mu;
    y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));

    x = round(x);
    ind = x>=1 & x <=300;
    norm_mat(ij,x(ind)) = max(y) - y(ind);
    norm_mat(ij,max(x(ind)):end) = max(y);
end
norm_mat(norm_mat<0) = 0;
figure; imagesc(norm_mat)

%[coeff,score,latent] = pca(norm_mat');
[W,H] = nnmf(norm_mat',2)
score = W;
score = bsxfun(@minus,score,mean(score));
figure
hold on
plot([1 size(norm_mat,2)],[0 0],'k','linewidth',2)
plot(score(:,1))
plot(score(:,2),'g')
%plot(score(:,3),'r')

figure
hold on
plot(0,0,'.k')
plot(score(:,1),score(:,2))


% figure
% hold on
% plot([1 size(norm_mat,2)],[0 0],'k','linewidth',2)
% plot(zscore(diff(score(:,1))))
% plot(zscore(score(:,2)),'g')

% figure
% hold on
% plot([1 size(norm_mat,2)],[0 0],'k','linewidth',2)
% plot(zscore(diff(score(:,2))))
% plot(-zscore(score(:,3)),'g')




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


norm_mat = zeros(200,300);
for ij = 1:200
    mu = rand*300;
    %mu = randn*70+150;                                %// Mean
    sigma = 50;                            %// Standard deviation
    %// Plot curve
    x = (-5 * sigma:0.01:5 * sigma) + mu;
    y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));
    x = round(x);
    ind = x>=1 & x <=300;
    norm_mat(ij,x(ind)) = y(ind);
end
figure; imagesc(norm_mat)

[coeff,score,latent] = pca(norm_mat');
%[W,H] = nnmf(norm_mat',3);
W = score';

norm_mat2 = zeros(200,300);
for ij = 1:200
    iP = ceil(rand*3);
    base = W(iP,:);
    mu = round(rand*300)
    norm_mat2(ij,:) = circshift(base',mu)';
end
figure; imagesc(norm_mat2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TUNING CURVES

f_nc = norm_mat(:,1:5:end);
f_nc_sup = zscore(f_nc);
[perf_sup N_sup] = decode_population(f_nc_sup,[1:2:30]);

f_nc = norm_mat2(:,1:5:end);
f_nc_deep = zscore(f_nc);
[perf_deep N_deep] = decode_population(f_nc_deep,[1:2:30]);

figure;
hold on
plot(N_sup,perf_sup,'r')
plot(N_deep,perf_deep,'k')


figure;
subplot(1,2,1)
imagesc(f_nc_sup)
subplot(1,2,2)
imagesc(f_nc_deep)


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%


tuning_curve = all_anm.data{2}.d.summarized_cluster{13}.TOUCH_TUNING;



anm_id = 2;
clust_id = 13;

d = all_anm.data{anm_id}.d;
time_range = [0 1.1];
time_range = [1.1 3];
run_thresh = all_anm.data{anm_id}.d.anm_params.run_thresh;
trial_range = all_anm.data{anm_id}.d.anm_params.trial_range_start(1):min(4000,all_anm.data{anm_id}.d.anm_params.trial_range_end(1));
exp_type = all_anm.data{anm_id}.d.anm_params.exp_type;


    stim_name = 'corPos';
    keep_name = 'running';
    id_type_wall_tuning = 'olR';
    tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type_wall_tuning,time_range,trial_range,run_thresh);


figure
plot_tuning_curve_ephys_col([],tuning_curve)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


anm_id = 2;
cluster_id = 3;

script_svd_raster;








