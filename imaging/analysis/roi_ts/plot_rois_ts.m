function plot_rois_ts(tRoi)


global session_bv;
global session_ca;
global handles_roi_ts;


roi_id = find(session_ca.roiIds == tRoi.id);
if ~isempty(roi_id)

scim_frames = logical(session_bv.data_mat(24,:));
bv_ca_data = session_bv.data_mat(:,scim_frames);


x_data = session_ca.time;
y_data = session_ca.dff(roi_id,:);

else
	display('ROI id not found')
	y_data = zeros(size(x_data));
	tRoi
end

set(handles_roi_ts.plot_roi,'ydata',y_data)
