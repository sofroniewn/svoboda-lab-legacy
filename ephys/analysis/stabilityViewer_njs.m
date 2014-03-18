function stabilityViewer_njs(clustnum)

global clustattrib;
global clustdata;


i_spk = clustattrib.clusters{clustnum}.index;
trials = clustdata.customvar.trials(i_spk);


figure(82);
clf(82)
hold on
[y x] = hist(trials,min(trials):max(trials));
bar(x,y);
xlim([min(trials) max(trials)]);

waveform_amp = range(clustdata.customvar.waveform(i_spk,:),2);
waveform_amp = waveform_amp-min(waveform_amp);
waveform_amp = waveform_amp/max(waveform_amp)*max(y) + max(y)*1.2;

plot(trials, waveform_amp,'.k');


