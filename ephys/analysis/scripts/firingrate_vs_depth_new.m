function firingrate_vs_depth_new(x,y,edges)


    [vals stds N] = weighted_hist(x,y,edges);


h = barh(edges+mean(diff(edges))/2,vals);
%h = bar(edges+mean(diff(edges))/2,N);

%    h = bar(edges,N);
    set(h,'FaceColor',[.5 .5 1])
    set(h,'EdgeColor',[.5 .5 1])
    set(h,'LineWidth',2)


% sum(n_mat(:,1))

%   figure(34)
%   clf(34)
%   h = bar(edges,n_mat(:,1));
%   set(h,'FaceColor','k')
%   set(h,'EdgeColor','k')
%   xlim([-600 600])





