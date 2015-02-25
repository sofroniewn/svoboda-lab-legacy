function predic = fitDoubleGaussK_modelFun(xvals,prs)

baseline = prs(1);
prsG1 = prs(2:4);
prsG2 = prs(5:7);
length_K = (length(prs)-7)/2;
prsK1 = prs(8:7+length_K);
prsK2 = prs(8+length_K:end);

sz = size(xvals);

predic_pos = skewnormpdf(xvals(:),prsG1(1),prsG1(2),prsG1(3)); %normpdf(xvals,prs(1),prs(2));
predic_pos = predic_pos/max(predic_pos);
predic_pos = reshape(predic_pos,sz);

K_pos = prsK1;
predic_pos = conv2(predic_pos,K_pos,'same');

predic_neg = skewnormpdf(xvals(:),prsG2(1),prsG2(2),prsG2(3)); %normpdf(xvals,prs(1),prs(2));
predic_neg = predic_neg/max(predic_neg);
predic_neg = reshape(predic_neg,sz);

K_neg = prsK2;
predic_neg = conv2(predic_neg,K_neg,'same');

predic = predic_pos - predic_neg + baseline;

 predic(predic<0) = 0;