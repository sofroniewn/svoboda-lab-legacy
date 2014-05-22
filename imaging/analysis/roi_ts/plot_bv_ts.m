function plot_bv_ts(bv_name)

global session_bv;
global session_ca;
global handles_roi_ts;

if ~isempty(session_ca)

scim_frames = logical(session_bv.data_mat(24,:));
bv_ca_data = session_bv.data_mat(:,scim_frames);

switch bv_name
	case 'speed'
	y_data = bv_ca_data(22,:)/30*3;
	y_col = 'r';
case 'corPos'
	y_data = bv_ca_data(3,:)/30*3;
	y_col = 'k';
otherwise
	display('Unrecognized behaviour variable')
	y_data = zeros(1,size(bv_ca_data,2));
	y_col = 'k';
end
figure(1)
set(handles_roi_ts.plot_bv,'ydata',y_data)
set(handles_roi_ts.plot_bv,'color',y_col)
figure(handles_roi_ts.gui_fig);

end
