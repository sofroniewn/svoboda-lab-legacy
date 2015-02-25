function plot_clusters_tuning_paper(all_anm,ps,order)

boundary_labels = {'Pia', 'L1', 'L2/3', 'L4', 'L5A', 'L5B', 'L6'};
barrel_inds = {'C1','C2','C3','C4','D1','D2','B1','V1'};


for ikk = 1:size(order,1)
    anm_num = order(ikk,1);
    anm_index = find(ismember(all_anm.names,num2str(anm_num)));
    clust_num = order(ikk,2);
    d = all_anm.data{anm_index}.d;
    
    s_ind = find(strcmp(d.p_labels,'clust_id'));
    clust_id = d.p_nj(clust_num,s_ind);
    
    s_ind = find(strcmp(d.p_labels,'anm_id'));
    anm_id = d.p_nj(clust_num,s_ind);
    
    figure(110+ikk)
    clf(110+ikk)
    fig_props = [];

    set(gcf,'Color',[1 1 1])
        set(gcf,'Position',[10   613   1365   193])
        gap = [0.05 0.03];
        marg_h = [0.08 0.03];
        marg_w = [0.01 0.01];
        num_plots_h = 1;
        num_plots_w = 10;


    % Make touch tuning
%    tuning_curve = d.summarized_cluster{clust_num}.TOUCH_TUNING;
%
%
exp_type = d.anm_params.exp_type;
    keep_name = 'running';
    id_type = 'olR';
    trial_range_end = min(4000,d.anm_params.trial_range_end(1));
    trial_range = [d.anm_params.trial_range_start(1):trial_range_end];
    run_thresh = d.anm_params.run_thresh;
    constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
    keep_trials = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);


    RASTER = d.summarized_cluster{clust_num}.RUNNING_RASTER;
   
   [group_ids groups] = define_group_ids(exp_type,id_type,[]);
 
    raster_mat_full = squeeze(d.s_ctk(1,:,keep_trials))';
    vals = raster_mat_full(:,1000);
    u_vals = unique(vals);
    raster_mat_full = max(raster_mat_full(:)) - raster_mat_full;

tc = zeros(length(group_ids),1);
for ij = 1:length(group_ids)
    num_trials = sum(vals == u_vals(ij));
    tc(ij) = sum(RASTER.spikes{ij}>1 & RASTER.spikes{ij}<3)/2/num_trials;
end


    run_thresh = all_anm.data{anm_index}.d.anm_params.run_thresh;
    trial_range = all_anm.data{anm_index}.d.anm_params.trial_range_start(1):min(4000,all_anm.data{anm_index}.d.anm_params.trial_range_end(1));
    exp_type = all_anm.data{anm_index}.d.anm_params.exp_type;
    keep_name = 'running';

regressor_tune_type = 'Smooth';
    stim_name = 'wall_direction';
    time_range = [2 3];
    tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh,regressor_tune_type); 
    subtightplot(num_plots_h,num_plots_w,[4],gap,marg_h,marg_w)
    %plot_tuning_curve_ephys(fig_props,tuning_curve)
   
 constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);

raster_mat = squeeze(d.r_ntk(clust_id,:,keep_trials))';
sense_mat = squeeze(d.s_ctk(1,:,keep_trials))';
[group_ids groups] = define_group_ids(exp_type,id_type,[]);
groups = d.u_ck(1,keep_trials);

raster_mat_avg = NaN(length(group_ids),size(raster_mat,2));
sense_mat_avg = NaN(length(group_ids),size(raster_mat,2));
time_mat_avg = NaN(length(group_ids),size(raster_mat,2));
for ij = 1:length(group_ids)
  tmp = mean(raster_mat(groups == group_ids(ij),:),1);
  tmps = mean(sense_mat(groups == group_ids(ij),:),1);
  if ~isempty(tmp)
    raster_mat_avg(ij,:) = tmp;
    sense_mat_avg(ij,:) = tmps;
    time_mat_avg(ij,:) = [1:size(raster_mat,2)]/500;
  end
end

