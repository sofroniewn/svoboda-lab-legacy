function plot_clusters_tuning_paper3(all_anm,ps,order,plot_on,rasters)

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
    
    s_ind = find(strcmp(d.p_labels,'layer_4_dist'));
    depth = d.p_nj(clust_num,s_ind);
    
    ih = order(ikk,3);
    if ~isempty(rasters)
    output = rasters{ih};
    else
    output = summarize_tuning_sig_opto(d,clust_num);        
    end    

    if plot_on
        figure(110+ikk)
        clf(110+ikk)
        fig_props = [];
        
        set(gcf,'Color',[1 1 1])
        set(gcf,'Position',[10   613   800   193])
        gap = [0.2 0.06];
        marg_h = [0.08 0.03];
        marg_w = [0.01 0.01];
        num_plots_h = 1;
        num_plots_w = 5;
        
        
        % plot asymm
        subtightplot(num_plots_h,num_plots_w,[4:5],gap,marg_h,marg_w)
        hold on
        plot(output.trace_t,output.trace_on,'LineWidth',2)
        plot(1.2+output.trace_t,flipdim(output.trace_off,2),'r','LineWidth',2)
        text(.1,.06+.85,sprintf('m %0.2f',output.towards),'units','normalized','Color',[1 .5 0])
        text(.8,.06+.85,sprintf('m %0.2f',output.away),'units','normalized','Color',[1 .5 0])
        text(.5,.11+.85,sprintf('c %0.2f',output.dir_mod),'units','normalized','Color',[0 .5 1],'Fontsize',16)
        xlim([0 2.2]);
        

        
        
        
        subtightplot(num_plots_h,num_plots_w,[3],gap,marg_h,marg_w)
        %output.tuning_curve.model_fit = [];
        plot_tuning_curve_ephys_col(fig_props,output.tuning_curve)
        %hold on; plot(x_vals,curve_G1); plot(x_vals,curve_G2,'r'); xlim([0 30])
        %hold on; plot(output.tc_xvals,output.tc,'k','LineWidth',3); %xlim([0 30]); ylim([0 y_max])
        text(.9,.06+.85,sprintf('b %0.2f',output.baseline),'units','normalized','Color',[1 .5 0])
        text(.9,.06+.77,sprintf('M %0.2f',output.baseline+output.act),'units','normalized','Color',[1 .5 0])
        text(.9,.06+.69,sprintf('m %0.2f',output.baseline-output.sup),'units','normalized','Color',[1 .5 0])
        text(.9,.06+.55,sprintf('s %0.2f',output.sup),'units','normalized','Color',[0 .5 1])
        text(.9,.06+.47,sprintf('a %0.2f',output.act),'units','normalized','Color',[0 .5 1])
        text(.05,.11+.85,sprintf('c %0.2f',output.tc_mod),'units','normalized','Color',[0 .5 1],'Fontsize',16)
        
        
        % Make trial Raster to running and contra touch
        subtightplot(num_plots_h,num_plots_w,[1 2],gap,marg_h,marg_w)
        %plot_spk_raster(fig_props,RASTER,[],[],[])
        plot_spk_raster_col([],output.RASTER,[],[],output.raster_mat_full);
        set(gca,'xticklabel',[])
        xlabel('')
        text(1,.11+.85,sprintf('%0.2f',output.r2),'units','normalized','Color',[0 .5 0],'Fontsize',18)
        str = boundary_labels{ps.layer_id_FINAL(ih)+1};
        text(1,.11+.73,sprintf('%s',str),'units','normalized','Color',[0 .5 0],'Fontsize',18)
        text(1,.11+.61,sprintf('%g',ih),'units','normalized','Color',[0 .5 0],'Fontsize',18)
         text(1,.11+.49,sprintf('%.0f',ps.layer_4_dist_FINAL(ih)),'units','normalized','Color',[0 .5 0],'Fontsize',18)

  
       text(0,.11+.85,sprintf('%s',num2str(anm_num)),'units','normalized','Color',[0 .5 0],'Fontsize',14,'backgroundcolor',[1 1 1])
       text(0,.11+.73,sprintf('C %g',ps.clean_clusters(ih)),'units','normalized','Color',[0 .5 0],'Fontsize',14,'backgroundcolor',[1 1 1])
  

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
    end
end