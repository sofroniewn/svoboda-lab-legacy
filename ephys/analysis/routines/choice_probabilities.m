function choice_prob_all = choice_probabilities(ps,all_anm,anm_num,clust_num_input,fig_num)

figure(fig_num)
clf(fig_num)
set(gcf,'Position',[24   220   670   586])
subplot(2,2,1)
hold on
plot([0 30],[0 0],'linewidth',2,'color','k')
choice_prob_all = [];
% subplot(2,2,3)
% hold on
% plot([0 30],[-15 -15],'linewidth',2,'color','k')
% plot([0 30],[0 0],'linewidth',2,'color','k')
% ylim([-20 20])

diff_val_close = [];
diff_val_far = [];
diff_val_all = [];

if isempty(anm_num)
    anm_range = 1:numel(all_anm);
else
    anm_range = anm_num;
end

for anm_num = anm_range
    anm_id = num2str(all_anm{anm_num}.d.p_nj(1,1))
 [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
    run_thresh = anm_params.run_thresh;
    trial_range_start = anm_params.trial_range_start;
    trial_range_end = anm_params.trial_range_end;
    cell_reject = anm_params.cell_reject;
    exp_type = anm_params.exp_type;
    layer_4_CSD = anm_params.layer_4;
    boundaries = anm_params.boundaries;
    boundary_labels = anm_params.boundary_labels;
    layer_4_corr = anm_params.layer_4_corr;
    AP = anm_params.AP;
    ML = anm_params.ML;
    barrel_loc = anm_params.barrel_loc;
    boundaries(isnan(boundaries)) = -Inf;
    
    
    d = all_anm{anm_num}.d;
    
    stim_name = 'corPos';
    keep_name = 'ol_running';
    id_type = 'olR';
    
    %    function tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
    
    run_thresh = run_thresh/2;
    
    trial_range = [min(trial_range_start):min(max(trial_range_end),4000)];
    
    constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
    keep_trials = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
    
    
    time_range = [0 4];
    time_range_inds = floor([d.samp_rate*time_range(1):d.samp_rate*time_range(2)])+1;
    time_range_inds(time_range_inds>size(d.r_ntk,2)) = [];
    
    if isempty(clust_num_input)
        clust_range = 1:numel(d.summarized_cluster);
    else
        clust_range = clust_num_input;
    end
    
    for clust_num = clust_range
        
        %p_vals = ps.anm_id == all_anm{anm_num}.d.p_nj(1,1);
        %keep_spikes = ps.spike_tau > 500 & ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & ps.SNR > 2.5;
        %inc_clusters = ps.mod_up(p_vals) > .5 & ps.touch_max_loc(p_vals) < 10 & keep_spikes(p_vals); % & ps.layer_4_dist(p_vals) < 65;
        %inc_clusters = keep_spikes(p_vals);%  & ps.layer_4_dist(p_vals) < -70;
        %inc_clusters = [false;false;inc_clusters];
        %inc_clusters = true(length(inc_clusters),1);
        %inc_clusters(1) = true;
        
        responseVar = d.r_ntk(clust_num+2,time_range_inds,keep_trials);
       
        % get variables
        pop_fr = squeeze(mean(responseVar,1));
        pop_fr = squeeze(sum(pop_fr,1))/diff(time_range);
        
        u_ind = find(strcmp(d.u_labels,'run_angle'));
        run_angles = d.u_ck(u_ind,keep_trials);
    
        u_ind = find(strcmp(d.u_labels,'mean_speed'));
        speed = d.u_ck(u_ind,keep_trials);
    
        u_ind = find(strcmp(d.u_labels,'wall_dist'));
        wall_pos = d.u_ck(u_ind,keep_trials);
        
    num_trials = length(wall_pos)


        
        % zscore firing rate as a fn of wall position
        [wall_vals b inds] = unique(wall_pos);
        vals = accumarray(inds,pop_fr,[length(wall_vals) 1],@mean,nan);
        mean_fr = vals(inds);
        vals = accumarray(inds,pop_fr,[length(wall_vals) 1],@std,nan);
        std_fr = vals(inds);
        norm_fr = (pop_fr-mean_fr')./std_fr';
       %norm_fr = pop_fr;
        % norm_fr = norm_fr + randn(1,length(norm_fr))/10;
        % split run angle as a fn of wall position
        [wall_vals b inds] = unique(wall_pos);
        vals = accumarray(inds,run_angles,[length(wall_vals) 1],@median);
        mean_run_angle = vals(inds);
        high_run = run_angles>mean_run_angle';
        
        subplot(2,2,1)
        hold on
        
        %run_angles = pop_fr;
        
        high_curve = accumarray(inds(high_run),norm_fr(high_run),[length(wall_vals) 1],@mean,nan);
        low_curve = accumarray(inds(~high_run),norm_fr(~high_run),[length(wall_vals) 1],@mean,nan);

        choice_prob = zeros(length(wall_vals),1);        
        for ij = 1:length(wall_vals)
            high_vals = norm_fr(wall_vals(ij) == wall_pos & high_run&~isnan(norm_fr));
            low_vals = norm_fr(wall_vals(ij) == wall_pos  & ~high_run&~isnan(norm_fr));
            try
            S = mwwtest(high_vals,low_vals);
            choice_prob(ij) = S.U/length(high_vals)/length(low_vals);
            catch
             choice_prob(ij) = NaN;
            end
        end
        
            high_vals = norm_fr(wall_pos>=20 & high_run&~isnan(norm_fr));
            low_vals = norm_fr(wall_pos>=20 & ~high_run&~isnan(norm_fr));
            try
            S = mwwtest(high_vals,low_vals);
            choice_prob_far3 = S.U/length(high_vals)/length(low_vals);
            catch
             choice_prob_far3 = NaN;
            end


choice_prob_far = nanmean(choice_prob(wall_vals>=20));

    fr_out = pop_fr(wall_pos >= 20);
    ra_out = run_angles(wall_pos >= 20);
    fr_out = zscore(fr_out);
    ra_out = ra_out - median(ra_out);
    high_vals = fr_out(ra_out > 0);
    low_vals = fr_out(ra_out < 0);
    % num_trials = length(fr_out)

             if length(high_vals) > 1 && length(low_vals) > 1
                 S = mwwtest(high_vals,low_vals);
                 choice_prob_far2 = S.U/length(high_vals)/length(low_vals);
             else
                 choice_prob_far2 = NaN;
             end
            
        choice_prob_all = [choice_prob_all;[choice_prob_far choice_prob_far2 choice_prob_far3]];
        
        subplot(2,2,3)
        hold on
        plot(fr_out,ra_out,'.k')


    subplot(2,2,1)
        hold on

        offset_val = 0;
        %scatter(wall_pos,run_angles,[],pop_fr,'fill')
       % plot(wall_pos(high_run),norm_fr(high_run),'.r')
       % plot(wall_pos(~high_run),norm_fr(~high_run),'.b')
        plot(wall_vals,high_curve - offset_val,'linewidth',2,'color','r')
       % plot(wall_vals,low_curve - offset_val,'linewidth',2,'color','b')
        
        % plot(wall_vals,high_curve - low_curve - 100,'linewidth',2,'color','g')
        
        xlabel('Wall distance (mm)')
        ylabel('Firing rate (Hz)')
        %plot3(wall_pos,run_angles,pop_fr,'.k')
        %scatter3(wall_pos,run_angles,pop_fr,[],pop_fr,'fill')
        
        
        % diff_vals = high_curve - low_curve;
        
        % diff_val_close = [diff_val_close;nanmean(diff_vals(wall_vals<15))];
        % %diff_val_far = [diff_val_far;nanmean(diff_vals(wall_vals>22))];
        % diff_val_all = [diff_val_all;nanmean(diff_vals)];
        
        % diff_val_far = [diff_val_far;mean(run_angles(marker)) - mean(run_angles(~marker))];
        
         subplot(2,2,2)
         hold on
         plot(wall_vals,choice_prob,'linewidth',2,'color','k')

        % vals = accumarray(inds,pop_fr,[length(wall_vals) 1],@mean);
        % comp_vec = vals(inds);
        
        % norm_fr = pop_fr - comp_vec';
        
        % plot(run_angles(wall_pos<222)-offset_val,norm_fr(wall_pos<222),'.k')
        % xlabel('Run angle (deg)')
        % ylabel('Firing rate (Hz)')
        
        % [wall_vals b inds] = unique(wall_pos);
        % vals = accumarray(inds,run_angles,[length(wall_vals) 1],@mean);
        % comp_vec = vals(inds);
        % marker = run_angles > comp_vec';
        
        % subplot(2,2,3)
        % hold on
        
        % %run_angles = pop_fr;
        
        %  high_curve = accumarray(inds(marker),pop_fr(marker),[length(wall_vals) 1],@mean,nan);
        %  low_curve = accumarray(inds(~marker),pop_fr(~marker),[length(wall_vals) 1],@mean,nan);
        %  all_curve = accumarray(inds,pop_fr,[length(wall_vals) 1],@mean,nan);
        
        % % high_curve = smooth(high_curve,5,'sgolay',1);
        % % low_curve = smooth(low_curve,5,'sgolay',1);
        % % all_curve = smooth(all_curve,5,'sgolay',1);
        
        % offset_val = nanmean(all_curve(wall_vals>22));
        % %scatter(wall_pos,run_angles,[],pop_fr,'fill')
        %  plot(wall_pos(marker),pop_fr(marker) - offset_val,'.r')
        %  plot(wall_pos(~marker),pop_fr(~marker)- offset_val,'.b')
        %  plot(wall_vals,high_curve - offset_val,'linewidth',2,'color','r')
        %  plot(wall_vals,low_curve - offset_val,'linewidth',2,'color','b')
        %  plot(wall_vals,all_curve - offset_val,'linewidth',2,'color','k')
        
        %  plot(wall_vals,high_curve - low_curve - 15,'linewidth',2,'color','g')
        
        % xlabel('Wall distance (mm)')
        % ylabel('Firing rate (Hz)')
        
        % subplot(2,2,4)
        % hold on
        % plot([-10 30],[-10 30],'linewidth',2,'color','c')
        % plot(low_curve - offset_val,high_curve - offset_val,'.k')
        % xlim([-10 30])
        % ylim([-10 30])
        
        % %scatter3(run_angles,norm_fr,wall_pos,[],wall_pos,'fill')
        
        
        % % offset_val = 0; %nanmean(all_curve(wall_vals>22));
        % % %scatter(wall_pos,pop_fr,[],pop_fr,'fill')
        % % plot(wall_pos(marker),pop_fr(marker) - offset_val,'.r')
        % % plot(wall_pos(~marker),pop_fr(~marker)- offset_val,'.b')
        % % plot(wall_vals,high_curve - offset_val,'linewidth',2,'color','r')
        % % plot(wall_vals,low_curve - offset_val,'linewidth',2,'color','b')
        % % plot(wall_vals,all_curve - offset_val,'linewidth',2,'color','k')
        
        % % plot(wall_vals,high_curve - low_curve - 10,'linewidth',2,'color','g')
        
    end
end

        nanmean(choice_prob_all)
        nanstd(choice_prob_all) 
choice_prob_all(isnan(choice_prob_all)) = 0.5;

% edges = [-3:.1:3];
% aa_raw = randn(100,1)+2.2;
% aa = hist(aa,edges);
% ac = cumsum(aa)/sum(aa);
% bb_raw = randn(100,1);
% bb = hist(bb,edges);
% bc = cumsum(bb)/sum(bb);

% S = mwwtest(aa_raw,bb_raw);
% S.U/length(aa_raw)/length(bb_raw)

% p = ranksum(aa_raw,bb_raw)
subplot(2,2,1)
hold on
plot([0 30],[0 0],'linewidth',2,'color','k')

 subplot(2,2,2)
hold on
plot([0 30],[0.5 .5],'linewidth',2,'color','c')
        
     
% figure;
% hold on
% %plot(aa-bb,'r')
% %sum(bb-aa)/length(aa)
% plot(aa,bb,'.k')
%
% figure;
% hold on
% plot(1-aa,'r')
% plot(bb,'k')

 subplot(2,2,4)
 hist(choice_prob_all,[0:.05:1])
% hold on
% plot([0 30],[-100 -100],'linewidth',2,'color','k')
% plot([0 30],[0 0],'linewidth',2,'color','c')
% ylim([-150 100])
% 
% subplot(2,2,2)
% hold on
% plot([-200 200],[0 0],'linewidth',2,'color','c')
% plot([0 0],[-25 25],'linewidth',2,'color','c')
% ylim([-25 25])
% xlim([-200 200])
% 
% subplot(2,2,3)
% hold on
% plot([0 30],[-15 -15],'linewidth',2,'color','k')
% plot([0 30],[0 0],'linewidth',2,'color','c')
% ylim([-20 20])
% 
% diff_val_close
% diff_val_far
% diff_val_all