temp_smooth = 80;
raster_mat = conv2(raster_mat,ones(1,temp_smooth)/temp_smooth,'same');
raster_mat_avg = 500*conv2(raster_mat_avg,ones(1,temp_smooth)/temp_smooth,'same');

avg_on = NaN(length(group_ids),601);
avg_off = NaN(length(group_ids),601);

for ij = 1:length(group_ids)
    onset = find(sense_mat_avg(ij,:)<=16,1,'first');
     offset = find(sense_mat_avg(ij,:)<=16,1,'last');
  if ~isempty(onset) && ~isempty(offset)
      avg_on(ij,:) = raster_mat_avg(ij,onset-200:onset+400);
      avg_off(ij,:) = raster_mat_avg(ij,offset-400:offset+200);
  end
end
avg_off = flipdim(avg_off,2);

avg_on = nanmean(avg_on);
avg_off = nanmean(avg_off);

%avg_on = smooth(nanmean(avg_on),50);
%avg_off = smooth(nanmean(avg_off),50);

hold on
plot(avg_on)
plot(avg_off,'r')
text(.1,.95,num2str(log(sum(avg_on)/sum(avg_off))),'units','normalized')
xlim([1 601])

 % full_x = sense_mat_avg(:);
 % full_y = time_mat_avg(:);
 % full_z = raster_mat_avg(:);

 %             baseline = nanmean(full_z(full_x>22));
 %             full_z = full_z - baseline;
         
 %             initPrs = [8 1 2 -1 10];
 %             model_fit = fitGS2D(full_x,full_y,full_z,initPrs);
         
 %          x_vals = [0:.5:30];
 %          y_vals = [0:.1:4];
 % % [X Y] = meshgrid(x_vals,y_vals);
 % % curve = baseline + fitGS2D_modelFun(X(:),Y(:),model_fit.estPrs);
 % % model_fit.curve = reshape(curve,[length(x_vals) length(y_vals)]);     
 %  curve = baseline + fitGS2D_modelFun(full_x,full_y,model_fit.estPrs);
 %  model_fit.curve = reshape(curve,[length(group_ids) size(raster_mat_avg,2)]);     

 %         figure(310+ikk); subplot(2,2,1); imagesc(model_fit.curve); set(gca,'ydir','normal')
 %         subplot(2,2,4); imagesc(raster_mat_avg); set(gca,'ydir','normal')

 % curve_G = fitGauss_modelFun(x_vals,[model_fit.estPrs([1 2 5]) baseline]);    
 % curve_S = fitSigmoid_modelFun(y_vals,[model_fit.estPrs([5 4]) baseline model_fit.estPrs(3)]);    
 % subplot(2,2,2); plot(curve_G);
 % subplot(2,2,3); plot(y_vals,curve_S); xlim([0 4]);

%sense_mat_avg = conv2(sense_mat_avg,ones(1,temp_smooth)/temp_smooth,'same');

raster_mat_avg_red = raster_mat_avg(:,81:20:end-80);
sense_mat_avg_red = sense_mat_avg(:,81:20:end-80);
assignin('base','sense_mat_avg_red',sense_mat_avg_red)

 X = raster_mat_avg_red(:);
 Y = sense_mat_avg_red(:);

 % initPrs = [8 1 0 mean(X(Y>22))];
 % out   = fitBiGaussK(sense_mat_avg_red,raster_mat_avg_red,initPrs,5);
 % curve = fitBiGaussK_modelFun(sense_mat_avg_red,out.estPrs);
 % out.estPrs(1:5)
 % x_vals = [0:.5:30];
 % est_prs = out.estPrs(1:5);
 % est_prs(4) = 0;
 % est_prs(5) = 1;
 % curve_G = fitBiGauss_modelFun(x_vals,est_prs);
 % curve_K = out.estPrs(5:end);

 %  figure(410+ikk); clf(410+ikk); subplot(2,2,1); imagesc(curve); set(gca,'ydir','normal')
 %  subplot(2,2,4); imagesc(raster_mat_avg_red); set(gca,'ydir','normal')
 %  subplot(2,2,2); hold on; plot(curve_G);
 %  subplot(2,2,3); hold on; plot(curve_K);


