function mse = fitDoubleSigmoidKnp_errFun(prs,x,y)

yhat = fitDoubleSigmoidKnp_modelFun(x,prs);
mse = mean((y(:)-yhat(:)).^2);