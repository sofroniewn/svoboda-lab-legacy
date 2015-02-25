function predic = fitGaussVKnp_modelFun(xvals,prs)

baseline = prs(1);
prsG1 = prs(2:4);
prsK1 = prs(6:7);
prsV = prs(8:10);
gain = prs(5);

xvals = [repmat(xvals(:,1),1,60),xvals,repmat(xvals(:,end),1,60)];
sz = size(xvals);

predic_pos = skewnormpdf(xvals(:),prsG1(1),prsG1(2),prsG1(3)); %normpdf(xvals,prs(1),prs(2));
predic_pos = predic_pos/max(predic_pos);
predic_pos = gain*reshape(predic_pos,sz) + baseline;

vel = round(diff(xvals,[],2)*10);
vel = [vel vel(:,end)]/max(abs(vel(:)));
veln = vel;
veln(vel<0) = vel(vel<0)*prsV(1);
veln(vel>0) = vel(vel>0)*prsV(2);
veln = veln + prsV(3);
predic_pos = predic_pos.*veln;

K_pos = prsK1;
K_pos = K_pos/max(abs(K_pos));

predic_pos = conv2(predic_pos,K_pos);
predic_pos = predic_pos(:,61:end-60);
predic = predic_pos(:,1:sz(2)-120);

predic(predic<0) = 0;