% baseline = prs(1);
% prsG1 = prs(2:4);
% prsG2 = prs(5:7);
% prsK1 = prs(8:9);
% prsK2 = prs(10:11);
% prsKw = prs(12);
% prsKs = prs(13);

weight = mean(raster_mat_avg_red(:,20:60),2);
stim = mean(sense_mat_avg_red(:,20:60),2);

[val_M ind_M] = max(weight);
[val_m ind_m] = min(weight);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DOUBLE GAUSS WITH EXP
% 
% baseline = mean(X(Y>22));
% prsG1 = [stim(ind_M) 1 0];
% prsK1 = [1 1];
% prsK2 = [1 1];
% prsKw = (val_M-baseline)/(val_M + val_m -baseline);
% prsKw(prsKw<0) = 0;
% prsKw(prsKw>1) = 1;
% prsKs = val_M + val_m - baseline;
% prsKw = .5;
% initPrs = [baseline prsG1 prsK1 prsK2 prsKw prsKs];
% length(initPrs)
% 
% 
%   out = fitGaussKGamma(sense_mat_avg_red,raster_mat_avg_red,initPrs);
%   curve = fitGaussKGamma_modelFun(sense_mat_avg_red,out.estPrs);
% 
%   x_vals = [0:.5:30];
%   est_prs = out.estPrs(2:4);
%   est_prs(4) = 0;
%   est_prs(5) = 1;
%   curve_G1 = fitBiGauss_modelFun(x_vals,est_prs);
% 
%   length_K = (length(out.estPrs)-7)/2;
%   prs_K1 = out.estPrs(5:6);
%   prs_K2 = out.estPrs(7:8);
%   prs_Kw = out.estPrs(9);
%   prs_Ks = out.estPrs(10);
% 
% curve_K1 = gampdf([1:.1:10],prs_K1(1),prs_K1(2));
% curve_K1 = curve_K1/max(curve_K1)*prs_Kw;
% curve_K2 = gampdf([1:.1:10],prs_K2(1),prs_K2(2));
% curve_K2 = curve_K2/max(curve_K2)*(1-prs_Kw);
% 
% [initPrs;out.estPrs]
% 
%   figure(410+ikk); clf(410+ikk); subplot(2,2,1); imagesc(curve); set(gca,'ydir','normal')
%   subplot(2,2,4); imagesc(raster_mat_avg_red); set(gca,'ydir','normal')
%   subplot(2,2,2); hold on; plot(curve_G1); %plot(curve_G2,'r');
%   subplot(2,2,3); hold on; plot(curve_K1); plot(curve_K2,'r');
% 
% 

% baseline = prs(1);
% gain = prs(2);
% weight = prs(3);
% center_1 = prs(4);
% scale_1 = prs(5);
% center_2 = prs(6);
% scale_2 = prs(7);
% prsK_1 = prs(8:9);
% prsK_2 = prs(10:11);

baseline = 3;
gain = 8;
weight = 0.1;
center_1 = 10;
scale_1 = 1;
center_2 = 10;
scale_2 = 1;
prsK_1 = [0.1];
prsK_2 = [0.1];


initPrs = [baseline gain weight center_1 scale_1 center_2 scale_2 prsK_1 prsK_2];
initPrs = [0 40 1/4 8 4 5 1 -3.5/4 0];
initPrs =[-3.3957   40.9997    0.4677   12.5018    3.1539   11.4084    2.6212    0.1    .9];
initPrs =[0   40.9997    0.5   12.5018    3.1539   11.4084    2.6212    0.1    .9];

out = fitDoubleSigmoidKnp(sense_mat_avg_red,raster_mat_avg_red,initPrs);
curve = fitDoubleSigmoidKnp_modelFun(sense_mat_avg_red,out.estPrs);

out.estPrs;

