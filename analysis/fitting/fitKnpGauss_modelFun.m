function predic = fitKnpGauss_modelFun(xvals,prs)

baseline = prs(1);
prsG1 = prs(2:4);
prsK1 = prs(6:end);
gain = prs(5);

sz = size(xvals);
xvals = [repmat(xvals(:,1),1,60),xvals,repmat(xvals(:,1),1,60)];

K_pos = prsK1;
K_pos = K_pos/max(abs(K_pos));

xvals = conv2(xvals,K_pos);
xvals = xvals(:,61:end-60);
xvals = xvals(:,1:sz(2));

predic_pos = skewnormpdf(xvals(:),prsG1(1),prsG1(2),prsG1(3)); %normpdf(xvals,prs(1),prs(2));
predic_pos = predic_pos/max(predic_pos);
predic = gain*reshape(predic_pos,sz) + baseline;

predic(predic<0) = 0;