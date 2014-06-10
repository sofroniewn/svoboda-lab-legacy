function plot_bv_ts(bv_name)

global session_bv;
global session_ca;
global handles_roi_ts;

if ~isempty(session_ca)

scim_frames = logical(session_bv.data_mat(24,:));
bv_ca_data = session_bv.data_mat(:,scim_frames);

switch bv_name
	case 'speed'
	y_data = bv_ca_data(22,:);
	y_col = 'r';
    y_label = 'Speed (cm/s)';
	y_range = [-6 60];
	y_tick = [0:12:60];	
case 'corPos'
	y_data = bv_ca_data(3,:);
	y_col = 'b';
    y_label = 'Wall Distance (mm)';
	y_range = [-3 30];	
	y_tick = [0:6:30];	
otherwise
	display('Unrecognized behaviour variable')
	y_data = zeros(1,size(bv_ca_data,2));
	y_col = 'k';
    y_label = '';
	y_range = [-.5 5];
	y_tick = [0:1:5];	
end
handles_roi_ts.y_col = y_col;
figure(1)
set(handles_roi_ts.plot_bv,'ydata',y_data)
set(handles_roi_ts.plot_bv,'color',y_col)
ylabel(handles_roi_ts.axes(2),y_label)
ylim(handles_roi_ts.axes(2),y_range)	
set(handles_roi_ts.axes(2),'ytick',y_tick)
figure(handles_roi_ts.gui_fig);

end
