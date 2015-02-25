function mse = fitGaussVKnp_errFun(prs,x,y)

yhat = fitGaussVKnp_modelFun(x,prs);
mse = mean((y(:)-yhat(:)).^2);