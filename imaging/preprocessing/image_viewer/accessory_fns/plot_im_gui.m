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
    %axes(handles.axes_images)
    plot_str = ['[im_data clim_data] = ' plot_function(1:end-2) '(handles.axes_images,handles.cbar_axes,im_session,ref,trial_num,chan_num,plot_planes,c_lim,c_lim_overlay,plot_on);'];
    eval(plot_str);


end