x_vals = [0:.5:30];
prs = out.estPrs([2 5 1 4]);
prs(1) = prs(1)*(1+out.estPrs(8));
curve_G1 = fitSigmoid_modelFun(x_vals,prs);
prs = out.estPrs([2 7 1 6]);
prs(1) = prs(1)*out.estPrs(3);
prs(1) = prs(1)*(1+out.estPrs(9));
prs(3) = 0;
curve_G2 = fitSigmoid_modelFun(x_vals,prs);

curve_G = curve_G1 - curve_G2;
curve_G(curve_G<0) = 0;

tc_baseline = curve_G(end);
tc_min_val = min(curve_G);
tc_max_val = max(curve_G);

curve_K1 = [1 out.estPrs(8)];
curve_K2 = [1 out.estPrs(9)];

xt_vals = [repmat(30,1,10) linspace(30,0,25) repmat(0,1,10)]; % downsample by 20, so 500/20 = 25 timepoints per second
curve_xt_on = fitDoubleSigmoidKnp_modelFun(xt_vals,out.estPrs);
curve_xt_off = fitDoubleSigmoidKnp_modelFun(flipdim(xt_vals,2),out.estPrs);
curve_xt_off = flipdim(curve_xt_off,2);

xt_vals = xt_vals(11:end-10);
curve_xt_on = curve_xt_on(11:end-10);
curve_xt_off = curve_xt_off(11:end-10);

xt_vals = linspace(0,1,25);
    % figure(410+ikk); clf(410+ikk); subplot(2,2,1); imagesc(curve); set(gca,'ydir','normal')
    % subplot(2,2,4); imagesc(raster_mat_avg_red); set(gca,'ydir','normal')
    % subplot(2,2,2); hold on; plot(x_vals,curve_G1); plot(x_vals,curve_G2,'r'); xlim([0 30])
    % subplot(2,2,3); hold on; plot(curve_K1); plot(curve_K2,'r');

    subtightplot(num_plots_h,num_plots_w,[5:6],gap,marg_h,marg_w)
    imagesc(raster_mat_avg_red); set(gca,'ydir','normal')
    set(gca,'visible','off');
    subtightplot(num_plots_h,num_plots_w,[7:8],gap,marg_h,marg_w)
    imagesc(curve); set(gca,'ydir','normal')
    text(.83,.93,sprintf('%.2f',out.r2),'Color',[1 .5 0],'Units','normalized','Fontsize',16)
    set(gca,'visible','off');
    subtightplot(num_plots_h,num_plots_w,[10],gap,marg_h,marg_w)
    %hold on; plot(curve_K1); plot(curve_K2,'r'); ylim([0 1])
    hold on; plot(xt_vals,curve_xt_on); plot(xt_vals,curve_xt_off,'r'); xlim([0 1]);
    %hold on; plot([0:10],[0:10],'r'); plot(curve_xt_on,curve_xt_off,'k','LineWidth',3);
    
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  baseline = mean(X(Y>22));
%  prsG1 = [stim(ind_M) 1 0];
%  prsV = [0 0 1];
%  initPrs = [baseline prsG1 val_M prsV];

%    out = fitGaussV(sense_mat_avg_red,raster_mat_avg_red,initPrs);
%    curve = fitGaussV_modelFun(sense_mat_avg_red,out.estPrs);

%    x_vals = [0:.5:30];
%    prsG1 = out.estPrs(1:5);
% curve_G1 = skewnormpdf(x_vals(:),prsG1(2),prsG1(3),prsG1(4)); %normpdf(xvals,prs(1),prs(2));
% curve_G1 = curve_G1/max(curve_G1);
% curve_G1 = prsG1(5)*curve_G1 + prsG1(1);


  
%     prs_V = out.estPrs(6:8)*10;


%    figure(410+ikk); clf(410+ikk); subplot(2,2,1); imagesc(curve); set(gca,'ydir','normal')
%    subplot(2,2,4); imagesc(raster_mat_avg_red); set(gca,'ydir','normal')
%    subplot(2,2,2); hold on; plot(curve_G1);% plot(curve_G2,'r');
%    subplot(2,2,3); hold on; plot(prs_V,'r');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % DOUBLE GAUSS WITH GAMMA

