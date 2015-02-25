function predic = fitBiGaussK_modelFun(xvals,prs)

sz = size(xvals);
predic = skewnormpdf(xvals(:),prs(1),prs(2),prs(3)); %normpdf(xvals,prs(1),prs(2));
predic = predic/max(predic);
predic = reshape(predic,sz);
K = prs(5:end);
predic = conv2(predic,K,'same');
predic = predic + prs(4);
predic(predic<0) = 0;