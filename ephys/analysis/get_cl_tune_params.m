function [ps rasters_cl] = get_cl_tune_params(all_anm,ps,order,rasters);

boundary_labels = {'Pia', 'L1', 'L2/3', 'L4', 'L5A', 'L5B', 'L6'};
barrel_inds = {'C1','C2','C3','C4','D1','D2','B1','V1'};

for ikk = 1:size(order,1)
    [ikk size(order,1)]
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


    output_real = rasters{ih};
    if ps.cl_anm(ih)
    output_cl = summarize_tuning_sig_cl(d,clust_num);        
    rasters_cl{ikk} = output_cl;

      ps.cl_tc_mod(ikk) = output_cl.tc_mod;
      ps.cl_act(ikk) = output_cl.act;
      ps.cl_sup(ikk) = output_cl.sup;
      ps.cl_tc_peak(ikk) = output_cl.baseline + output_cl.act;
      ps.cl_tc_baseline(ikk) = output_cl.baseline;
      ps.cl_r2(ikk) = output_cl.r2;
    else
      rasters_cl{ikk} = [];
      ps.cl_tc_mod(ikk) = 0;
      ps.cl_act(ikk) = 0;
      ps.cl_sup(ikk) = 0;
      ps.cl_tc_peak(ikk) = 0;
      ps.cl_tc_baseline(ikk) = 0;
      ps.cl_r2(ikk) = 0;
    end

    end
end