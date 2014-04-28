function update_im_realtime(obj,event,handles)


update_im = get(handles.checkbox_plot_images,'value');
update_shift_plots = get(handles.checkbox_plot_shifts,'value');
contents = cellstr(get(handles.popupmenu_list_plots,'String'));
plot_str = contents{get(handles.popupmenu_list_plots,'Value')};

if update_shift_plots || (update_im && (strcmp(plot_str,'plot_realtime_raw.m') || strcmp(plot_str,'plot_realtime_overlay.m')))
    
    % check memory mat file if new set of planes is there
    %im_raw = rand(512,512,4);
    global mmap_data;
    global old_mmap_frame_num;
    
    if old_mmap_frame_num ~= mmap_data.data(1);
        
        old_mmap_frame_num = mmap_data.data(1);
        
        % If new set of planes is there register each plane in a parfor loop
        global im_session;
        
        %tic
        im_raw = reshape(mmap_data.data(2:end),im_session.ref.im_props.height, im_session.ref.im_props.width, im_session.ref.im_props.numPlanes);
        
        % Look at whether plotting individual image or multiple images
        %plot_planes_str = get(handles.edit_display_planes,'string');
        %plot_planes = eval(plot_planes_str);
        %num_planes = length(plot_planes);
        
        num_planes = im_session.ref.im_props.numPlanes;

        shifts = zeros(2,num_planes);
        corr_2 = zeros(im_session.ref.im_props.height, im_session.ref.im_props.width, num_planes);
        % Extract shifted images, corr_2, and shifts for each plane.
        for ij = 1:num_planes
            %cur_im = mmap_data.data(1 + 1 + (plot_planes(ij) - 1)*im_session.ref.im_props.height*im_session.ref.im_props.width: 1 + (plot_planes(ij))*im_session.ref.im_props.height*im_session.ref.im_props.width);
            %cur_im = reshape(cur_im, im_session.ref.im_props.height, im_session.ref.im_props.width);
            %im_session.realtime.im_raw(:,:,plot_planes(ij),im_session.realtime.ind) = cur_im;
            ref_im = im_session.ref.post_fft{ij};
            [shift_plane corr_2_plane] = register_image_fast(im_raw(:,:,ij),ref_im);
            shifts(:,ij) = shift_plane;
            corr_2(:,:,ij) = corr_2_plane;
            im_adj = func_im_shift(im_raw(:,:,ij),shift_plane);
            im_session.realtime.im_raw(:,:,ij,im_session.realtime.ind) = im_raw(:,:,ij);
            im_session.realtime.im_adj(:,:,ij,im_session.realtime.ind) = im_adj;
        end
        im_session.realtime.ind = im_session.realtime.ind + 1;
        if im_session.realtime.ind > size(im_session.realtime.im_raw,4)
            im_session.realtime.ind = 1;
            im_session.realtime.start = 1;
        end

        plot_planes_str = get(handles.edit_display_planes,'string');
        plot_planes = eval(plot_planes_str);

        corr_vals = mean(corr_2(handles.edges_lateral_displacements+im_session.ref.im_props.height/2,handles.edges_lateral_displacements+im_session.ref.im_props.width/2,plot_planes),3);
        shift_vals = mean(shifts(:,plot_planes),2);
        shift_vals(shift_vals < handles.edges_lateral_displacements(1)) = handles.edges_lateral_displacements(1);
        shift_vals(shift_vals > handles.edges_lateral_displacements(end)) = handles.edges_lateral_displacements(end);
        
        if update_shift_plots == 1
            set(handles.plot_x_hist,'ydata',corr_vals(handles.edges_lateral_displacements(end)+1,:));
            set(handles.axes_x_hist,'ylim',[min(corr_vals(handles.edges_lateral_displacements(end)+1,:))-.01 .01+max(corr_vals(handles.edges_lateral_displacements(end)+1,:))]);
            
            set(handles.plot_y_hist,'xdata',corr_vals(:,handles.edges_lateral_displacements(end)+1));
            set(handles.axes_y_hist,'xlim',[min(corr_vals(:,handles.edges_lateral_displacements(end)+1))-.01 .01+max(corr_vals(:,handles.edges_lateral_displacements(end)+1))]);
            
            set(handles.plot_shift_up,'xdata', [shift_vals(2) shift_vals(2)]);
            set(handles.plot_shift_across,'ydata', [shift_vals(1) shift_vals(1)]);
        end
        
        % If update image / update plot turned on then
        % update shifts / images taking means across planes as required

        if update_im && (strcmp(plot_str,'plot_realtime_raw.m') || strcmp(plot_str,'plot_realtime_adj.m') || strcmp(plot_str,'plot_realtime_overlay.m'))
            [im_data c_lim] = plot_im_gui(handles,0);
            im_plot = get(handles.axes_images,'Children');
            set(handles.axes_images,'clim',c_lim)
            set(im_plot,'CData',im_data)
        end
        %toc
    end
    
    %if update_im == 1 && strcmp(plot_str,'plot_ref_images.m') == 1
    %    [im_data c_lim] = plot_im_gui(handles,0);
    %    im_plot = get(handles.axes_images,'Children');
    %    set(handles.axes_images,'clim',c_lim)
    %    set(im_plot,'CData',im_data)
    %end
    
end

time_elapsed = toc;
time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
set(handles.text_time,'String',time_elapsed_str)

end