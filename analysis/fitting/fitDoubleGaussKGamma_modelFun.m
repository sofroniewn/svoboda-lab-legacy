function predic = fitDoubleGaussKGamma_modelFun(xvals,prs)

%baseline = prs(1);
prsG1 = prs(1:3);
prsG2 = prs(4:6);
prsK1 = prs(7:8);
prsK2 = prs(9:10);
prsKw = prs(11);
prsKs = prs(12);

sz = size(xvals);
t = [1:20];

predic_pos = skewnormpdf(xvals(:),prsG1(1),prsG1(2),prsG1(3)); %normpdf(xvals,prs(1),prs(2));
predic_pos = predic_pos/max(predic_pos);
predic_pos = reshape(predic_pos,sz);

K_pos = gampdf(t,prsK1(1),prsK1(2));
K_pos = K_pos/max(K_pos);
%K_pos = flipdim(K_pos,2);

predic_pos = conv2(predic_pos,K_pos,'same');

predic_neg = skewnormpdf(xvals(:),prsG2(1),prsG2(2),prsG2(3)); %normpdf(xvals,prs(1),prs(2));
predic_neg = predic_neg/max(predic_neg);
predic_neg = reshape(predic_neg,sz);

K_neg = gampdf(t,prsK2(1),prsK2(2));
K_neg = K_neg/max(K_neg);
%K_neg = flipdim(K_neg,2);

predic_neg = conv2(predic_neg,K_neg,'same');

predic = prsKs*2*(prsKw*predic_pos - (1-prsKw)*predic_neg); % + baseline;

%predic(predic<0) = 0;