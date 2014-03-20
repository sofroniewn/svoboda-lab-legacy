function mse = fitSigmoid_errFun(prs,x,y)

yhat = fitSigmoid_modelFun(x,prs);
mse = mean((y-yhat).^2);
