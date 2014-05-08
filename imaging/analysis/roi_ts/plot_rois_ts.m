function [x_data y_data] = plot_rois_ts(axes_label,roi_id)


global session_bv;
global session_ca;

session_bv.data_names
scim_frames = logical(session_bv.data_mat(24,:));
bv_ca_data = session_bv.data_mat(:,scim_frames);


x_data = session_ca.time;
y_data = session_ca.dff(roi_id,:);

figure(axes_label);
clf(axes_label);
set(gcf,'Position',[440   621   985   177])
hold on 
plot(x_data,y_data)
%plot(session_ca.time,bv_ca_data(22,:),'k')
%plot(session_ca.time,bv_ca_data(3,:),'k')
%plot(session_ca.time,bv_ca_data(22,:),'r')
%plot(session_ca.time,bv_ca_data(3,:),'k')
