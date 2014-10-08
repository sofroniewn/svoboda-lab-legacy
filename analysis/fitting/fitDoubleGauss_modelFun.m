function predic = fitDoubleGauss_modelFun(xvals,prs)

% parameters prs(1:3) - mean, sigma, gain of positive gaussian
% parameters prs(4:6) - mean, sigma, gain of negaive gaussian
% prs(7) - baseline

predic_pos = normpdf(xvals,prs(1),prs(2));
predic_pos = predic_pos/max(predic_pos);

predic_neg = normpdf(xvals,prs(5),prs(6));
predic_neg = predic_neg/max(predic_neg);

predic = predic_pos*prs(3) - predic_pos*prs(6) + prs(7);