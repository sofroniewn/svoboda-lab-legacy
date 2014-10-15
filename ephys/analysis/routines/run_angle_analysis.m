function run_angle_analysis(ps,all_anm,anm_num,fig_num)

figure(fig_num)
clf(fig_num)
set(gcf,'Position',[24   220   670   586])
subplot(2,2,1)
hold on
plot([0 30],[-100 -100],'linewidth',2,'color','k')
plot([0 30],[0 0],'linewidth',2,'color','k')
ylim([-150 100])

subplot(2,2,3)
hold on
plot([0 30],[-15 -15],'linewidth',2,'color','k')
plot([0 30],[0 0],'linewidth',2,'color','k')
ylim([-20 20])

diff_val_close = [];
diff_val_far = [];
diff_val_all = [];

if isempty(anm_num)
    anm_range = 1:numel(all_anm);
else
    anm_range = anm_num;
end

for anm_num = anm_range
anm_id = num2str(all_anm{anm_num}.d.p_nj(1,1)); 
[base_dir run_thresh trial_range_start trial_range_end exp_type layer_4 boundaries boundary_labels] = ephys_anm_id_database(anm_id,0);
boundaries(isnan(boundaries)) = -Inf;


	d = all_anm{anm_num}.d;

stim_name = 'corPos';
keep_name = 'ol_running';
id_type = 'olR';
 
%    function tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);

run_thresh = 5;

trial_range = [min(trial_range_start):min(max(trial_range_end),4000)];

constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);


time_range = [0 3];
time_range_inds = floor([d.samp_rate*time_range(1):d.samp_rate*time_range(2)])+1;
time_range_inds(time_range_inds>size(d.r_ntk,2)) = [];


p_vals = ps.anm_id == all_anm{anm_num}.d.p_nj(1,1);
keep_spikes = ps.spike_tau > 500 & ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & ps.SNR > 2.5;

inc_clusters = ps.mod_up(p_vals) > .5 & ps.touch_max_loc(p_vals) < 10 & keep_spikes(p_vals); % & ps.layer_4_dist(p_vals) < 65;

inc_clusters = keep_spikes(p_vals);%  & ps.layer_4_dist(p_vals) < -70;
inc_clusters = [false;false;inc_clusters];
 inc_clusters = true(length(inc_clusters),1);
 %inc_clusters(1) = true;

if sum(inc_clusters) > 0
responseVar = d.r_ntk(inc_clusters,time_range_inds,keep_trials);

pop_fr = squeeze(mean(responseVar,1));
pop_fr = squeeze(mean(pop_fr,1))*d.samp_rate;
assignin('base','pop_fr',pop_fr)

u_ind = find(strcmp(d.u_labels,'run_angle'));
run_angles = d.u_ck(u_ind,keep_trials);

u_ind = find(strcmp(d.u_labels,'wall_dist'));
wall_pos = d.u_ck(u_ind,keep_trials);
%pop_fr = run_angles;

[wall_vals b inds] = unique(wall_pos);
vals = accumarray(inds,pop_fr,[length(wall_vals) 1],@mean);
comp_vec = vals(inds);
marker = pop_fr > comp_vec';

subplot(2,2,1)
hold on

%run_angles = pop_fr;

high_curve = accumarray(inds(marker),run_angles(marker),[length(wall_vals) 1],@mean,nan);
low_curve = accumarray(inds(~marker),run_angles(~marker),[length(wall_vals) 1],@mean,nan);
all_curve = accumarray(inds,run_angles,[length(wall_vals) 1],@mean,nan);

% high_curve = smooth(high_curve,5,'sgolay',1);
% low_curve = smooth(low_curve,5,'sgolay',1);
% all_curve = smooth(all_curve,5,'sgolay',1);

offset_val = nanmean(all_curve(wall_vals>22));
%scatter(wall_pos,run_angles,[],pop_fr,'fill')
 plot(wall_pos(marker),run_angles(marker) - offset_val,'.r')
 plot(wall_pos(~marker),run_angles(~marker)- offset_val,'.b')
 plot(wall_vals,high_curve - offset_val,'linewidth',2,'color','r')
 plot(wall_vals,low_curve - offset_val,'linewidth',2,'color','b')
 plot(wall_vals,all_curve - offset_val,'linewidth',2,'color','k')

 plot(wall_vals,high_curve - low_curve - 100,'linewidth',2,'color','g')

