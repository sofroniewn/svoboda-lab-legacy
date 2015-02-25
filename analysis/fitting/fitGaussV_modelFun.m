function predic = fitGaussV_modelFun(xvals,prs)

baseline = prs(1);
prsG1 = prs(2:4);
prsV = prs(6:8);
gain = prs(5);

xvals = [repmat(xvals(:,1),1,60),xvals,repmat(xvals(:,end),1,60)];
sz = size(xvals);

predic_pos = skewnormpdf(xvals(:),prsG1(1),prsG1(2),prsG1(3)); %normpdf(xvals,prs(1),prs(2));
predic_pos = predic_pos/max(predic_pos);
predic_pos = gain*reshape(predic_pos,sz);

vel = round(diff(xvals,[],2)*10);
vel = [vel vel(:,end)]/max(abs(vel(:)));
veln = vel;
veln(vel<0) = vel(vel<0)*prsV(1);
veln(vel>0) = vel(vel>0)*prsV(2);
veln = veln + prsV(3);
predic_pos = predic_pos.*veln;

predic_pos = predic_pos(:,61:end-60);
predic = predic_pos(:,1:sz(2)-120) + baseline;

predic(predic<0) = 0;