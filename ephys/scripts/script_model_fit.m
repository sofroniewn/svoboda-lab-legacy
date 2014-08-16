
[r_ntk1 s_ctk1 s_labels] = convert_rs_format(sorted_spikes,session,trial_range,[0 5]);
[r_ntk2 s_ctk2 s_labels] = convert_rs_format(sorted_spikes,session,trial_range,[5 Inf]);

r_ntk = cat(3,r_ntk2,r_ntk1);
s_ctk = cat(3,s_ctk2,s_ctk1);

clear d;
d.S_ctk = s_ctk2;
d.R_ntk = r_ntk2;
d.rnd.n = 0;
d.samp = 'same';
d.u = 1;
d.c = size(d.S_ctk,1);
d.k = size(d.S_ctk,3);
d.t = size(d.S_ctk,2);

%load('/Users/sofroniewn/Documents/DATA/ephys_ex/anm_235585_running_formatted.mat')

d.S_ctk = d.S_ctk([1 2],:,:);
d.c = 2;

fit = fitInit(d,'NL','mse',25);
d = prepareStim(d,fit);


[train test] = prepareRoi(d,fit,11);
fit = fitDo(train,test,fit);

fil = triang(100)';




figure(7);
clf(7);
subplot(4,2,1)
imagesc(flipdim(conv2(squeeze(s_ctk2(1,:,:))',fil,'same'),1));
subplot(4,2,2)
imagesc(flipdim(conv2(squeeze(s_ctk2(2,:,:))',fil,'same'),1));
subplot(4,2,3)
imagesc(flipdim(conv2(reshape(fit.train.R_t,d.t,d.k)',fil,'same'),1));
subplot(4,2,4)
reshaped_fr = flipdim(reshape(fit.train.Z_t,d.t,d.k)',1); %- min(0,min(fit.train.Z_t))
reshaped_fr(reshaped_fr<0) = 0;
imagesc(conv2(poissrnd(reshaped_fr),fil,'same'));
%imagesc(flipdim(reshape(fit.train.Z_t,2001,50)',1));
subplot(4,2,5)
plot(fit.f(1).nd,fit.f(1).w,'r')
subplot(4,2,6)
plot(fit.B_q(1:25),'g')
subplot(4,2,7)
plot(fit.f(2).nd,fit.f(2).w,'r')
subplot(4,2,8)
plot(fit.B_q(26:50),'g')
