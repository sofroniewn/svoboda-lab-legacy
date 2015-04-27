function A = UnitToQuadrilateral( X )

% Computes the 3-by-3 two-dimensional projective transformation
% matrix A that maps the unit square ([0 0], [1 0], [1 1], [0 1])
% to a quadrilateral corners (X(1,:), X(2,:), X(3,:), X(4,:)).
% X must be 4-by-2, real-valued, and contain four distinct
% and non-collinear points.  A is a 3-by-3, real-valued matrix.
% If the four points happen to form a parallelogram, then
% A(1,3) = A(2,3) = 0 and the mapping is affine.
%
% The formulas below are derived in
%   Wolberg, George. "Digital Image Warping," IEEE Computer
%   Society Press, Los Alamitos, CA, 1990, pp. 54-56,
% and are based on the derivation in
%   Heckbert, Paul S., "Fundamentals of Texture Mapping and
%   Image Warping," Master's Thesis, Department of Electrical
%   Engineering and Computer Science, University of California,
%   Berkeley, June 17, 1989, pp. 19-21.

x = X(:,1);
y = X(:,2);

dx1 = x(2) - x(3);
dx2 = x(4) - x(3);
dx3 = x(1) - x(2) + x(3) - x(4);

dy1 = y(2) - y(3);
dy2 = y(4) - y(3);
dy3 = y(1) - y(2) + y(3) - y(4);

if dx3 == 0 && dy3 == 0
    % Parallelogram: Affine map
    A = [ x(2) - x(1)    y(2) - y(1)   0 ; ...
          x(3) - x(2)    y(3) - y(2)   0 ; ...
          x(1)           y(1)          1 ];
else
    % General quadrilateral: Projective map
    a13 = (dx3 * dy2 - dx2 * dy3) / (dx1 * dy2 - dx2 * dy1);
    a23 = (dx1 * dy3 - dx3 * dy1) / (dx1 * dy2 - dx2 * dy1);
    
    A = [x(2) - x(1) + a13 * x(2)   y(2) - y(1) + a13 * y(2)   a13 ;...
         x(4) - x(1) + a23 * x(4)   y(4) - y(1) + a23 * y(4)   a23 ;...
         x(1)                       y(1)                       1   ];
end




% %tform = projective2d([cosd(angle) -sind(angle) 0; sind(angle) cosd(angle) 0; 0 0 1]);

% fixedPoints = [0 0;1 0;0 1;1 1]
% movingPoints = [0, 0;1 0;tand(left_angle), 1;1+tand(10.5), 1]

% %tform = maketform('projective',fixedPoints,movingPoints);

% %tform = cp2tform(movingPoints,fixedPoints, 'projective');
% tform = cp2tform(movingPoints,fixedPoints, 'projective');

% %A = UnitToQuadrilateral(movingPoints);
% %K = [100 0 0;0 100 0;0 0 1];
% %tform = projective2d(A);

% [gclipped] = imtransform(gclipped,tform,'FillValues',NaN);
% size(gclipped)
% % need to deal with warp shifting bottom left cords

% figure
% hold on
% %plot([10, 100],[200 300],'r','linewidth',3)
% h = imshow(gclipped);
% set(h,'AlphaData',~isnan(gclipped))

% colormap('gray')