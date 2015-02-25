function predic = fitGaussKnp_modelFun(xvals,prs)

baseline = prs(1);
prsG1 = prs(2:4);
prsK1 = prs(6:end);
gain = prs(5);

xvals = [repmat(xvals(:,1),1,60),xvals,repmat(xvals(:,end),1,60)];
sz = size(xvals);

predic_pos = skewnormpdf(xvals(:),prsG1(1),prsG1(2),prsG1(3)); %normpdf(xvals,prs(1),prs(2));
predic_pos = predic_pos/max(predic_pos);
predic_pos = gain*reshape(predic_pos,sz) + baseline;

K_pos = prsK1;
K_pos = K_pos/max(abs(K_pos));

predic_pos = conv2(predic_pos,K_pos);
predic_pos = predic_pos(:,61:end-60);
predic = predic_pos(:,1:sz(2)-120);

predic(predic<0) = 0;