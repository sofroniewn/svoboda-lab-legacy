function [vals stds N] = weighted_hist(x,y,edges)

[bincounts inds] = histc(x,edges);
vals = accumarray(inds,y,[length(edges) 1],@mean);
stds = accumarray(inds,y,[length(edges) 1],@var);
stds = sqrt(stds);
N = bincounts;




