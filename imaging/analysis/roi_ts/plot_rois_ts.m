function plot_rois_ts(tRoi)


global session_bv;
global session_ca;
global handles_roi_ts;
global handles_roi_tuning_curve;

if ~isempty(session_ca)
    
    if ~isempty(handles_roi_ts)
        if ishandle(handles_roi_ts.axes)
            roi_id = find(session_ca.roiIds == tRoi.id);
            if ~isempty(roi_id)
                
                scim_frames = logical(session_bv.data_mat(24,:));
                bv_ca_data = session_bv.data_mat(:,scim_frames);
                
                
                x_data = session_ca.time;
                y_data = session_ca.dff(roi_id,:);
                
            else
                display('ROI id not found')
                x_data = session_ca.time;
                y_data = zeros(size(x_data));
                tRoi
            end
            figure(1)
            set(handles_roi_ts.plot_roi,'ydata',y_data)
            set(handles_roi_ts.text_roi,'str',['ROI ' num2str(roi_id)])
            drawnow
            
            if ~isempty(roi_id)
                handles_roi_tuning_curve.roi_id = roi_id;
                handles_roi_tuning_curve.roi_plane = session_ca.roiFOVidx(roi_id);

                plot_rois_summary;
                drawnow
                plot_rois_tuning;
                drawnow
                plot_rois_raster;
                drawnow
            end
            
            
            figure(handles_roi_ts.gui_fig);
            
        end
    end
end