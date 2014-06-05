function outputs = update_tuning_summary_plot(hObject,~)

h_axes = get(hObject,'Parent');

pos = get(h_axes,'CurrentPoint');
x_range = get(h_axes,'xlim');
y_range = get(h_axes,'ylim');
 
 x_range = x_range(2) - x_range(1);
 y_range = y_range(2) - y_range(1);


 x_data = get(hObject,'XData');
 y_data = get(hObject,'YData');
 
if length(x_data) > 1
dist = sqrt(1/x_range*(x_data - pos(1,1)).^2+1/y_range*(y_data - pos(1,2)).^2);
[val Idx] = min(dist);

global session_ca;
roi_id = session_ca.roiIds(Idx);
global im_session;

plane = session_ca.roiFOVidx(Idx);

for ij=1:numel(im_session.ref.roi_array)
	im_session.ref.roi_array{ij}.guiSelectedRoiIds = [];
	im_session.ref.roi_array{ij}.updateImage();
end

	im_session.ref.roi_array{plane}.guiSelectedRoiIds = roi_id;
	im_session.ref.roi_array{plane}.updateImage();

outputs = ['ROI ' num2str(roi_id)];
tRoi.id = roi_id;
plot_rois_ts(tRoi);

else
	outputs = '';
end

