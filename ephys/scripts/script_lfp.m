

%base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_03'; %anm #3 for olR and old cl

[lfp_data] = func_extract_lfp(base_dir, [], 'lfp_data_rev2', 0);



lfp_data.trial_length = zeros(numel(lfp_data.raw_vlt),1);
for ij = 1:numel(lfp_data.raw_vlt)
	lfp_data.trial_length(ij) = length(lfp_data.raw_vlt{ij});
end


figure(32)
clf(32)
hold on
plot(lfp_data.trial_length)
plot(session.trial_info.length-501,'r')

x = mean(lfp_data.flt_vlt{1}(:,:),2);


t = [1:length(x)]/20000;

        Hs=spectrum.mtm(4);
        Hpsd = psd(Hs,x,'Fs',20000);
        zzz(ij,:) = Hpsd.data;


figure(21);
clf(21)
plot(Hpsd.Frequencies,Hpsd.Data,'r')
xlim([0 100])
ylim([0 2*10^(-10)])



d_F = fdesign.bandpass('N,Fc1,Fc2',4,4,10,20000);
H_bp = design(d_F,'butter');
[b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);

xy = filtfilt(b,a,x);



d_F2 = fdesign.bandpass('N,Fc1,Fc2',4,4,10,500);
H_bp2 = design(d_F2,'butter');
[b2 a2] = sos2tf(H_bp2.sosMatrix,H_bp2.scaleValues);


iTrial = 2;
x = lfp_data.raw_vlt{iTrial};
xy = lfp_data.flt_vlt{iTrial};
xh = angle(hilbert(xy));
t = [1:length(x)]/500;

z = session.data{iTrial}.processed_matrix(10,501:end);
z(isnan(z)) = 0;
zx = filtfilt(b2,a2,z);
zh = angle(hilbert(zx));
tz = [1:length(z)]/500;



figure(23)
clf(23)
hold on
%plot(t,zscore(x),'b')
plot(t,x,'r')
plot(t,xy,'g')



figure(23)
clf(23)
hold on
%plot(t,zscore(x),'b')
plot(t,zscore(xy),'r')
plot(tz,nanzscore(-zx),'g')

figure(23)
clf(23)
hold on
%plot(t,zscore(x),'b')
plot(t,xh,'r')
plot(tz,zh,'g')

figure(23)
clf(23)
hold on
%plot(t,zscore(x),'b')
plot(zh,xh(1:length(zx)),'.r')


xlim([1 4])


figure(88)
clf(88)
length_vec = min(length(x),length(z));
[MCxy,W] =  mscohere(zx(1:length_vec),xy(1:length_vec),triang(500),250,1024,500);
%plot(Hpsd)
hold on
plot(W,MCxy,'r')





