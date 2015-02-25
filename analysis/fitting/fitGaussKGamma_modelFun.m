function predic = fitGaussKGamma_modelFun(xvals,prs)

baseline = prs(1);
prsG1 = prs(2:4);
prsK1 = prs(6:7);
prsGs = prs(5);

xvals = [30*ones(size(xvals,1),30),xvals];
sz = size(xvals);
t = [1:20];

predic_pos = skewnormpdf(xvals(:),prsG1(1),prsG1(2),prsG1(3)); %normpdf(xvals,prs(1),prs(2));
predic_pos = predic_pos/max(predic_pos);
predic_pos = prsGs*reshape(predic_pos,sz) + baseline;

%K_pos = gampdf(t,prsK1(1),prsK1(2));
%K_pos = linspace(10,1,10)/10;
%K_pos = linspace(-10,10,3)/10;
K_pos = [5 25 0 -5 -10 -5 0]
%K_pos = flipdim(K_pos,2);
%K_pos = 1;
K_pos = K_pos/max(abs(K_pos));

predic_pos = conv2(predic_pos,K_pos);
predic_pos = predic_pos(:,31:end);
predic = predic_pos(:,1:sz(2)-30);

predic(predic<0) = 0;