function plot_clusters_tuning_paper(all_anm,ps,order)

boundary_labels = {'Pia', 'L1', 'L2/3', 'L4', 'L5A', 'L5B', 'L6'};
barrel_inds = {'C1','C2','C3','C4','D1','D2','B1','V1'};


for ij = 1:size(order,1)
    anm_num = order(ij,1);
    anm_index = find(ismember(all_anm.names,num2str(anm_num)));
    clust_num = order(ij,2);
    d = all_anm.data{anm_index}.d;
    
    s_ind = find(strcmp(d.p_labels,'clust_id'));
    clust_id = d.p_nj(clust_num,s_ind);
    
    s_ind = find(strcmp(d.p_labels,'anm_id'));
    anm_id = d.p_nj(clust_num,s_ind);
    
    figure(110+ij)
    clf(110+ij)
    fig_props = [];

    set(gcf,'Color',[1 1 1])
        set(gcf,'Position',[10   613   560   193])
        gap = [0.05 0.07];
        marg_h = [0.08 0.03];
        marg_w = [0.03 0.01];
        num_plots_h = 1;
        num_plots_w = 3;
   
    % Make trial Raster to running and contra touch
    RASTER = d.summarized_cluster{clust_num}.RUNNING_RASTER;
    subtightplot(num_plots_h,num_plots_w,[1 2],gap,marg_h,marg_w)
    
    [raster_mat raster_mat_full raster_mat_rescale_full raster_col_mat rescale_time] = get_raster_col_mat(d);

    %plot_spk_raster(fig_props,RASTER,[],[],[])
    plot_spk_raster_col([],RASTER,[],[],raster_mat_full);
    set(gca,'xticklabel',[])
    xlabel('')
   
    % Make touch tuning
%    tuning_curve = d.summarized_cluster{clust_num}.TOUCH_TUNING;
%
%

    run_thresh = all_anm.data{anm_index}.d.anm_params.run_thresh;
    trial_range = all_anm.data{anm_index}.d.anm_params.trial_range_start(1):min(4000,all_anm.data{anm_index}.d.anm_params.trial_range_end(1));
    exp_type = all_anm.data{anm_index}.d.anm_params.exp_type;
    stim_name = 'corPos';
    keep_name = 'running';
    id_type_wall_tuning = 'olR';
    time_range = [1 3];

    tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type_wall_tuning,time_range,trial_range,run_thresh);


    full_x = [];
    full_y = [];
    for ij = 1:length(tuning_curve.regressor_obj.x_vals)
        full_x = [full_x;repmat(tuning_curve.regressor_obj.x_vals(ij),length(tuning_curve.data{ij}),1)];
        full_y = [full_y;tuning_curve.data{ij}];
    end
    
    p = 10^-5;
    tuning_curve.model_fit.curve = csaps(full_x,full_y,p,tuning_curve.regressor_obj.x_fit_vals);
    [pks loc] = max(tuning_curve.model_fit.curve);
    tuning_curve.model_fit.estPrs = tuning_curve.regressor_obj.x_fit_vals(loc);
    tuning_curve.model_fit.r2 = 0;
    if tuning_curve.num_pts(1) == 0;
        ind = find(tuning_curve.num_pts>0,1,'first');
        val = tuning_curve.regressor_obj.x_vals(ind-1);
        ind = find(tuning_curve.regressor_obj.x_fit_vals<=val,1,'last');
        tuning_curve.model_fit.curve(1:ind) = tuning_curve.model_fit.curve(ind+1);
    end
    if tuning_curve.num_pts(end) == 0;
        ind = find(tuning_curve.num_pts>0,1,'last');
        val = tuning_curve.regressor_obj.x_vals(ind+1);
        ind = find(tuning_curve.regressor_obj.x_fit_vals<=val,1,'last');
        tuning_curve.model_fit.curve(ind+1:end) = tuning_curve.model_fit.curve(ind);
    end
        
    subtightplot(num_plots_h,num_plots_w,[3],gap,marg_h,marg_w)
    plot_tuning_curve_ephys_col(fig_props,tuning_curve)


%c_map = cbrewer('seq','Blues',64);
%c_map = cbrewer('seq','PuBu',64);
%c_map = jet(64);
%96c6fd
% c_map = zeros(64,3);

% %c_map(:,1) = linspace(253,144,64)/256;
% %c_map(:,2) = linspace(174,185,64)/256;
% %c_map(:,3) = linspace(107,247,64)/256;

 c_map = zeros(64,3);
 c_map(1:20,1) = linspace(144,(253+144)/2,20)/256;
 c_map(1:20,2) = linspace(185,(174+185)/2,20)/256;
 c_map(1:20,3) = linspace(247,(107+247)/2,20)/256;
 c_map(21:42,1) = linspace((253+144)/2,253,22)/256;
 c_map(21:42,2) = linspace((174+185)/2,174,22)/256;
 c_map(21:42,3) = linspace((107+247)/2,107,22)/256;
 c_map(43:64,1) = linspace(253,239,22)/256;
 c_map(43:64,2) = linspace(174,101,22)/256;
 c_map(43:64,3) = linspace(107,72,22)/256;

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

end