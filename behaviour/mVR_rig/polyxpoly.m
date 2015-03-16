function [xi,yi,ii,ri] = polyxpoly(varargin)
%POLYXPOLY Intersection points for lines or polygon edges
%
%   [XI,YI] = POLYXPOLY(X1,Y1,X2,Y2) returns the intersection points of
%   two sets of lines and/or polygons.
%
%   [XI,YI] = POLYXPOLY(...,'unique') returns only unique intersections.
%
%   [XI,YI,II] = POLYXPOLY(...) also returns a two-column index of line
%   segment numbers corresponding to the intersection points.
%
%   See also NAVFIX, CROSSFIX, SCXSC, GCXGC, GCXSC, RHXRH.

% Copyright 1996-2009 The MathWorks, Inc.
% $Revision: 1.6.4.8 $  $Date: 2009/04/15 23:16:44 $
% Written by:  A. Kim

% set input variables
if nargin==4 || nargin==5
	x1 = varargin{1}(:);  y1 = varargin{2}(:);
	x2 = varargin{3}(:);  y2 = varargin{4}(:);
else
	error(['map:' mfilename ':mapError'], ...
        'Incorrect number of arguments')
end
if nargin==5,
	strcode = varargin{nargin};
else
	strcode = 'all';
end

% check for valid strcode
validtypes = {'all';'unique'};
if isempty(strmatch(strcode,validtypes))
	error(['map:' mfilename ':mapError'], ...
        'Valid options are ''all'' or ''unique''')
end

% % check x and y vectors
% msg = inputcheck('xyvector',x1,y1); 
% if ~isempty(msg)
%     error(['map:' mfilename ':mapError'], msg)
% end
% msg = inputcheck('xyvector',x2,y2);
% if ~isempty(msg)
%     error(['map:' mfilename ':mapError'], msg)
% end

% compute all intersection points
[xi,yi,ii] = intptsall(x1,y1,x2,y2);
ri = [];
if isempty([xi yi ii]),  return;  end

% format intersection points according to type and strcode
if ~isempty(strmatch(strcode,'unique'))
	[a,i,j] = uniqueerr(flipud([xi yi]),'rows',eps*1e4);
	i = length(xi)-flipud(sort(i))+1;
	xi = xi(i);  yi = yi(i);  ii = ii(i,:);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xi,yi,ii] = intptsall(x1,y1,x2,y2)
%INTPTSALL  Unfiltered line or polygon intersection points.
%   [XI,YI,II] = INTPTSALL(X1,Y1,X2,Y2) returns the unfiltered intersection 
%   points of two sets of lines or polygons, along with a two-column index
%   of line segment numbers corresponding to the intersection points.
%   Note: intersection points are ordered from lowest to hightest line 
%   segment numbers.

%  Written by:  A. Kim


err = eps*1e5;

% form line segment matrices
xs1 = [x1 [x1(2:end); x1(1)]];
ys1 = [y1 [y1(2:end); y1(1)]];
xs2 = [x2 [x2(2:end); x2(1)]];
ys2 = [y2 [y2(2:end); y2(1)]];

% remove last segment (for self-enclosed polygons, this is a non-segment;
% for lines, there are n-1 line segments)
xs1 = xs1(1:end-1,:);  ys1 = ys1(1:end-1,:);
xs2 = xs2(1:end-1,:);  ys2 = ys2(1:end-1,:);

