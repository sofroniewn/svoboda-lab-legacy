function predic = fitBiGauss_modelFun(xvals,prs)

predic = skewnormpdf(xvals,prs(1),prs(2),prs(3)); %normpdf(xvals,prs(1),prs(2));
predic = predic/max(predic);
predic = predic*prs(5)+prs(4);
predic(predic<0) = 0;