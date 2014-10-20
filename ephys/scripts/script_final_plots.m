%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% UNIT FILTERING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% WAVEFORM SNR
figure(1)
clf(1)
hold on
keep_spikes = stable_spikes & good_tuning;
edges = [0:.3:30];
n = hist(ps.waveform_SNR(keep_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
plot([6 6],[0 16],'LineWidth',2,'Color','r')
xlabel('Waveform SNR','FontSize',16)
xlim([0 30])
set(gca,'FontSize',16)


% ISI VIOLATIONS
figure(1)
clf(1)
hold on
keep_spikes = stable_spikes & good_tuning;
edges = [0:.1:6];
n = hist(ps.isi_violations(keep_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
plot([1 1],[0 90],'LineWidth',2,'Color','r')
xlabel('Percent ISI violations','FontSize',16)
xlim([0 6])
set(gca,'FontSize',16)

% LAYER ID OF RECORDINGS
keep_spikes = clean_clusters;
figure(34)
clf(34)
hold on
edges = [0:2:300];
n = histc(ps.spk_amplitude(keep_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlim([0 300])
plot([42 42],[0 10],'LineWidth',2,'Color','r')
set(gca,'FontSize',16)
xlabel('Spike amplitude (uV)','FontSize',16)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% UNIT ANATOMY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% DISTANCE FROM LAYER 4 OF RECORDINGS
keep_spikes = clean_clusters;
figure(2)
clf(2)
edges = [-600:50:600];
n = histc(ps.layer_4_dist(keep_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlabel('Distance from Layer 4 (um)','FontSize',16)
xlim([-500 500])
set(gca,'xtick',[-500:250:500])
set(gca,'FontSize',16)


% LAYER ID OF RECORDINGS
keep_spikes = clean_clusters;
figure(34)
clf(34)
edges = unique(ps.layer_id);
n = histc(ps.layer_id(keep_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlim([1 7])
set(gca,'xtick',[2:6])
set(gca,'xticklabel',{'L2/3', 'L4', 'L5a', 'L5b', 'L6'},'FontSize',16)
set(gca,'FontSize',16)


% LAYER ID OF RECORDINGS by barrel location
keep_spikes = clean_clusters;
figure(35)
clf(35)
edges = unique(ps.layer_id);
n1 = histc(ps.layer_id(keep_spikes & c1c2 ),edges);
n2 = histc(ps.layer_id(keep_spikes & ~(c1c2 | v1)),edges);
n3 = histc(ps.layer_id(keep_spikes & v1),edges);
h = bar(edges,[n1 n2 n3],'stacked');
set(h(1),'FaceColor','b')
set(h(1),'EdgeColor','b')
set(h(2),'FaceColor','g')
set(h(2),'EdgeColor','g')
set(h(3),'FaceColor','r')
set(h(3),'EdgeColor','r')
xlim([1 7])
set(gca,'xtick',[2:6])
set(gca,'xticklabel',{'L2/3', 'L4', 'L5a', 'L5b', 'L6'},'FontSize',16)
set(gca,'FontSize',16)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% UNIT WAVEFORMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Spike tau
keep_spikes = clean_clusters;
figure(1)
clf(1)
hold on
edges = [0:20:900];
n = histc(ps.spike_tau(keep_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
plot([350 350],[0 90],'LineWidth',2,'Color','m')
plot([500 500],[0 90],'LineWidth',2,'Color','m')
plot([700 700],[0 90],'LineWidth',2,'Color','m')
xlabel('Spike tau (us)','FontSize',16)
xlim([0 900])
set(gca,'FontSize',16)

% Spike tau
keep_spikes = clean_clusters;
figure(1)
clf(1)
hold on
edges = [0:20:900];
n = histc(ps.spike_tau(keep_spikes&fast_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','r')
set(h,'EdgeColor','r')
n = histc(ps.spike_tau(keep_spikes&intermediate_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
n = histc(ps.spike_tau(keep_spikes&regular_spikes_fast),edges);
h = bar(edges,n);
set(h,'FaceColor','g')
set(h,'EdgeColor','g')
n = histc(ps.spike_tau(keep_spikes&regular_spikes_slow),edges);
h = bar(edges,n);
set(h,'FaceColor','b')
set(h,'EdgeColor','b')
plot([350 350],[0 90],'LineWidth',2,'Color','m')
plot([500 500],[0 90],'LineWidth',2,'Color','m')
plot([700 700],[0 90],'LineWidth',2,'Color','m')
xlabel('Spike tau (us)','FontSize',16)
xlim([0 900])
set(gca,'FontSize',16)
set(gca,'layer','top')

% SPIKE WAVEFORMS
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
xlabel('Time (us)','FontSize',16)
ylabel('Normalized amplitude','FontSize',16)
set(gca,'FontSize',16)

% LAYER ID OF RECORDINGS by barrel location
keep_spikes = clean_clusters;
figure(35)
clf(35)
edges = unique(ps.layer_id);
n1 = histc(ps.layer_id(keep_spikes & regular_spikes_slow),edges);
n2 = histc(ps.layer_id(keep_spikes & regular_spikes_fast),edges);
n3 = histc(ps.layer_id(keep_spikes & fast_spikes),edges);
h = bar(edges,[n1 n2 n3],'stacked');
set(h(1),'FaceColor','b')
set(h(1),'EdgeColor','b')
set(h(2),'FaceColor','g')
set(h(2),'EdgeColor','g')
set(h(3),'FaceColor','r')
set(h(3),'EdgeColor','r')
xlim([1 7])
set(gca,'xtick',[2:6])
set(gca,'xticklabel',{'L2/3', 'L4', 'L5a', 'L5b', 'L6'},'FontSize',16)
set(gca,'FontSize',16)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% UNIT FIRING RATES %%%%%%%%%%%%%%%%%%%%%%%%%%%%


% NO RUN / RUN RATE across layer
y_mat = [ps.no_walls_still_rate ps.no_walls_run_rate];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & (c_row | b_row) & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Firing rate (Hz)','FontSize',16)


% NO RUN / RUN RATE across barrel
y_mat = [ps.no_walls_still_rate ps.no_walls_run_rate];
keep_mat = [];
x_labels = {'B row & C row', 'D row', 'V1'};
x_vec = barrel_id+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Firing rate (Hz)','FontSize',16)

% NO RUN / RUN MODULATION across layer
y_mat = [ps.no_walls_run_rate - ps.no_walls_still_rate]./[ps.no_walls_still_rate + ps.no_walls_run_rate];
y_mat(isinf(y_mat) | isnan(y_mat)) = 0;
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & (c_row | b_row) & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Running modulation','FontSize',16)


% NO RUN / RUN MODULATION across barrel
y_mat = [ps.no_walls_run_rate - ps.no_walls_still_rate]./[ps.no_walls_still_rate + ps.no_walls_run_rate];
y_mat(isinf(y_mat) | isnan(y_mat)) = 0;
keep_mat = [];
x_labels = {'B row & C row', 'D row', 'V1'};
x_vec = barrel_id+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Running modulation','FontSize',16)


% NO TOUCH / MEAN TOUCH RATE across layer (within 18mm)
y_mat = [ps.no_walls_run_rate ps.walls_run_rate];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & (c_row | b_row) & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Firing rate (Hz)','FontSize',16)



% NO TOUCH / MEAN TOUCH RATE across barrel (within 18mm)
y_mat = [ps.no_walls_run_rate ps.walls_run_rate];
keep_mat = [];
x_labels = {'B row & C row', 'D row', 'V1'};
x_vec = barrel_id+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Firing rate (Hz)','FontSize',16)


% NO TOUCH / MEAN TOUCH MODULATION across layer (within 18mm)
y_mat = [ps.walls_run_rate - ps.no_walls_run_rate]./[ps.walls_run_rate + ps.no_walls_run_rate];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & (c_row | b_row) & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Touch modulation','FontSize',16)



% NO TOUCH / MEAN TOUCH MODULATION across barrel (within 18mm)
y_mat = [ps.walls_run_rate - ps.no_walls_run_rate]./[ps.walls_run_rate + ps.no_walls_run_rate];
keep_mat = [];
x_labels = {'B row & C row', 'D row', 'V1'};
x_vec = barrel_id+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Touch modulation','FontSize',16)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% TUNING CURVE ANALYSIS  %%%%%%%%%%%%%%%%%%%%%%%
ps.touch_peak_rate > 2;

% TUNING MODULATION
figure(5);
clf(5)
hold on
keep_spikes = ~layer_6 & regular_spikes & clean_clusters & ps.touch_peak_rate > 2  & ps.spk_amplitude > 42;
plot([0 25],[1 1],'m','LineWidth',2)
plot([1 1],[0 25],'m','LineWidth',2)
plot(ps.mod_up(keep_spikes),ps.mod_down(keep_spikes),'.k')
xlabel('Peak - Baseline (Hz)','FontSize',16)
ylabel('Baseline - Min (Hz)','FontSize',16)
%set(gca,'yscale','log')
%set(gca,'xscale','log')
set(gca,'FontSize',16)


% LOG TUNING MODULATION
figure(5);
clf(5)
hold on
plot([-4 4],[0 0],'m','LineWidth',2)
plot([0 0],[-6 3],'m','LineWidth',2)
keep_spikes = ~layer_6 & regular_spikes & ps.spk_amplitude > 42 & clean_clusters & ps.mod_up > 1 & ps.mod_down <= 1 & ps.touch_peak_rate > 2;
plot(log(ps.mod_up(keep_spikes)),log(ps.mod_down(keep_spikes)),'.b')
keep_spikes = ~layer_6 & regular_spikes & ps.spk_amplitude > 42 & clean_clusters & ps.mod_up > 1 & ps.mod_down > 1 & ps.touch_peak_rate > 2;
plot(log(ps.mod_up(keep_spikes)),log(ps.mod_down(keep_spikes)),'.g')
keep_spikes = ~layer_6 & regular_spikes & ps.spk_amplitude > 42 & clean_clusters & ps.mod_up <= 1 & ps.mod_down > 1 & ps.touch_peak_rate > 2;
plot(log(ps.mod_up(keep_spikes)),log(ps.mod_down(keep_spikes)),'.r')
keep_spikes = ~layer_6 & regular_spikes & ps.spk_amplitude > 42 & clean_clusters & ps.mod_up <= 1 & ps.mod_down <= 1 & ps.touch_peak_rate > 2;
plot(log(ps.mod_up(keep_spikes)),log(ps.mod_down(keep_spikes)),'.k')
xlabel('Log(Peak - Baseline)','FontSize',16)
ylabel('Log(Baseline - Min)','FontSize',16)
set(gca,'FontSize',16)

mod_thresh_up = 1;
mod_thresh_down = 1;
type_on = ps.mod_up > mod_thresh & ps.mod_down <= mod_thresh_down & ps.touch_peak_rate > 2;
type_off = ps.mod_up <= mod_thresh & ps.mod_down > mod_thresh_down & ps.touch_peak_rate > 2;
type_mixed = ps.mod_up > mod_thresh & ps.mod_down > mod_thresh_down & ps.touch_peak_rate > 2;
type_untuned = ps.mod_up <= mod_thresh & ps.mod_down <= mod_thresh_down & ps.touch_peak_rate > 2;


back_thresh = 1;
mod_thresh_up = 1;
mod_thresh_down = 1;
type_on = ps.walls_run_rate <= back_thresh & ps.mod_up > mod_thresh_up;
type_off = ps.walls_run_rate >= 2.5 & ps.mod_down > mod_thresh_down & ps.mod_up <= mod_thresh_up;
type_mixed = ps.walls_run_rate >= 2.5 & ps.mod_up > mod_thresh_up;
type_untuned = ~(type_on | type_off | type_mixed);

ps.walls_run_rate

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NO RUN / RUN RATE across layer
y_mat = [type_on type_mixed type_off type_untuned];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & ps.spk_amplitude > 42 & regular_spikes & (c_row | b_row) & ps.touch_peak_rate > 2 & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Fraction','FontSize',16)
ylim([0 1])

% NO RUN / RUN RATE across layer
y_mat = [type_on (type_mixed | type_off)];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & ps.spk_amplitude > 42 & ~type_untuned & regular_spikes & (c_row | b_row) & ps.touch_peak_rate > 2 & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Fraction','FontSize',16)
ylim([0 1])



y_mat = [type_on type_mixed type_off type_untuned];
keep_mat = [];
x_labels = {'B row & C row', 'D row', 'V1'};
x_vec = barrel_id+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & ps.spk_amplitude > 42 & regular_spikes & ps.touch_peak_rate > 2 & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Fraction','FontSize',16)
ylim([0 1])


%%%
y_mat = [ps.touch_max_loc, ps.touch_max_loc, ps.touch_max_loc, ps.touch_max_loc];
keep_mat = [ps.barrel_loc==1, ps.barrel_loc==2, ps.barrel_loc==3, ps.barrel_loc==4];
y_mat = [ps.touch_max_loc];
keep_mat = [];
x_labels = {'C1', 'C2', 'C3', 'C4'};
x_vec = ps.barrel_loc+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & type_on & (c_row) & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Peak tuning (mm)','FontSize',16)

%%%%%%









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


% NO TOUCH / MEAN TOUCH MODULATION across layer (within 18mm)
y_mat = [choice_prob_all(:,1)];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & ismember(ps.barrel_loc,[1 2 5]) & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Choice probability','FontSize',16)
ylim([.4 .6])
set(gca,'ytick',[.4:.05:.6])


% NO TOUCH / MEAN TOUCH MODULATION across layer (within 18mm)
y_mat = [choice_prob_all(:,1)];
keep_mat = [];
x_labels = {'NONE','ON', 'OFF','MIXED'};
x_vec = ones(length(ps.mod_up),1);
x_vec(ps.mod_up > 1 & ps.mod_down <= 1) = 2;
x_vec(ps.mod_up <= 1 & ps.mod_down <= 1) = 3;
x_vec(ps.mod_up > 1 & ps.mod_down > 1) = 4;
x_vec = x_vec+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & ismember(ps.barrel_loc,[1 2 5]) & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Touch modulation','FontSize',16)
ylim([.4 .6])
set(gca,'ytick',[.4:.05:.6])


% NO TOUCH / MEAN TOUCH MODULATION across layer (within 18mm)
y_mat = [choice_prob_all(:,1)];
keep_mat = [];
x_labels = {'NONE','ON', 'OFF','MIXED'};
x_vec = ones(length(ps.mod_up),1);
x_vec(ps.mod_up > 1 & ps.mod_down <= 1) = 2;
x_vec(ps.mod_up <= 1 & ps.mod_down <= 1) = 3;
x_vec(ps.mod_up > 1 & ps.mod_down > 1) = 4;
x_vec = x_vec+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & (~v1) & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Touch modulation','FontSize',16)
ylim([.4 .6])


on_adapt




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NO RUN / RUN RATE across layer
y_mat = on_adapt;
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & (type_on | type_mixed) & ps.spk_amplitude > 42 & ~type_untuned & regular_spikes & (c_row | b_row) & ps.touch_peak_rate > 2 & clean_clusters,1,0)
set(gca,'FontSize',16)
ylabel('Fraction','FontSize',16)
ylim([0 1])