%  baseline = mean(X(Y>22));
%  prsG1 = [stim(ind_M) 1 0 1];
%  prsG2 = [stim(ind_m) 1 0];
%  prsK1 = [1 1];
%  initPrs = [prsG1 prsK1 val_M baseline];
%  %length(initPrs)
%    out = fitBGKGamma(sense_mat_avg_red,raster_mat_avg_red,initPrs);
%    curve = fitBGKGamma_modelFun(sense_mat_avg_red,out.estPrs);

%    x_vals = [0:.5:30];
%    est_prs = out.estPrs(1:4);
%    curve_G1 = bimodnormpdf(x_vals,est_prs(1),est_prs(2),est_prs(3),est_prs(4));

%    prs_K1 = out.estPrs(5:6);
%  curve_K1 = gampdf([1:.1:10],prs_K1(1),prs_K1(2));
%  curve_K1 = curve_K1/max(curve_K1);

%    figure(410+ikk); clf(410+ikk); subplot(2,2,1); imagesc(curve); set(gca,'ydir','normal')
%    subplot(2,2,4); imagesc(raster_mat_avg_red); set(gca,'ydir','normal')
%    subplot(2,2,2); hold on; plot(curve_G1);% plot(curve_G2,'r');
%    subplot(2,2,3); hold on; plot(curve_K1);% plot(curve_K2,'r');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % DOUBLE GAUSS WITH GAMMA
% 
%  baseline = mean(X(Y>22));
%  prsG1 = [stim(ind_M) 1 0];
%  prsG2 = [stim(ind_m) 1 0];
%  prsK1 = [1 1];
%  prsK2 = [1 1];
%  prsKw = (val_M-baseline)/(val_M + val_m -baseline);
%  prsKw(prsKw<0) = 0;
%  prsKw(prsKw>1) = 1;
%  prsKs = val_M + val_m - baseline;
%  %prsKw = .5;
%  initPrs = [prsG1 prsG2 prsK1 prsK2 prsKw prsKs];
%  %length(initPrs)
% 
%    out = fitDoubleGaussKGamma(sense_mat_avg_red,raster_mat_avg_red - baseline,initPrs);
%    curve = fitDoubleGaussKGamma_modelFun(sense_mat_avg_red,out.estPrs) + baseline;
% 
%    x_vals = [0:.5:30];
%    est_prs = out.estPrs(1:3);
%    est_prs(4) = 0;
%    est_prs(5) = 1;
%    curve_G1 = fitBiGauss_modelFun(x_vals,est_prs);
%    est_prs = out.estPrs(4:6);
%    est_prs(4) = 0;
%    est_prs(5) = 1;
%    curve_G2 = fitBiGauss_modelFun(x_vals,est_prs);
% 
%    length_K = (length(out.estPrs)-7)/2;
%    prs_K1 = out.estPrs(7:8);
%    prs_K2 = out.estPrs(9:10);
%    prs_Kw = out.estPrs(11);
%    prs_Ks = out.estPrs(1);
% 
%  curve_K1 = gampdf([1:.1:10],prs_K1(1),prs_K1(2));
%  curve_K1 = curve_K1/max(curve_K1)*prs_Kw;
%  curve_K2 = gampdf([1:.1:10],prs_K2(1),prs_K2(2));
%  curve_K2 = curve_K2/max(curve_K2)*(1-prs_Kw);
% 
%  [initPrs;out.estPrs]
% 
%    figure(410+ikk); clf(410+ikk); subplot(2,2,1); imagesc(curve); set(gca,'ydir','normal')
%    subplot(2,2,4); imagesc(raster_mat_avg_red); set(gca,'ydir','normal')
%    subplot(2,2,2); hold on; plot(curve_G1); plot(curve_G2,'r');
%    subplot(2,2,3); hold on; plot(curve_K1); plot(curve_K2,'r');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% baseline = mean(X(Y>22))
% prsG1 = [stim(ind_M) 1 0];
% prsG2 = [stim(ind_m) 1 0];
% prsK1 = [1];
% prsK2 = [1];
% prsKw = (val_M)/(val_M + val_m);
% prsKw(prsKw<0) = 0;
% prsKw(prsKw>1) = 1;
% prsKs = val_M + val_m;
% initPrs = [prsG1 prsG2 prsK1 prsK2 prsKw prsKs];

