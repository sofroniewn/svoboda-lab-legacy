function predic = fitDoubleSigmoid_modelFun(xvals,prs)

baseline = prs(1);
gain = prs(2);
weight = prs(3);
center_1 = prs(4);
scale_1 = prs(5);
center_2 = prs(6);
scale_2 = prs(7);


predic = 1./ (1 + exp(((xvals-center_1)/scale_1)));
predic_1 = predic/max(predic);

predic = 1./ (1 + exp(((xvals-center_2)/scale_2)));
predic_2 = predic/max(predic);

predic = gain*(predic_1 - weight*predic_2) + baseline;

predic(predic<0) = 0;
