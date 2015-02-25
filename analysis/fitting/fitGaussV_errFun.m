function mse = fitGaussV_errFun(prs,x,y)

yhat = fitGaussV_modelFun(x,prs);
mse = mean((y(:)-yhat(:)).^2);