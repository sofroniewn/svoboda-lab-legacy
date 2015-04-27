% direction of motion in degrees (0 )
angle = 0;

% dimensions of image
x = 512;
y = 512;

% frequency in cycles per image (assuming square)
freq = 4

% convert angle to two-dimensional frequency
omega = [freq * sind(angle), freq * cosd(angle)];

% generate frames (only phase varies)
t = 100;
phases = linspace(0, 2*pi, t);
for it = 1:t
	g = mkSine2(x, y, 1, omega, phases(it), 1);
	gclipped = zeros(size(g));
	gclipped(g >= 0) = 1;
	imagesc(gclipped);
	drawnow;
end

tform = maketform('affine',[1 0 0; .5 1 0; 0 0 1]);
gclipped = imtransform(gclipped,tform,'FillValues',NaN);


figure
hold on
plot([10, 100],[200 300],'r','linewidth',3)
h = imshow(J);
set(h,'AlphaData',~isnan(J))





% generate frames (only phase varies)
figure
t = 100;
phases = linspace(0, 2*pi, t);
for it = 1:t
	g = mkSine2(x, y, 1, omega, phases(it), 1);
	gclipped = zeros(size(g));
	gclipped(g >= 0) = 1;
	tform = maketform('projective',[1 0 0; .5 1 .0007; 0 0 1]);
	gclipped = imtransform(gclipped,tform,'FillValues',NaN);
	h = imshow(gclipped);
	set(h,'AlphaData',~isnan(gclipped))
	drawnow;
end


figure
hold on
plot([10, 100],[200 300],'r','linewidth',3)
h = imshow(J);
set(h,'AlphaData',~isnan(J))

