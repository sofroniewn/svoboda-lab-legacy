function predic = fitGauss_modelFun(xvals,prs)

predic = normpdf(xvals,prs(1),prs(2));
predic = predic/max(predic);
predic = predic*prs(3) + prs(4);