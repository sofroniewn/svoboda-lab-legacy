function update_image_converter(obj,event,handles)

overwrite = get(handles.checkbox_overwrite,'value');
global im_conv_session;
cur_files = dir(fullfile(handles.data_dir,'scanimage','summary','*_summary_*.mat'));
im_conv_session.cur_files = cur_files;

if numel(cur_files) > im_conv_session.num_conv+1;
   % try

    cur_file = fullfile(handles.data_dir,'scanimage','summary',cur_files(im_conv_session.num_conv+1).name);
    load(cur_file);
    trial_name = cur_file(end-6:end-4);
    [pathstr, base_name, ext] = fileparts(cur_file);

    % define summary data name
    replace_start = strfind(base_name,'summary');
    replace_end = replace_start+7;
    trial_str = base_name(replace_end:end);
    base_name = base_name(1:replace_start-1);
    type_name = 'registered';

    num_bytes = (im_summary.props.num_frames+4)*4;
    file_name = [base_name type_name trial_str '_bytes' num2str(num_bytes)];
    fname_output = fullfile(handles.output_dir,[file_name '.bin']);
    fid_output = fopen(fname_output,'w');

    for ij = 1:im_summary.props.num_planes
        for ik = 1:im_summary.props.num_chan
            file_name = [base_name type_name trial_str '_p' sprintf('%02d',ij) '_c' sprintf('%02d',ik)];
            registered_file_name = fullfile(handles.data_dir,'scanimage',type_name,[file_name '.bin']); 
            fid_reg = fopen(registered_file_name,'r');
            key_values = fread(fid_reg,[im_summary.props.num_frames+4, im_summary.props.height*im_summary.props.width],'uint16');
            fwrite(fid_output,key_values,'uint16');        
        end
    end

    type_name = 'behaviour';
    file_name = [base_name type_name trial_str];
    behaviour_file_name = fullfile(handles.data_dir,'scanimage',type_name,[file_name '.mat']);
    load(behaviour_file_name);


    corPos = trial_data(:,12)'; % corridor position
    speed = trial_data(:,7)'; % speed
    iti = logical(trial_data(:,3))'; % speed

    speed = round(speed/5)*5/5+1;
    corPos = round(corPos/2)*2/2+1;

    %behaviour_var = [corPos;speed];
    behaviour_var = [corPos];
    behaviour_var(:,iti) = 0;

    x = [1:size(behaviour_var,1)]';
    y = repmat(1,length(x),1);
    z = repmat(999,length(x),1);
    c = repmat(1,length(x),1);
    behaviour_var = [x y z c behaviour_var];
    fwrite(fid_output,behaviour_var','uint16');

    im_conv_session.num_conv = im_conv_session.num_conv + 1;
    set(handles.text_done,'String',['Files converted ' num2str(im_conv_session.num_conv) '/' num2str(numel(cur_files))]); 


  %  catch
  %  end
end

time_elapsed = toc;
time_elapsed_str = sprintf('Time online %.1f s',time_elapsed);
set(handles.text_time,'String',time_elapsed_str)
