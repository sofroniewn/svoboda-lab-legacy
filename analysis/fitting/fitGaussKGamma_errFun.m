function mse = fitGaussKGamma_errFun(prs,x,y)

yhat = fitGaussKGamma_modelFun(x,prs);
mse = mean((y(:)-yhat(:)).^2);