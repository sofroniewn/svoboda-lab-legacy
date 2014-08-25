function p = func_wv_params(base_dir,overwrite)
%%
disp(['--------------------------------------------']);
disp(['EXTRACT WV PARAMS']);

save_path = fullfile(base_dir, 'vid_wv_info.mat');

if overwrite ~= 1 && exist(save_path) == 2
    load(save_path)
else
    %%% Generate whisker vid information
    xml_file_list = dir(fullfile([base_dir '*.xml']));
    xml_file_name = fullfile(base_dir, xml_file_list(1).name);
    whisker_param_file = xmlread(xml_file_name);
    fprintf([xml_file_list(1).name '\n']);
    
    allListitems = whisker_param_file.getElementsByTagName('row');
    thisListitem = allListitems.item(0);
    thisList = thisListitem.getElementsByTagName('frame_rate');
    thisElement = thisList.item(0);
    frame_rate = str2num(char(thisElement.getFirstChild.getData));
    thisList = thisListitem.getElementsByTagName('px2mm'); % frame rate
    thisElement = thisList.item(0);
    pix_per_mm = 1/str2num(char(thisElement.getFirstChild.getData)); % px2mm conversion
    % thisList = thisListitem.getElementsByTagName('face_parameter');
    % thisElement = thisList.item(0);
    % face_parameter = char(thisElement.getFirstChild.getData); % face_parameter
    % thisList = thisListitem.getElementsByTagName('number_of_whiskers');
    % thisElement = thisList.item(0);
    % number_of_whiskers = str2num(char(thisElement.getFirstChild.getData));  % number_of_whiskers
    
    poly_roi_lims = [25 80];
    r_in_mm = 0.1;
    
    vid_file_list = dir([base_dir '*.mp4']);
    vid_file_num = ceil(numel(vid_file_list)/2);
    vid_file_name = fullfile(base_dir, vid_file_list(vid_file_num).name);
    vid_frame = 3;
    vid_file = mmread(vid_file_name,vid_frame);
    
    
    % vid_frames = zeros(vid_file_all.height,vid_file_all.width,vid_file_all.nrFramesTotal,'uint16');
    % for ij = 1:vid_file_all.nrFramesTotal
    % 	vid_frames(:,:,ij) = vid_file_all.frames(ij).cdata(:,:,1);
    % end
    % vid_frame_avg = mean(vid_frames,3);
    vid_frame_avg =  vid_file.frames.cdata(:,:,1);
    
    imagePixelDimsXY = [size(vid_file.frames.cdata,2) size(vid_file.frames.cdata,1)];
    disp(['     Image size =  ' num2str(imagePixelDimsXY)])
    
    vid_frame_avg_c = conv2(double(vid_frame_avg),ones(20,20)/20/20,'same');
    figure(232)
    clf(232)
    set(gcf,'Position', [358   213   809   867]);
    colormap('jet')
    hold on
    imagesc(vid_frame_avg_c)
    set(gca,'ydir','rev');
    xlim([1 size(vid_frame_avg_c,2)]);
    ylim([1 size(vid_frame_avg_c,1)]);
    h = text(.05,.95,'Click nose','FontSize',20,'FontWeight','Bold','Units','Normalized')
    nose = round(ginput(1));
    set(h,'string','Click face')
    head = round(ginput(1));
    % determine head_direction as one of left, right, up, down (i.e. mouse faceing this direction)
    head_axis = nose - head;
    if abs(head_axis(1)) > abs(head_axis(2))
        % in this case mouse facing left or right
        if head_axis(1) > 0
            head_direction = 'rightward';
        else
            head_direction = 'leftward';
        end
    else
        % in this case mouse facing up or down
        if head_axis(2) > 0
            head_direction = 'downward';
        else
            head_direction = 'upward';
        end
    end
    
    % % blank part of image infront of nose
    % switch head_direction
    % 	case 'right'
    % 		vid_frame_avg_c(:,nose(1):end) = 0;
    % 	case 'left'
    % 		vid_frame_avg_c(:,1:nose(1)) = 0;
    % 	case 'up'
    % 		vid_frame_avg_c(1:nose(2),:) = 0;
    % 	case 'down'
    % 		vid_frame_avg_c(nose(2):end,:) = 0;
    % otherwise
    %end
    
    text(.05,.14,['Head facing ' head_direction],'FontSize',20,'FontWeight','Bold','Units','Normalized')
    
    set(h,'string','Type 1 for fullfield otherwise hit enter ')
    fullfield = input('Type 1 for fullfield otherwise hit enter ');
    if isempty(fullfield)
        fullfield = 0;
    elseif fullfield == 1
    else
        error('Unrecgonized option for full field')
    end

    if fullfield
        str = 'Fullfield';
    else
        str = 'Individual whiskers';
    end
    text(.05,.1,str,'FontSize',20,'FontWeight','Bold','Units','Normalized')
    
    set(h,'string','Click face mask')
    face_mask_cords = ginput;
    plot(face_mask_cords(:,1),face_mask_cords(:,2),'k','LineWidth',5)
    
    %%% show face mask
    set(h,'string','Click on approx left whisker origins')
    left_whiskers = ginput;
    text(.05,.06,[num2str(size(left_whiskers,1)) ' left whiskers'],'FontSize',20,'FontWeight','Bold','Units','Normalized')
    plot(left_whiskers(:,1),left_whiskers(:,2),'.b','MarkerSize',45)
    
    if fullfield && size(left_whiskers,1) > 1
        error('Can only have one start location if fullfield')
    end

    set(h,'string','Click on approx right whisker origins')
    right_whiskers = ginput;
    text(.05,.02,[num2str(size(right_whiskers,1)) ' right whiskers'],'FontSize',20,'FontWeight','Bold','Units','Normalized')
    plot(right_whiskers(:,1),right_whiskers(:,2),'.b','MarkerSize',45)

    if fullfield && size(right_whiskers,1) > 1
        error('Can only have one start location if fullfield')
    end

    set(h,'string','Draw left whisker origins')
    left_whisker_pad = ginput;
    plot(left_whisker_pad(:,1),left_whisker_pad(:,2),'r','LineWidth',5)

    set(h,'string','Draw right whisker origins')
    right_whisker_pad = ginput;
    plot(right_whisker_pad(:,1),right_whisker_pad(:,2),'r','LineWidth',5)
    
    set(h,'string','Click twice for minimum whisker length')
    whisker_length = ginput(2);
    plot(whisker_length(:,1),whisker_length(:,2),'b','LineWidth',5)
    
    set(h,'string','Done')
    
    number_of_whiskers = size(left_whiskers,1) + size(right_whiskers,1);
    protract_dir = head_direction;
    face_parameter = cell(number_of_whiskers,1);
    for ij = 1:number_of_whiskers
        if ij <= size(left_whiskers,1)
            switch head_direction
                case 'rightward'
                    face_parameter{ij} = 'bottom';
                case 'leftward'
                    face_parameter{ij} = 'top';
                case 'upward'
                    face_parameter{ij} = 'right';
                case 'downward'
                    face_parameter{ij} = 'left';
                otherwise
            end
        else
            switch head_direction
                case 'rightward'
                    face_parameter{ij} = 'top';
                case 'leftward'
                    face_parameter{ij} = 'bottom';
                case 'upward'
                    face_parameter{ij} = 'left';
                case 'downward'
                    face_parameter{ij} = 'right';
                otherwise
            end
        end
    end
    disp(['     Number of whiskers = ' num2str(number_of_whiskers)])
