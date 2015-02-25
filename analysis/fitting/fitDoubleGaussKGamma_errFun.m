function mse = fitDoubleGaussKGamma_errFun(prs,x,y)

yhat = fitDoubleGaussKGamma_modelFun(x,prs);
mse = mean((y(:)-yhat(:)).^2);