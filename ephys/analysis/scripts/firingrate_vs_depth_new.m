function firingrate_vs_depth_new(x,y,edges)


    [vals stds N] = weighted_hist(x,y,edges);

figure
hold on
h = bar(edges+mean(diff(edges))/2,vals);
%h = bar(edges+mean(diff(edges))/2,N);

%    h = bar(edges,N);
    set(h,'FaceColor','b')
    set(h,'EdgeColor','b')


% sum(n_mat(:,1))

%   figure(34)
%   clf(34)
%   h = bar(edges,n_mat(:,1));
%   set(h,'FaceColor','k')
%   set(h,'EdgeColor','k')
%   xlim([-600 600])





