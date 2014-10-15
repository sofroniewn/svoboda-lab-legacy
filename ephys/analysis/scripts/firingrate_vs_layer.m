function firingrate_vs_layer(ps,y_mat,keep_mat,comb)

keep_spikes_all = ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spike_tau > 500 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & ps.SNR > 2.5;

edges = unique(ps.layer_id);
vals_mat = zeros(length(edges),size(y_mat,2));
n_mat = zeros(length(edges),size(y_mat,2));
for ij = 1:size(y_mat,2)
    if ~isempty(keep_mat)
        keep_spikes = keep_spikes_all & keep_mat(:,ij);
    else
        keep_spikes = keep_spikes_all;
    end
    x = ps.layer_id(keep_spikes);
    if size(y_mat,1) == size(ps.layer_id,1)
        y = y_mat(keep_spikes,ij);
    else
        y = y_mat(:,ij);
    end
    xx{ij} = x;
    yy{ij} = y;
    vals = weighted_hist(x,y,edges);
    vals_mat(:,ij) = vals;
    n = histc(x,edges);
    n_mat(:,ij) = n;
end

figure
hold on
if ~comb & size(y_mat,2) == 2
    h = bar(edges,vals_mat(:,1));
    set(h,'FaceColor','b')
    set(h,'EdgeColor','b')
    h = bar(edges,-vals_mat(:,2));
    set(h,'FaceColor','r')
    set(h,'EdgeColor','r')
else
    cmap = colormap(lines(size(y_mat,2)));
    h = bar(edges,vals_mat);
    for ij = 1:size(y_mat,2)
        set(h(ij),'FaceColor',cmap(ij,:))
        set(h(ij),'EdgeColor',cmap(ij,:))
    end
    plot(xx{ij},yy{ij},'.k')
end

xlim([1 7])
set(gca,'xtick',[2:6])
set(gca,'xticklabel',{'L2/3', 'L4', 'L5a', 'L5b', 'L6'})

% sum(n_mat(:,1))

%   figure(34)
%   clf(34)
%   h = bar(edges,n_mat(:,1));
%   set(h,'FaceColor','k')
%   set(h,'EdgeColor','k')
% xlim([1 7])
% set(gca,'xtick',[2:6])
% set(gca,'xticklabel',{'L2/3', 'L4', 'L5a', 'L5b', 'L6'})





