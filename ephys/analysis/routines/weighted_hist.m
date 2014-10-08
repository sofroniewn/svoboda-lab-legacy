function vals = weighted_hist(x,y,edges)

[bincounts inds] = histc(x,edges);
vals = accumarray(inds,y,[length(edges) 1],@mean);





