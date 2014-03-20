function predic = fitSigmoid_modelFun(xvals,prs)

predic = 1./ (1 + exp((-(xvals-prs(1))/prs(2))));
predic = predic/max(predic);
predic = predic*prs(3);