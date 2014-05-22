function plot_trial_ts(trial_num)


global session_bv;
global session_ca;
global handles_roi_ts;

if ~isempty(session_ca)
scim_frames = logical(session_bv.data_mat(24,:));
bv_trial_num = session_bv.data_mat(25,scim_frames);

if ~isempty(handles_roi_ts)
    start_time = find(bv_trial_num == trial_num,1,'first');
    end_time = find(bv_trial_num == trial_num,1,'last');
    if ~isempty(start_time) && ~isempty(end_time)
		x_data = [session_ca.time(start_time) session_ca.time(end_time)];
	else
		display(['Trial ' num2str(trial_num) ' not found'])
		x_data = [0 0];
	end
%	figure(1)
	set(handles_roi_ts.plot_trial,'xdata',x_data)
%    figure(handles_roi_ts.gui_fig);
end
end