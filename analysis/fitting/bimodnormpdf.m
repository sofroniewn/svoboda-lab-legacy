function  predic = bimodnormpdf(xvals,mu,phi,beta,delta);

%predic = 2/sigma*normpdf((xvals-mu)/sigma).*normcdf(skew*(xvals-mu)/sigma);
theta = delta + (beta - mu)^2;
gamma = 1 + 2*phi*theta;
c = 2*phi^(3/2)/gamma/sqrt(pi);
predic = c*(delta+(xvals - beta).^2).*exp(-phi*(xvals - mu).^2);