%    out = fitDoubleGaussKExp(sense_mat_avg_red,raster_mat_avg_red - baseline,initPrs);
%    curve = baseline + fitDoubleGaussKExp_modelFun(sense_mat_avg_red,out.estPrs);

%    x_vals = [0:.5:30];
%    est_prs = out.estPrs(1:3);
%    est_prs(4) = 0;
%    est_prs(5) = 1;
%    curve_G1 = fitBiGauss_modelFun(x_vals,est_prs);
%    est_prs = out.estPrs(4:6);
%    est_prs(4) = 0;
%    est_prs(5) = 1;
%    curve_G2 = fitBiGauss_modelFun(x_vals,est_prs);

%    length_K = (length(out.estPrs)-7)/2;
%    prs_K1 = out.estPrs(7);
%    prs_K2 = out.estPrs(8);
%    prs_Kw = out.estPrs(9);
%    prs_Ks = out.estPrs(10);

%  curve_K1 = exppdf([1:.1:10],prs_K1(1));
%  curve_K1 = curve_K1/max(curve_K1)*prs_Kw;
%  curve_K2 = exppdf([1:.1:10],prs_K2(1));
%  curve_K2 = curve_K2/max(curve_K2)*(1-prs_Kw);

%  [initPrs;out.estPrs]

%    figure(410+ikk); clf(410+ikk); subplot(2,2,1); imagesc(curve); set(gca,'ydir','normal')
%    subplot(2,2,4); imagesc(raster_mat_avg_red); set(gca,'ydir','normal')
%    subplot(2,2,2); hold on; plot(curve_G1); plot(curve_G2,'r');
%    subplot(2,2,3); hold on; plot(curve_K1); plot(curve_K2,'r');






 % initPrs = [mean(X(Y>22)) 15 1 0 15 1 0];
 %  out = fitDoubleGaussK(sense_mat_avg_red,raster_mat_avg_red,initPrs,5);
 %  curve = fitDoubleGaussK_modelFun(sense_mat_avg_red,out.estPrs);

 %  x_vals = [0:.5:30];
 %  est_prs = out.estPrs(2:4);
 %  est_prs(4) = 0;
 %  est_prs(5) = 1;
 %  curve_G1 = fitBiGauss_modelFun(x_vals,est_prs);
 %  est_prs = out.estPrs(5:7);
 %  est_prs(4) = 0;
 %  est_prs(5) = 1;
 %  curve_G2 = fitBiGauss_modelFun(x_vals,est_prs);

 %  length_K = (length(out.estPrs)-7)/2;
 %  curve_K1 = out.estPrs(8:8+length_K-1);
 %  curve_K2 = out.estPrs(8+length_K:end);


 %  figure(410+ikk); clf(410+ikk); subplot(2,2,1); imagesc(curve); set(gca,'ydir','normal')
 %  subplot(2,2,4); imagesc(raster_mat_avg_red); set(gca,'ydir','normal')
 %  subplot(2,2,2); hold on; plot(curve_G1); plot(curve_G2,'r');
 %  subplot(2,2,3); hold on; plot(curve_K1); plot(curve_K2,'r');

 curve_m = curve(1,:);
% curve_m = mean(curve,1);
%figure(510+ikk); clf(510+ikk); hold on; plot(curve_m); plot(raster_mat_avg_red(1,:),'g')

% figure(110+ikk)

    raster_mat_avg = mean(raster_mat_avg(:,[501:1500]),2);
    sense_mat_avg = mean(sense_mat_avg(:,[501:1500]),2);
   
%     regressor_tune_type = 'BiGauss';    
%     stim_name = 'corPos';
%     time_range = [0 4];
%     tuning_curve = get_tuning_curve_ephys_red(raster_mat_avg(:),sense_mat_avg(:),d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh,regressor_tune_type);
%    % tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh,regressor_tune_type);
     subtightplot(num_plots_h,num_plots_w,[3],gap,marg_h,marg_w)
