function [gclipped xdata ydata tform] = make_reward_patch(x_cords,y_cords,scale,phase,tform)


angle = 0; %+right_angle;

% dimensions of image
x = 128;
y = 128;

% frequency in cycles per image (assuming square)
freq = 4*scale;

% convert angle to two-dimensional frequency
omega = [freq * sind(angle), freq * cosd(angle)];

g = mkSine2(x, y, 1, omega, phase, 1);
gclipped = zeros(size(g));
gclipped(g >= 0) = 1;

if isempty(tform)
    startPts = [x_cords(1),y_cords(1);x_cords(1),y_cords(2);x_cords(4),y_cords(2);x_cords(4),y_cords(1)];
    targetPts = [x_cords y_cords];
    tform = maketform('projective',startPts,targetPts);
end

udata = [x_cords(1),x_cords(4)];  vdata = [y_cords(1),y_cords(2)];
[gclipped,xdata, ydata] = imtransform(gclipped, tform,'nearest',...
                              'udata', udata,...
                              'vdata', vdata,...
                              'fill', NaN);