function predic = fitGS2D_modelFun(xvals,yvals,prs)

predic_x = normpdf(xvals,prs(1),prs(2));
predic_x = predic_x/max(predic_x);

predic_y = 1./ (1 + exp((-(yvals-prs(3))/prs(4))));
predic_y = predic_y/max(predic_y);

predic = predic_x.*predic_y;
predic = predic*prs(5) + prs(6);