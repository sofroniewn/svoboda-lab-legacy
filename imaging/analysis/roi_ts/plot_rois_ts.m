function plot_rois_ts(tRoi)


global session_bv;
global session_ca;


roi_id = find(session_ca.roiIds == tRoi.id);
if ~isempty(roi_id)

scim_frames = logical(session_bv.data_mat(24,:));
bv_ca_data = session_bv.data_mat(:,scim_frames);


x_data = session_ca.time;
y_data = session_ca.dff(roi_id,:);

axes_label = 1;

figure(axes_label);
clf(axes_label);
set(gcf,'Position',[723   522   714   177])
hold on 
plot(session_ca.time,bv_ca_data(22,:)/30*3,'r')
%plot(session_ca.time,bv_ca_data(3,:)/30*3,'k')
plot(x_data,y_data)

else
	display('ROI id not found')
	tRoi
end