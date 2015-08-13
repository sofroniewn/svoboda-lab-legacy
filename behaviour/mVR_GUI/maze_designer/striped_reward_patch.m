function gclipped = striped_reward_patch(left_angle,right_angle)

% position of form bottom left x, width, bottom left y, height

angle = (left_angle+right_angle)/2; %right_angle; Need to deal with both angles, different


% dimensions of image
x = 512;
y = 512;

% frequency in cycles per image (assuming square)
freq = 4;

% convert angle to two-dimensional frequency
omega = [freq * sind(angle), freq * cosd(angle)];

% generate frames (only phase varies)
t = 100;
phases = linspace(0, 2*pi, t);

i = 1;

g = mkSine2(x, y, 1, omega, phases(i*t), 1);
gclipped = zeros(size(g));
gclipped(g >= 0) = 1;


unitSquare = [ 0 0;  1  0;  1  1; 0 1];
targetPts = [0, 0;1 0;sind(left_angle), 1;.2+sind(10), 1];
tform = maketform('projective',unitSquare,targetPts);

% Fill with gray and use bicubic interpolation. 
% Make the output size the same as the input size.
udata = [0 1];  vdata = [0 1];
[B,xdata,ydata] = imtransform(gclipped, tform, 'bicubic', ...
                              'udata', udata,...
                              'vdata', vdata,...
                              'size', size(gclipped),...
                              'fill', NaN);

figure
h = imshow(B,'XData',xdata,'YData',ydata)
set(h,'AlphaData',~isnan(gclipped))
