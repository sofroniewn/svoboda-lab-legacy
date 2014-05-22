

roi_id = 62;

global session_bv;
global session_ca;


scim_frames = logical(session_bv.data_mat(24,:));
bv_ca_data = session_bv.data_mat(:,scim_frames);


x_data = session_ca.time;
y_data = session_ca.dff(roi_id,:);

GCaMP6sV.y_data = y_data;
GCaMP6sV.x_data = x_data;
GCaMP6sV.avg = mean(im_session.reg.align_mean(:,:,2,1,:),5);

roi_id = 5;

global session_bv;
global session_ca;


scim_frames = logical(session_bv.data_mat(24,:));
bv_ca_data = session_bv.data_mat(:,scim_frames);


x_data = session_ca.time;
y_data = session_ca.dff(roi_id,:);

GCaMP6fT.y_data = y_data;
GCaMP6fT.x_data = x_data;

GCaMP6fT.avg = mean(im_session.reg.align_mean(:,:,2,1,:),5);

save('/Users/sofroniewn/Documents/svoboda_lab/Manuscripts/GCaMP6f_transgenic/data.mat','GCaMP6fT','GCaMP6sV')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


GCaMP6fT.ts_start = 50;
GCaMP6sV.ts_start = 85;
GCaMP6fT.t_window = 7*400;
GCaMP6sV.t_window = round(GCaMP6fT.t_window*mean(diff(GCaMP6fT.x_data))/mean(diff(GCaMP6sV.x_data)));

figure(32)
clf(32)
set(gca,'visible','off')
hold on
plot(GCaMP6fT.x_data(GCaMP6fT.ts_start:GCaMP6fT.ts_start+GCaMP6fT.t_window) - GCaMP6fT.x_data(GCaMP6fT.ts_start),GCaMP6fT.y_data(GCaMP6fT.ts_start:GCaMP6fT.ts_start+GCaMP6fT.t_window))
plot(GCaMP6sV.x_data(GCaMP6sV.ts_start:GCaMP6sV.ts_start+GCaMP6sV.t_window) - GCaMP6sV.x_data(GCaMP6sV.ts_start),GCaMP6sV.y_data(GCaMP6sV.ts_start:GCaMP6sV.ts_start+GCaMP6sV.t_window)-11,'r')

plot([0 0],[-6 -1],'k')
plot([0 20],[-6 -6],'k')

GCaMP6fT.ts_start_short = 50+346*7;
GCaMP6sV.ts_start_short = 85+219*7;
GCaMP6fT.ts_window_short = 7*10;
GCaMP6sV.ts_window_short = round(GCaMP6fT.ts_window_short*mean(diff(GCaMP6fT.x_data))/mean(diff(GCaMP6sV.x_data)));

plot([GCaMP6fT.x_data(GCaMP6fT.ts_start_short) GCaMP6fT.x_data(GCaMP6fT.ts_start_short+GCaMP6fT.ts_window_short)] - GCaMP6fT.x_data(GCaMP6fT.ts_start),[-6 -6],'k')
plot([GCaMP6sV.x_data(GCaMP6sV.ts_start_short) GCaMP6sV.x_data(GCaMP6sV.ts_start_short+GCaMP6sV.ts_window_short)] - GCaMP6sV.x_data(GCaMP6sV.ts_start),[-6 -6],'k')

ylim([-12 11])
set(gcf,'Position',[5   592  1145  206])



GCaMP6fT.ts_start = 50+346*7;
GCaMP6sV.ts_start = 85+219*7;
GCaMP6fT.t_window = 7*10;
GCaMP6sV.t_window = round(GCaMP6fT.t_window*mean(diff(GCaMP6fT.x_data))/mean(diff(GCaMP6sV.x_data)));

figure(33)
clf(33)
set(gca,'visible','off')
set(gcf,'Position',[440   675   624   123])
hold on
plot(GCaMP6fT.x_data(GCaMP6fT.ts_start:GCaMP6fT.ts_start+GCaMP6fT.t_window) - GCaMP6fT.x_data(GCaMP6fT.ts_start),GCaMP6fT.y_data(GCaMP6fT.ts_start:GCaMP6fT.ts_start+GCaMP6fT.t_window) - mean(GCaMP6fT.y_data(GCaMP6fT.ts_start:GCaMP6fT.ts_start+8)))
plot(GCaMP6sV.x_data(GCaMP6sV.ts_start:GCaMP6sV.ts_start+GCaMP6sV.t_window) - GCaMP6sV.x_data(GCaMP6sV.ts_start),GCaMP6sV.y_data(GCaMP6sV.ts_start:GCaMP6sV.ts_start+GCaMP6sV.t_window) - mean(GCaMP6sV.y_data(GCaMP6sV.ts_start:GCaMP6sV.ts_start+8)),'r')

plot([0 0],[1 4],'k')
plot([0 1],[0 0],'k')

ylim([-1.5 6])


figure(33)
clf(33)
aa = GCaMP6sV.avg(290:350,170:230)/800;
imshow(aa)


figure(33)
clf(33)
bb = GCaMP6fT.avg(230:290,170:230)/400;
imshow(bb/mean(bb(:))*mean(aa(:)))