% tile matrices for vectorized intersection calculations
N1 = length(xs1(:,1));  N2 = length(xs2(:,1));
X1 = reshape(repmat(xs1,1,N2)',2,N1*N2)';
Y1 = reshape(repmat(ys1,1,N2)',2,N1*N2)';
X2 = repmat(xs2,N1,1);
Y2 = repmat(ys2,N1,1);

% compute slopes
m1 = (Y1(:,2) - Y1(:,1)) ./ (X1(:,2) - X1(:,1));
m2 = (Y2(:,2) - Y2(:,1)) ./ (X2(:,2) - X2(:,1));
% m1(find(m1==-inf)) = inf;  m2(find(m2==-inf)) = inf;
m1(find(abs(m1)>1/err)) = inf;  m2(find(abs(m2)>1/err)) = inf;

% compute y-intercepts (note: imaginary values for vertical lines)
b1 = zeros(size(m1));  b2 = zeros(size(m2));
i1 = find(m1==inf);  if ~isempty(i1),  b1(i1) = X1(i1)*i;  end
i2 = find(m2==inf);  if ~isempty(i2),  b2(i2) = X2(i2)*i;  end
i1 = find(m1~=inf);  if ~isempty(i1),  b1(i1) = Y1(i1) - m1(i1).*X1(i1);  end
i2 = find(m2~=inf);  if ~isempty(i2),  b2(i2) = Y2(i2) - m2(i2).*X2(i2);  end

% zero intersection coordinate arrays
sz = size(X1(:,1));  x0 = zeros(sz);  y0 = zeros(sz);

% parallel lines (do not intersect except for similar lines)
% for similar lines, take the low and high points
% idx = find(m1==m2);
idx = find( abs(m1-m2)<err | (isinf(m1)&isinf(m2)) );
if ~isempty(idx)
% non-similar lines
% 	sub = find(b1(idx)~=b2(idx));  j = idx(sub);
	sub = find(abs(b1(idx)-b2(idx))>err);  j = idx(sub);
	x0(j) = nan;  y0(j) = nan;
% similar lines (non-vertical)
% 	sub = find(b1(idx)==b2(idx) & m1(idx)~=inf);  j = idx(sub);
	sub = find(abs(b1(idx)-b2(idx))<err & m1(idx)~=inf);  j = idx(sub);
	Xlo = max([min(X1(j,:),[],2) min(X2(j,:),[],2)],[],2);
	Xhi = min([max(X1(j,:),[],2) max(X2(j,:),[],2)],[],2);
	if ~isempty(j)
		j0 = find(abs(Xlo-Xhi)<=err);
		j1 = find(abs(Xlo-Xhi)>err);
		x0(j(j0)) = Xlo(j0);
		y0(j(j0)) = Y1(j(j0)) + m1(j(j0)).*(Xlo(j0) - X1(j(j0)));
		x0(j(j1)) = Xlo(j1) + i*Xhi(j1);
		y0(j(j1)) = (Y1(j(j1)) + m1(j(j1)).*(Xlo(j1) - X1(j(j1)))) + ...
					 i*(Y1(j(j1)) + m1(j(j1)).*(Xhi(j1) - X1(j(j1))));
% 		if Xlo==Xhi
% 		if abs(Xlo-Xhi)<=eps
% 			x0(j) = Xlo;
% 			y0(j) = Y1(j) + m1(j).*(Xlo - X1(j));
% 		else
% 			x0(j) = Xlo + i*Xhi;
% 			y0(j) = (Y1(j) + m1(j).*(Xlo - X1(j))) + ...
% 					 i*(Y1(j) + m1(j).*(Xhi - X1(j)));
% 		end
	end
% similar lines (vertical)
% 	sub = find(b1(idx)==b2(idx) & m1(idx)==inf);  j = idx(sub);
	sub = find(abs(b1(idx)-b2(idx))<err & m1(idx)==inf);  j = idx(sub);
	Ylo = max([min(Y1(j,:),[],2) min(Y2(j,:),[],2)],[],2);
	Yhi = min([max(Y1(j,:),[],2) max(Y2(j,:),[],2)],[],2);
	if ~isempty(j)
		y0(j) = Ylo + i*Yhi;
		x0(j) = X1(j) + i*X1(j);
	end
end

% non-parallel lines
% idx = find(m1~=m2);
idx = find(abs(m1-m2)>err);
if ~isempty(idx)
% non-vertical/non-horizontal lines
% 	sub = find(m1(idx)~=inf & m2(idx)~=inf & m1(idx)~=0 & m2(idx)~=0);
	sub = find(m1(idx)~=inf & m2(idx)~=inf & ...
			   abs(m1(idx))>eps & abs(m2(idx))>eps);
	j = idx(sub);
	x0(j) = (Y1(j) - Y2(j) + m2(j).*X2(j) - m1(j).*X1(j)) ./ ...
			(m2(j) - m1(j));
	y0(j) = Y1(j) + m1(j).*(x0(j)-X1(j));
% first line vertical
	sub = find(m1(idx)==inf);  j = idx(sub);
	x0(j) = X1(j);
	y0(j) = Y2(j) + m2(j).*(x0(j)-X2(j));
% second line vertical
	sub = find(m2(idx)==inf);  j = idx(sub);
	x0(j) = X2(j);
	y0(j) = Y1(j) + m1(j).*(x0(j)-X1(j));
% first line horizontal, second line non-vertical
% 	sub = find(m1(idx)==0 & m2(idx)~=inf);  j = idx(sub);
	sub = find(abs(m1(idx))<=eps & m2(idx)~=inf);  j = idx(sub);
	y0(j) = Y1(j);
	x0(j) = (Y1(j) - Y2(j) + m2(j).*X2(j)) ./ m2(j);
% second line horizontal, first line non-vertical
% 	sub = find(m2(idx)==0 & m1(idx)~=inf);  j = idx(sub);
	sub = find(abs(m2(idx))<=eps & m1(idx)~=inf);  j = idx(sub);
	y0(j) = Y2(j);
	x0(j) = (Y1(j) - y0(j) - m1(j).*X1(j)) ./ -m1(j);
% connecting line segments (exact solution)
% 	sub1 = find(X1(idx,1)==X2(idx,1) & Y1(idx,1)==Y2(idx,1));
% 	sub2 = find(X1(idx,1)==X2(idx,2) & Y1(idx,1)==Y2(idx,2));
% 	sub3 = find(X1(idx,2)==X2(idx,1) & Y1(idx,2)==Y2(idx,1));
% 	sub4 = find(X1(idx,2)==X2(idx,2) & Y1(idx,2)==Y2(idx,2));
% 	j1 = idx(sort([sub1; sub2]));
% 	j2 = idx(sort([sub3; sub4]));
% 	x0(j1) = X1(j1,1);  y0(j1) = Y1(j1,1);
% 	x0(j2) = X1(j2,2);  y0(j2) = Y1(j2,2);
end

% throw away points that lie outside of line segments
dx1 = [min(X1,[],2)-x0, x0-max(X1,[],2)];
dy1 = [min(Y1,[],2)-y0, y0-max(Y1,[],2)];
dx2 = [min(X2,[],2)-x0, x0-max(X2,[],2)];
dy2 = [min(Y2,[],2)-y0, y0-max(Y2,[],2)];
% [irow,icol] = find([dx1 dy1 dx2 dy2]>1e-14);
[irow,icol] = find([dx1 dy1 dx2 dy2]>err);
idx = sort(unique(irow));
x0(idx) = nan;
y0(idx) = nan;

% retrieve only intersection points (no nans)
idx = find(~isnan(x0));
xi = x0(idx);  yi = y0(idx);

% determine indices of line segments that intersect
i1 = ceil(idx/N2);  i2 = rem(idx,N2);
if ~isempty(i2),  i2(find(i2==0)) = N2;  end
ii = [i1 i2];

% combine all intersection points
indx = union(find(imag(xi)),find(imag(yi)));
% indx = find(imag(xi));
for n=length(indx):-1:1
	j = indx(n);
	ii = [ii(1:j-1,:); ii(j,:); ii(j:end,:)];
	xi = [xi(1:j-1); imag(xi(j)); real(xi(j:end))];
	yi = [yi(1:j-1); imag(yi(j)); real(yi(j:end))];
end

% round intersection points
% xi = round(xi/1e-9)*1e-9;
% yi = round(yi/1e-9)*1e-9;

% check for identical intersection points (numerical error in epsilon)
[xt,ixt,jxt] = uniqueerr(xi,[],err);
[yt,iyt,jyt] = uniqueerr(yi,[],err);
xi = xt(jxt);  yi = yt(jyt);
[xi,yi] = ptserr(xi,yi,[x1;x2],[y1;y2],err);
% if ~isempty([xi yi])
% 	N = length(xi);
% 	xi1 = repmat(xi,N,1);  yi1 = repmat(yi,N,1);
% 	xi2 = repmat(xi',N,1);  yi2 = repmat(yi',N,1);
% 	xi2 = xi2(:);  yi2 = yi2(:);
% 	dxi = abs(xi1 - xi2);  dyi = abs(yi1 - yi2);
% 	indx = find((dxi>0 & dxi<eps) | dyi>0 & dyi<eps);
% 	itmp = rem(indx,N);
% 	if ~isempty(itmp),  itmp(find(itmp==0)) = N;  end
% 	ixyi = [ceil(indx/N) itmp];
% 	while ~isempty(ixyi)
% 		idx =  find(ismember([xi(ixyi(1,:)) yi(ixyi(1,:))],...
% 							 [x1 y1; x2 y2],'rows'));
% 		xi(ixyi(1,:)) = xi(ixyi(1,idx));
% 		yi(ixyi(1,:)) = yi(ixyi(1,idx));
% 		iz = find(ixyi(:,1)==ixyi(1,2) & ixyi(:,2)==ixyi(1,1));
% 		ixyi([1 iz],:) = [];
% 	end
% end

% figure; hold; plotpoly(x1,y1,'b*-'); plotpoly(x2,y2,'ro--')
% [xi yi ii]
% keyboard

%----------------------------------------------------------------
% function plotpoly(varargin)
% %PLOTPOLY  Plot polygon.
% %   PLOTPOLY(X,Y,S) plots polygon.
% %
% %   PLOTPOLY(MAT,S) uses the column vectors in MAT.
% 
% %  Written by:  A. Kim
% 
% if nargin==3
% 	xcell = varargin{1};
% 	ycell = varargin{2};
% 	s = varargin{3};
% elseif nargin==2
% 	mat = varargin{1};
% 	s = varargin{2};
% 	xcell = mat(:,1);
% 	ycell = mat(:,2);
% else
% 	error(['map:' mfilename ':mapError'], 'Incorrect number of arguments')
% end
% 
% % set up plot
% % figure; hold on; axis equal; grid on
% % set(gca,'xlim',[0 12],'ylim',[0 10])
% % xl = [floor(min(x))-1, ceil(max(x))+1];
% % yl = [floor(min(y))-1, ceil(max(y))+1];
% % xl(1) = floor(min([get(gca,'xlim'), xl]));
% % xl(2) = ceil(max([get(gca,'xlim'), xl]));
% % yl(1) = floor(min([get(gca,'ylim'), yl]));
% % yl(2) = ceil(max([get(gca,'ylim'), yl]));
% % set(gca,'xlim',xl,'ylim',yl,'xtick',xl(1):xl(2),'ytick',yl(1):yl(2))
% 
% if ~iscell(xcell)
% 	xcell = {xcell};
% 	ycell = {ycell};
% end
% 
% for n=1:length(xcell)
% 
% % cell element
% x = xcell{n};
% y = ycell{n};
% 
% % account for polygons with inner holes
% % if isempty(find(isnan(x)))
% 	x = [x; nan];
% 	y = [y; nan];
% % end
% nanindx = find(isnan(x));
% 
% % draw outer contour and show starting point
% indx = 1:nanindx(1)-1;
% plot(x(indx),y(indx),s,'linewidth',2);
% plot(x(1),y(1),[s(1) 'o'],'markersize',14)
% 
% % draw contour direction arrow
% %arrow([x(1) y(1)],[x(2) y(2)],'edgecolor',s(1),'facecolor',s(1),...
% %		'length',16,'baseangle',45);
% 
% % draw inner holes and show starting points and direction arrows
% for n=1:length(nanindx)-1
% 	indx = nanindx(n)+1:nanindx(n+1)-1;
% 	plot(x(indx),y(indx),s);
% 	plot(x(indx(1)),y(indx(1)),[s(1) 'o'],'markersize',12)
% %	arrow([x(indx(1)) y(indx(1))],[x(indx(2)) y(indx(2))],...
% %			'edgecolor',s(1),'facecolor',s(1),...
% %			'length',10,'baseangle',45);
% end
% 
% end  % cell element

%----------------------------------------------------------------
function [xi,yi] = ptserr(xi,yi,xa,ya,err)
% PTSERR removes floating point errors of xi and yi by setting them to
% x1 y1 values

ni = length(xi);  na = length(xa);
Xi = reshape(reshape(repmat(xi,na,1),ni,na)',ni*na,1);
Yi = reshape(reshape(repmat(yi,na,1),ni,na)',ni*na,1);
Xa = repmat(xa,ni,1);
Ya = repmat(ya,ni,1);
ix = find( (abs(Xi-Xa)>0 & abs(Xi-Xa)<=err) );
iy = find( (abs(Yi-Ya)>0 & abs(Yi-Ya)<=err) );
xi(ceil(ix/na)) = Xa(ix);
yi(ceil(iy/na)) = Ya(iy);

%----------------------------------------------------------------
function [b,ndx,pos] = uniqueerr(a,flag,err)
%UNIQUEERR set unique with error

if isempty(a), b = a; ndx = []; pos = []; return, end

if nargin<3,  err = 0;  end

rowvec = 0;
if nargin==1 || isempty(flag),
  rowvec = size(a,1)==1;
  [b,ndx] = sort(a(:));
  % d indicates the location of matching entries
  db = abs(b((1:end-1)') - b((2:end)'));
  d = db>=0 & db<=err;
else
  if ~ischar(flag) || ~strcmp(flag,'rows')
      error(['map:' mfilename ':mapError'], 'Unknown flag.')
  end
  [b,ndx] = sortrows(a);
  n = size(a,1);
  if n > 1,
    % d indicates the location of matching entries
	db = abs(b(1:end-1,:) - b(2:end,:));
    d = db>=0 & db<=err;
    if ~isempty(d), d = all(d,2); end
  else
    d = [];
  end
end

if nargout==3, % Create position mapping vector
  pos(ndx) = cumsum([1;~d]);
  pos = pos';
end

b(d,:) = [];
ndx(d) = [];

if rowvec, 
  b = b.';
  ndx = ndx.'; 
  if nargout==3, pos=pos.'; end
end