xlabel('Wall distance (mm)')
ylabel('Run angle (deg)')
%plot3(wall_pos,run_angles,pop_fr,'.k')
%scatter3(wall_pos,run_angles,pop_fr,[],pop_fr,'fill')


diff_vals = high_curve - low_curve;

diff_val_close = [diff_val_close;nanmean(diff_vals(wall_vals<15))];
%diff_val_far = [diff_val_far;nanmean(diff_vals(wall_vals>22))];
diff_val_all = [diff_val_all;nanmean(diff_vals)];

diff_val_far = [diff_val_far;mean(run_angles(marker)) - mean(run_angles(~marker))];

subplot(2,2,2)
hold on

vals = accumarray(inds,pop_fr,[length(wall_vals) 1],@mean);
comp_vec = vals(inds);

norm_fr = pop_fr - comp_vec';

plot(run_angles(wall_pos<222)-offset_val,norm_fr(wall_pos<222),'.k')
xlabel('Run angle (deg)')
ylabel('Firing rate (Hz)')

[wall_vals b inds] = unique(wall_pos);
vals = accumarray(inds,run_angles,[length(wall_vals) 1],@mean);
comp_vec = vals(inds);
marker = run_angles > comp_vec';

subplot(2,2,3)
hold on

%run_angles = pop_fr;

 high_curve = accumarray(inds(marker),pop_fr(marker),[length(wall_vals) 1],@mean,nan);
 low_curve = accumarray(inds(~marker),pop_fr(~marker),[length(wall_vals) 1],@mean,nan);
 all_curve = accumarray(inds,pop_fr,[length(wall_vals) 1],@mean,nan);

% high_curve = smooth(high_curve,5,'sgolay',1);
% low_curve = smooth(low_curve,5,'sgolay',1);
% all_curve = smooth(all_curve,5,'sgolay',1);

offset_val = nanmean(all_curve(wall_vals>22));
%scatter(wall_pos,run_angles,[],pop_fr,'fill')
 plot(wall_pos(marker),pop_fr(marker) - offset_val,'.r')
 plot(wall_pos(~marker),pop_fr(~marker)- offset_val,'.b')
 plot(wall_vals,high_curve - offset_val,'linewidth',2,'color','r')
 plot(wall_vals,low_curve - offset_val,'linewidth',2,'color','b')
 plot(wall_vals,all_curve - offset_val,'linewidth',2,'color','k')

 plot(wall_vals,high_curve - low_curve - 15,'linewidth',2,'color','g')

xlabel('Wall distance (mm)')
ylabel('Firing rate (Hz)')

subplot(2,2,4)
hold on
plot([-10 30],[-10 30],'linewidth',2,'color','c')
plot(low_curve - offset_val,high_curve - offset_val,'.k')
xlim([-10 30])
ylim([-10 30])

%scatter3(run_angles,norm_fr,wall_pos,[],wall_pos,'fill')


% offset_val = 0; %nanmean(all_curve(wall_vals>22));
% %scatter(wall_pos,pop_fr,[],pop_fr,'fill')
% plot(wall_pos(marker),pop_fr(marker) - offset_val,'.r')
% plot(wall_pos(~marker),pop_fr(~marker)- offset_val,'.b')
% plot(wall_vals,high_curve - offset_val,'linewidth',2,'color','r')
% plot(wall_vals,low_curve - offset_val,'linewidth',2,'color','b')
% plot(wall_vals,all_curve - offset_val,'linewidth',2,'color','k')

% plot(wall_vals,high_curve - low_curve - 10,'linewidth',2,'color','g')


else
    sprintf('ignore')
    anm_num
end

end

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

subplot(2,2,1)
hold on
plot([0 30],[-100 -100],'linewidth',2,'color','k')
plot([0 30],[0 0],'linewidth',2,'color','c')
ylim([-150 100])

subplot(2,2,2)
hold on
plot([-200 200],[0 0],'linewidth',2,'color','c')
plot([0 0],[-25 25],'linewidth',2,'color','c')
ylim([-25 25])
xlim([-200 200])

subplot(2,2,3)
hold on
plot([0 30],[-15 -15],'linewidth',2,'color','k')
plot([0 30],[0 0],'linewidth',2,'color','c')
ylim([-20 20])

diff_val_close
diff_val_far
diff_val_all