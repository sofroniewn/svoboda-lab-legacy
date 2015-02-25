function plot_clusters_tuning_paper_opto(all_anm,ps,order,plot_on,rasters)

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
        set(gcf,'Position',[436   601   174   205])
        fig_props = [];
        plot_tuning_curve_ephys_col(fig_props,output.tuning_curve)
        set(gca,'TickDir','out')

        figure(1110+ikk)
        clf(1110+ikk)
        set(gcf,'Position',[9   603   403   203])
        %plot_spk_raster(fig_props,RASTER,[],[],[])
        plot_spk_raster_col([],output.RASTER,[],[],output.raster_mat_full);
        set(gca,'xticklabel',[])
        xlabel('')
        text(1,.11+.85,sprintf('%.0f',ps.layer_4_dist_FINAL(ih)),'units','normalized','Color',[0 .5 0],'Fontsize',18)
        str = boundary_labels{ps.layer_id_FINAL(ih)+1};
        text(1,.11+.73,sprintf('%s',str),'units','normalized','Color',[0 .5 0],'Fontsize',18)
       text(1,.11+.61,sprintf('%g',ih),'units','normalized','Color',[0 .5 0],'Fontsize',18)
  
       text(-0.16,.11+.85,sprintf('%s',num2str(anm_num)),'units','normalized','Color',[0 .5 0],'Fontsize',14)
       text(-0.16,.11+.73,sprintf('C %g',ps.clean_clusters(ih)),'units','normalized','Color',[0 .5 0],'Fontsize',14)
  
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