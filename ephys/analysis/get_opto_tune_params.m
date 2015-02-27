function [ps rasters_opto] = get_opto_tune_params(all_anm,ps,order,rasters);

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
    if ps.opto_anm(ih)
    output_opto = summarize_tuning_sig_opto(d,clust_num);        
    rasters_opto{ikk} = output_opto;

      ps.opto_tc_mod(ikk) = output_opto.tc_mod;
      ps.opto_act(ikk) = output_opto.act;
      ps.opto_sup(ikk) = output_opto.sup;
      ps.opto_tc_peak(ikk) = output_opto.baseline + output_opto.act;
      ps.opto_tc_baseline(ikk) = output_opto.baseline;
      ps.opto_r2(ikk) = output_opto.r2;
    else
      rasters_opto{ikk} = [];
      ps.opto_tc_mod(ikk) = 0;
      ps.opto_act(ikk) = 0;
      ps.opto_sup(ikk) = 0;
      ps.opto_tc_peak(ikk) = 0;
      ps.opto_tc_baseline(ikk) = 0;
      ps.opto_r2(ikk) = 0;
    end

    end
end