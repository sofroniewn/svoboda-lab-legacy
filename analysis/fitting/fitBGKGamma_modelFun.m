function predic = fitBGKGamma_modelFun(xvals,prs)

%baseline = prs(1);
prsBG = prs(1:4);
prsK = prs(5:6);
prsS = prs(7);
baseline = prs(8);

sz = size(xvals);
t = [1:20];

predic_pos = bimodnormpdf(xvals(:),prsBG(1),prsBG(2),prsBG(3),prsBG(4));
predic_pos = predic_pos/max(predic_pos);
predic_pos = reshape(predic_pos,sz);

K_pos = gampdf(t,prsK(1),prsK(2));
K_pos = K_pos/max(K_pos);
%K_pos = flipdim(K_pos,2);

predic_pos = conv2(predic_pos,K_pos,'same');

predic = prsS*predic_pos + baseline;

%predic(predic<0) = 0;