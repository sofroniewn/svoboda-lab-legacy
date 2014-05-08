function [im_data clim_data] = plot_im_gui(handles,plot_on)

	global im_session;
	c_lim = zeros(1,2);
    c_lim(1) = round(get(handles.slider_look_up_table_black,'Value'));
    c_lim(2) = round(get(handles.slider_look_up_table,'Value'));
    c_lim_overlay = round(get(handles.slider_overlay,'Value'));

    plot_planes_str = get(handles.edit_display_planes,'string');
    plot_planes = eval(plot_planes_str);
    plot_names =  get(handles.popupmenu_list_plots,'string');
    plot_val =  get(handles.popupmenu_list_plots,'value');
    plot_function = plot_names{plot_val};
    trial_num = get(handles.slider_trial_num,'Value');
    chan_num = str2double(get(handles.edit_display_chan,'String'));
    prev_ref = get(handles.popupmenu_ref_selector,'Value')-1;
    if prev_ref 
        ref = im_session.prev_ref;
    else
        ref = im_session.ref;        
    end

    roi_draw_mode = get(handles.togglebutton_draw_rois,'Value');
%    if roi_draw_mode
%        plot_planes = plot_planes(1);

    plot_str = ['[im_data clim_data cmap_str] = ' plot_function(1:end-2) '(im_session,ref,trial_num,chan_num,plot_planes,c_lim,c_lim_overlay);'];
    eval(plot_str);

roi_draw_mode = get(handles.togglebutton_draw_rois,'Value');
if plot_on == 1
    if roi_draw_mode
    if isfield(im_session,'prev_ref')
        if isfield(im_session.prev_ref,'roi_array')
            for ik = 1:im_session.prev_ref.im_props.numPlanes
                if sum(im_session.prev_ref.roi_array{ik}.guiHandles)>0
                    im_session.prev_ref.roi_array{ik}.closeGui;
                end
            end
        end
    end
    if isfield(im_session.ref,'roi_array')
        for ik = 1:im_session.ref.im_props.numPlanes
            if sum(im_session.ref.roi_array{ik}.guiHandles)>0
                im_session.ref.roi_array{ik}.closeGui;
            end
        end
    end
        set(handles.togglebutton_draw_rois,'Value',0);
    end
    axes(handles.axes_images);
    hold off
    imagesc(im_data,clim_data)
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    axis equal
else
    if roi_draw_mode == 0
        im_plot = get(handles.axes_images,'Children');
        set(handles.axes_images,'clim',clim_data)
        set(im_plot,'CData',im_data)
    else
        if isempty(ref.roi_array{plot_planes}.guiHandles)
            ref.roi_array{plot_planes}.startGui;
        end
        im_data = single(im_data);
        if ndims(im_data) == 3
            %im_data = clim_data(2)*mean(im_data,3);
        else
            im_data = (im_data - clim_data(1))/clim_data(2);
            im_data(im_data>1) = 1;
            im_data(im_data<0) = 0;
        end
        ref.roi_array{plot_planes}.workingImage = im_data;
        ref.roi_array{plot_planes}.updateImage();
    end
end

%set(handles.axes_images,'TightInset',[0.0364    0.0292    0.0056    0.0069])
colormap(gca,cmap_str);

colorbar_val = get(handles.uitoggletool4,'State');
if strcmp(colorbar_val,'on')
    colorbar
    if strcmp(plot_function,'plot_spark_regression_tune.m')
        num_ticks = 6;
        cur_ind = im_session.spark_output.regressor.cur_ind;
        range_vals = im_session.spark_output.regressor.range{cur_ind};
        %c_range = get(handles.cbar_axes,'Ylim');        
        %tick_vals = linspace(c_range(1),c_range(2),num_ticks);
        tick_labels = linspace(range_vals(1),range_vals(2),num_ticks);
        set(handles.cbar_axes,'Ytick',tick_labels)
        set(handles.cbar_axes,'Yticklabel',tick_labels)
        %set(handles.cbar_axes,'Ylim',[min(vals) max(vals)])
    end
end


end