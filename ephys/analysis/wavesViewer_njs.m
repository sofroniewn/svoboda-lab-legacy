function wavesViewer_njs(clustnum)

global clustattrib;
global clustdata;


i_spk = clustattrib.clusters{clustnum}.index;

figure
plot(clustdata.customvar.waveform(i_spk,:)','color','m');


if sum(clustdata.otherfiltersOn)>1
    hold on
    plot(clustdata.customvar.waveform(clustdata.filteredpoints,:)','color','k');
end


