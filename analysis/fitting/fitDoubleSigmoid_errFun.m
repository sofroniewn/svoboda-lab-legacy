function mse = fitDoubleSigmoid_errFun(prs,x,y)

yhat = fitDoubleSigmoid_modelFun(x,prs);
mse = mean((y(:)-yhat(:)).^2);