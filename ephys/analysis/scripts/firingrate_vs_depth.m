function firingrate_vs_depth(p,p_labels,type)

 s_ind = find(strcmp(p_labels,'spike_tau'));
 spike_tau = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'isi_violations'));
 isi_viol = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'waveform_SNR'));
 wave_snr = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'peak_rate'));
 peak_rate = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'baseline_rate'));
 base_rate = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'running_modulation'));
 run_mod = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'isi_peak'));
 isi_peak = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'layer_4_dist'));
 layer_4_dist = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'spk_amplitude'));
 spike_amp = p(:,s_ind);
s_ind = find(strcmp(p_labels,'peak_distance'));
 peak_dist = p(:,s_ind);

switch type
case 'baseline'
	x_lim = [-600 600];
	y_lim_ex = [0 20];
	y_lim_inh = [0 35];
	dependent_var = base_rate;
	type_log = 0;
case 'peak'
	x_lim = [-600 600];
	y_lim_ex = [0 50];
	y_lim_inh = [0 100];
	dependent_var = peak_rate;
	type_log = 0;
case 'peak_isi'
	x_lim = [-600 600];
	y_lim_ex = [0 120];
	y_lim_inh = [0 120];
	dependent_var = isi_peak*1000;
	type_log = 0;
case 'tau'
	x_lim = [-600 600];
	y_lim_ex = [500 800];
	y_lim_inh = [100 350];
	dependent_var = spike_tau;
	type_log = 0;
case 'dist'
	x_lim = [-600 600];
	y_lim_ex = [0 30];
	y_lim_inh = [0 30];
	dependent_var = peak_dist;
	type_log = 0;
case 'peak_mod'
	x_lim = [-600 600];
	y_lim_ex = [-1 3];
	y_lim_inh = [-1 3];
	dependent_var = peak_rate./base_rate;
	dependent_var(isinf(dependent_var)) = 100;
	dependent_var = log(dependent_var);
	type_log = 0;
case 'run_rate'
	x_lim = [-600 600];
	y_lim_ex = [0 30];
	y_lim_inh = [0 60];
	dependent_var = base_rate.*run_mod;
	dependent_var(isinf(dependent_var)) = 0;
	dependent_var(isnan(dependent_var)) = 0;
	type_log = 0;
case 'run_mod'
	x_lim = [-600 600];
	y_lim_ex = [-2 2];
	y_lim_inh = [-2 2];
	dependent_var = run_mod;
	dependent_var(isinf(dependent_var)) = 100;
	dependent_var(isnan(dependent_var)) = 0;
	dependent_var = log(dependent_var);
	type_log = 0;
case 'extra'
	chan = 17;
	x_lim = [-600 600];
	y_lim_ex = [-5 5];
	y_lim_inh = [-5 5];
	dependent_var = p(:,chan);
	type_log = 0;
case 'extra2'
	chan = 18;
	x_lim = [-600 600];
	y_lim_ex = [0 30];
	y_lim_inh = [0 30];
	dependent_var = p(:,chan);
	type_log = 0;
otherwise
	error('could not match type')
end

keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60;


figure(2)
clf(2)
set(gcf,'position',[74         520        1316         278])
subplot(1,2,1)
hold on
x_range = diff(x_lim);
y_range = diff(y_lim_ex);
cur_pos = get(gca,'Position');
scale = y_range/x_range*cur_pos(4)/cur_pos(3);

spike_rate = dependent_var(keep_spikes & spike_tau > 500);
depth = p(keep_spikes & spike_tau > 500,4);
edges= [-575:50:575];
[bincounts inds] = histc(depth,edges);
vals = accumarray(inds,spike_rate,[length(edges) 1],@mean);
h = bar(edges,vals);
set(h,'FaceColor','b')
set(h,'EdgeColor','b')

if type_log
	h = plot(depth,spike_rate,'.k');
	set(h,'MarkerEdgeColor', [0.5 0.5 0.5]);
else
	h = transparentScatter(depth,spike_rate,5,scale,0.5,[0 0 0]);
end

xlim(x_lim)
ylim(y_lim_ex)
if type_log
  set(gca,'yscale','log')
end



subplot(1,2,2)
hold on
x_range = diff(x_lim);
y_range = diff(y_lim_inh);
cur_pos = get(gca,'Position');
scale = y_range/x_range*cur_pos(4)/cur_pos(3);

spike_rate = dependent_var(keep_spikes & spike_tau < 350);
depth = p(keep_spikes & spike_tau < 350 ,4);
edges= [-550:100:550];
[bincounts inds] = histc(depth,edges);
vals = accumarray(inds,spike_rate,[length(edges) 1],@mean);
h = bar(edges,vals);
set(h,'FaceColor','r')
set(h,'EdgeColor','r')

if type_log
	h = plot(depth,spike_rate,'.k');
	set(h,'MarkerEdgeColor', [0.5 0.5 0.5]);
else
	h = transparentScatter(depth,spike_rate,5,scale,0.5,[0 0 0]);
end

xlim(x_lim)
ylim(y_lim_inh)
if type_log
  set(gca,'yscale','log')
end





