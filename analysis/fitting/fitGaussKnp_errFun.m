function mse = fitGaussKnp_errFun(prs,x,y)

yhat = fitGaussKnp_modelFun(x,prs);
mse = mean((y(:)-yhat(:)).^2);