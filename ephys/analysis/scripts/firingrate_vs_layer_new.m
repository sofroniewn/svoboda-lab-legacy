function firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,keep_spikes_all,comb,hist_plot)

edges = unique(x_vec);
vals_mat = zeros(length(edges),size(y_mat,2));
std_mat = zeros(length(edges),size(y_mat,2));
n_mat = zeros(length(edges),size(y_mat,2));
for ij = 1:size(y_mat,2)
    if ~isempty(keep_mat)
        keep_spikes = keep_spikes_all & keep_mat(:,ij);
    else
        keep_spikes = keep_spikes_all;
    end
    x = x_vec(keep_spikes);
    if size(y_mat,1) == size(x_vec,1)
        y = y_mat(keep_spikes,ij);
    else
        y = y_mat(:,ij);
    end
    xx{ij} = x;
    yy{ij} = y;
    [vals stds N] = weighted_hist(x,y,edges);
    vals_mat(:,ij) = vals;
    std_mat(:,ij) = stds;
    n = histc(x,edges);
    n_mat(:,ij) = n;
end

if hist_plot
    vals_mat = n_mat;
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
    %cmap = [0 0 .8;.8 0 0];
    h = bar(edges,vals_mat);
    for ij = 1:size(y_mat,2)
        set(h(ij),'FaceColor',cmap(ij,:))
        set(h(ij),'EdgeColor',cmap(ij,:))
        hj = get(h(ij),'children');
        xdat = get(hj,'XData');
        for ik = 1:size(xdat,2)
            x_val(ij,ik) = (xdat(1,ik) + xdat(3,ik))/2;
            y_val = vals_mat(ik,ij) + [-std_mat(ik,ij) std_mat(ik,ij)]/sqrt(n_mat(ik,ij));
            plot([x_val(ij,ik) x_val(ij,ik)],y_val,'LineWidth',2,'Color','k')
            plot(x_val(ij,ik),yy{ij}(xx{ij}==edges(ik)),'LineStyle','none','MarkerEdgeColor',[.3 .3 .3],'Marker','.','MarkerSize',20)
        end
    end

    for ik = 1:size(xdat,2)
        y_val = [];
         for ij = 1:size(y_mat,2)
            y_val = [y_val yy{ij}(xx{ij}==edges(ik))];
         end
         x_val_line = repmat(x_val(:,ik)',size(y_val,1),1);
      %   plot(x_val_line',y_val','LineWidth',2,'Color',2*[.3 .3 .3])
    end

    if ~hist_plot
%        plot(xx{ij}+.3*(ij-size(y_mat,2)/2)/size(y_mat,2),yy{ij},'.k')
    end
end

xlim([1 numel(x_labels)+2])
set(gca,'xtick',[2:numel(x_labels)+1])
set(gca,'xticklabel',x_labels)


set(gca,'layer','top')
% sum(n_mat(:,1))

%   figure(34)
%   clf(34)
%   h = bar(edges,n_mat(:,1));
%   set(h,'FaceColor','k')
%   set(h,'EdgeColor','k')
% xlim([1 7])
% set(gca,'xtick',[2:6])
% set(gca,'xticklabel',{'L2/3', 'L4', 'L5a', 'L5b', 'L6'})





