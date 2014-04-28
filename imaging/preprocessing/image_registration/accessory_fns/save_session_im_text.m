function save_session_im_text(save_path,num_files,analyze_chan,down_sample,imaging_on,behaviour_on,handles)

global im_session;
full_trial_data = [];
dat = [];
trial_data = [];
num_planes = im_session.ref.im_props.numPlanes;

if down_sample > 1
    frame_nums = im_session.reg.nFrames(1:num_files);
    frame_nums = ceil(frame_nums/down_sample);
    num_frames = sum(frame_nums);
    ds_filter = ones(down_sample,1)/down_sample;
else
    num_frames = sum(im_session.reg.nFrames(1:num_files));
end
num_pixels = im_session.ref.im_props.height*im_session.ref.im_props.width;

full_im_dat = cell(num_planes,1);
im_cords = cell(num_planes,1);

for ij = 1:num_planes
    full_im_dat{ij} = zeros(num_frames,num_pixels,'uint16');
    im_cords{ij} = zeros(4,num_pixels,'uint16');
end


if behaviour_on
    global session;
end
start_ind = 1;
% --- extract data
for ij = 1:num_files
    if ~isempty(handles)
        drawnow
        if ~get(handles.togglebutton_gen_text,'Value');
            error('Break')
        end
    end
    
    fprintf('(text)  file %g/%g ',ij,num_files);
    
    if imaging_on
        fprintf(' images ');
        % load registered data
        cur_file = fullfile(im_session.basic_info.data_dir,im_session.basic_info.cur_files(ij).name);
        for iPlane = 1:num_planes
            [keys values] = read_aligned_images(cur_file,iPlane,analyze_chan,down_sample);
            im_cords{iPlane} = keys;
            num_frame_file = size(values,1);
            full_im_dat{iPlane}(start_ind:start_ind+num_frame_file-1,:) = values;
        end
        start_ind = start_ind+num_frame_file;
    end
    
    if behaviour_on
        fprintf(' behaviour ');
        trial_num_session = im_session.reg.behaviour_scim_trial_align(ij);
        trial_data_raw = session.data{trial_num_session};
        scim_frame_trig = session.data{trial_num_session}.processed_matrix(7,:);
        [trial_data data_variable_names] = parse_behaviour2im(trial_data_raw,trial_num_session,scim_frame_trig);
        if down_sample > 1;
            trial_data = uint16(conv2(single(trial_data),ds_filter,'same'));
            trial_data = trial_data(1:down_sample:end,:);
        end
        
        if size(trial_data,1) ~= num_frame_file && imaging_on
            error('Synchronization scim/behaviour error')
        end
        full_trial_data = cat(1,full_trial_data,trial_data);
    end
    fprintf('\n');
end

fprintf('(text)  writing\n');

if imaging_on
    if start_ind ~= num_frames+1
        error('Wrong number of frames');
    end
    tSize = size(full_im_dat{1},1);
    % parse the info
    for iPlane = 1:num_planes
        save_path_im = fullfile(save_path,['Text_images_p' sprintf('%02d',iPlane) '_c' sprintf('%02d',analyze_chan) '.txt']);
        % write to text
        f = fopen(save_path_im,'w');
        fmt = repmat('%u ',1,tSize+3);
        fprintf(f,[fmt,'%u\n'],[im_cords{iPlane};full_im_dat{iPlane}]);
        fclose(f);
    end
end

if behaviour_on
    save_path_bv = fullfile(save_path,['Text_behaviour.mat']);
    save(save_path_bv,'data_variable_names','full_trial_data');
end

fprintf('(text)  DONE\n');

