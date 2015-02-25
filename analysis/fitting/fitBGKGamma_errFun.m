function mse = fitBGKGamma_errFun(prs,x,y)

yhat = fitBGKGamma_modelFun(x,prs);
mse = mean((y(:)-yhat(:)).^2);