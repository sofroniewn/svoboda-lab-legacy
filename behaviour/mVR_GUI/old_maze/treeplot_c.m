function treeplot(p,c,d)
%TREEPLOT Plot picture of tree.
%   TREEPLOT(p) plots a picture of a tree given a row vector of
%   parent pointers, with p(i) == 0 for a root. 
%
%   TREEPLOT(P,nodeSpec,edgeSpec) allows optional parameters nodeSpec
%   and edgeSpec to set the node or edge color, marker, and linestyle.
%   Use '' to omit one or both.
%
%   Example:
%      treeplot([2 4 2 0 6 4 6])
%   returns a complete binary tree.
%
%   See also ETREE, TREELAYOUT, ETREEPLOT.

%   Copyright 1984-2009 The MathWorks, Inc. 
%   $Revision: 5.12.4.4 $  $Date: 2010/09/02 13:37:05 $

[x,y,h]=treelayout(p);
f = find(p~=0);
pp = p(f);
X = [x(f); x(pp); NaN(size(f))];
Y = [y(f); y(pp); NaN(size(f))];

X = X(:);
Y = Y(:);

if nargin == 1,
    n = length(p);
    if n < 500,
        plot (x, y, 'ro', X, Y, 'r-','linewidth',2);
    else
        plot (X, Y, 'r-','linewidth',2);
    end;
else
    [~, clen] = size(c);
    if nargin < 3, 
        if clen > 1, 
            d = [c(1:clen-1) '-']; 
        else
            d = 'r-';
        end;
    end;
    [~, dlen] = size(d);
    if clen>0 && dlen>0
        plot (x, y, c, X, Y, d,'linewidth',2);
    elseif clen>0,
        plot (x, y, c,'linewidth',2);
    elseif dlen>0,
        plot (X, Y, d,'linewidth',2);
    else
    end;
end;
xlabel(['height = ' int2str(h)]);
axis([0 1 0 1]);