% %    models.BiGauss = tuning_curve.model_fit;
% %    tuning_curve.model_fit = [];
%     plot_tuning_curve_ephys_col(fig_props,tuning_curve)
% text(.9,.95,sprintf('%0.2f',tuning_curve.model_fit.r2),'units','normalized','Color',[0 0 0])
    regressor_tune_type = 'DoubleGauss';    
    stim_name = 'corPos';
    time_range = [0 4];
        tuning_curve = get_tuning_curve_ephys_red(raster_mat_avg(:),sense_mat_avg(:),d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh,regressor_tune_type);
    %tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh,regressor_tune_type);
    plot_tuning_curve_ephys_col(fig_props,tuning_curve)
    plot(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.curve,'LineWidth',2,'Color','r')
text(.9,.85,sprintf('%0.2f',tuning_curve.model_fit.r2),'units','normalized','Color',[1 0 0])




    subtightplot(num_plots_h,num_plots_w,[9],gap,marg_h,marg_w)
    tuning_curve.model_fit = [];
        plot_tuning_curve_ephys_col(fig_props,tuning_curve)
%hold on; plot(x_vals,curve_G1); plot(x_vals,curve_G2,'r'); xlim([0 30])
    y_max = max(ceil(max(curve_G)/2)*2,1);
    hold on; plot(x_vals,curve_G,'k','LineWidth',3); %xlim([0 30]); ylim([0 y_max])


tc_baseline = curve_G(end);
tc_min_val = min(curve_G);
tc_max_val = max(curve_G);
text(.9,.85,sprintf('b %0.2f',tc_baseline),'units','normalized','Color',[1 .5 0])
text(.9,.77,sprintf('M %0.2f',tc_max_val),'units','normalized','Color',[1 .5 0])
text(.9,.69,sprintf('m %0.2f',tc_min_val),'units','normalized','Color',[1 .5 0])

tc_sup = tc_baseline - tc_min_val;
tc_act = tc_max_val - tc_baseline;
tc_mix = (abs(tc_act) - abs(tc_sup))/(abs(tc_act) + abs(tc_sup));

text(.9,.55,sprintf('s %0.2f',tc_sup),'units','normalized','Color',[0 .5 1])
text(.9,.47,sprintf('a %0.2f',tc_act),'units','normalized','Color',[0 .5 1])
text(.9,.39,sprintf('c %0.2f',tc_mix),'units','normalized','Color',[0 .5 1])



       % Make trial Raster to running and contra touch
    subtightplot(num_plots_h,num_plots_w,[1 2],gap,marg_h,marg_w)
    %plot_spk_raster(fig_props,RASTER,[],[],[])
    plot_spk_raster_col([],RASTER,[],[],raster_mat_full);
    set(gca,'xticklabel',[])
    xlabel('')
   % plot([.5 .5],[0 500],'g')
   % plot([1 1],[0 500],'g')
   % plot([3 3],[0 500],'g')
   % plot([3.5 3.5],[0 500],'g')

    %col_mat = [0 0 0];
    %plot(tuning_curve.regressor_obj.x_vals(ij),tuning_curve.means(ij),'Color',col_mat,'Marker','.','MarkerSize',20);


%c_map = cbrewer('seq','Blues',64);
%c_map = cbrewer('seq','PuBu',64);
%c_map = jet(64);
%96c6fd
% c_map = zeros(64,3);

% %c_map(:,1) = linspace(253,144,64)/256;
% %c_map(:,2) = linspace(174,185,64)/256;
% %c_map(:,3) = linspace(107,247,64)/256;


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

% c_map = zeros(64,3);
% c_map(:,1) = linspace(0.35,.05,64);
% c_map(:,2) = .5;
% c_map(:,3) = 1;
% c_map = hsv2rgb(c_map);

% c_map = cbrewer('div','RdYlBu',64);
% c_map = flipdim(c_map,1)/1.5+.33;

%c_map = jet(64);
%c_map = c_map/2+.5;

%c_map(:,2) = 1;
set(gcf,'colormap',c_map)
colormap 'gray';

end