%    disp(['     Face parameter is ' face_parameter])
    disp(['     Protract direction is ' protract_dir])
    disp(['     Frame rate (hz) =  ' num2str(frame_rate)])
    disp(['     Pix per mm =  ' num2str(pix_per_mm)])
    
    trajectory_nums = [0:(number_of_whiskers-1)];
    
    
    p.base_dir = base_dir;
    p.n_whiskers = number_of_whiskers;
    p.trajectory_nums = trajectory_nums;
    p.frame_rate = frame_rate;
    p.pix_per_mm = pix_per_mm;
    p.face_parameter = face_parameter;
    p.protract_dir = protract_dir;
    p.poly_roi_lims = poly_roi_lims;
    p.r_in_mm = r_in_mm;
    p.vid_file_name = vid_file_name;
    p.vid_file = vid_file;
    p.vid_frame = vid_frame;
    p.imagePixelDimsXY = imagePixelDimsXY;
    p.face_mask_cords = face_mask_cords;
    p.midline = [nose;head];
    p.nLeft = size(left_whiskers,1);
    p.nRight = size(right_whiskers,1);
    p.length_thresh = norm(whisker_length(2,:) - whisker_length(1,:));
    p.fullfield = fullfield;
    p.right_whisker_pad = right_whisker_pad;
    p.left_whisker_pad = left_whisker_pad;

    save_path = fullfile(base_dir, 'vid_wv_info.mat');
    save(save_path,'p')
end

disp(['--------------------------------------------']);
