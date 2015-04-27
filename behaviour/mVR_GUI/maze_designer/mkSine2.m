function m = mkSine2(xsize,ysize,amplitude,freq,phase,center)

%
% m = mkSine2(xsize,ysize,amplitude,freq,phase,center)
%
% make a 2-d sinusoid
% xsize and ysize are the dimensions in pixels
% amplitude is the amplitude of the sinusoid
% freq is a two vector giving the frequency in x and y in cycles per pixel
% phase is the phase of the sinusoid
% center is a flag that determines whether the origin of the sinusoid
% should be shifted so as to be the center (rather than the upper left)

x = 0:xsize-1; % create vector of x vals
y = 0:ysize-1; % vector of y vals
if center
    x = x - (xsize+1)/2; % shift if we want to center sinusoid at origin
    y = y - (ysize+1)/2;
end

[xMesh,yMesh] = meshgrid(x,y); % create meshgrid with these x and y vals
m = amplitude*cos((2*pi/xsize)*freq(1)*xMesh+(2*pi/xsize)*freq(2)*yMesh+phase); % create sinusoid
