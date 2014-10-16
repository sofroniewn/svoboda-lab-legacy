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
























