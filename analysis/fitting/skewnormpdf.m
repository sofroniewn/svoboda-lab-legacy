function  predic = skewnormpdf(xvals,mu,sigma,skew);

predic = 2/sigma*normpdf((xvals-mu)/sigma).*normcdf(skew*(xvals-mu)/sigma);

