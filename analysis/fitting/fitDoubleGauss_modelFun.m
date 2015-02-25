function predic = fitDoubleGauss_modelFun(xvals,prs)

% parameters prs(1:3) - mean, sigma, gain of positive gaussian
% parameters prs(4:6) - mean, sigma, gain of negaive gaussian
% prs(7) - baseline

predic_pos = skewnormpdf(xvals,prs(1),prs(2),prs(4));
predic_pos = predic_pos/max(predic_pos);

predic_neg = skewnormpdf(xvals,prs(5),prs(6),prs(8));
predic_neg = predic_neg/max(predic_neg);

predic = predic_pos*prs(3) - predic_neg*prs(7);