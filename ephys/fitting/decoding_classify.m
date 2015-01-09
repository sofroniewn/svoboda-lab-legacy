ntrain = 10;
ntest = 5;
ncond = 61;
noise = 0.1;
mu = u_nc;

train = [];
for iRep = 1:ntrain
	train = [train, mu + randn(size(mu)) * sqrt(noise)];
end
test = [];
for iRep = 1:ntest
	test = [test, mu + randn(size(mu)) * sqrt(noise)];
end
train_groups = repmat([1:61],[1,10]);
test_groups = repmat([1:61],[1,5]);

labels = classify(test', train', train_groups);
perf = sum(labels == test_groups') / (ntest * ncond);

disp(perf)