function MM = func_reclassify_measurements(M,p)
%     1.  whisker identity (-1:other, 0,1,2...:Whiskers)
%     2.  time (frame #)
%     3.  segment id
%     4.  length (px)
%     5.  tracing score
%     6.  angle at follicle (degrees)
%     7.  mean curvature (1/px)
%     8.  follicle position: x (px)
%     9.  follicle position: y (px)
%     10. tip position: x (px)
%     11. tip position: y (px)

if p.fullfield
    switch p.protract_dir
        case 'rightward'
            midline_val = mean(p.midline(:,2));
            M(M(:,9)<=midline_val,1) = 0; % for left whiskers
            M(M(:,9)>midline_val,1) = 1; % for right whiskers
            M(M(:,8)>p.midline(1,1),1) = -1; % starts beyone nose
        case 'leftward'
            midline_val = mean(p.midline(:,2));
            M(M(:,9)>midline_val,1) = 0; % for left whiskers
            M(M(:,9)<=midline_val,1) = 1; % for right whiskers
            M(M(:,8)<p.midline(1,1),1) = -1; % starts beyone nose
        case 'upward'
            midline_val = mean(p.midline(:,1));
            M(M(:,8)<=midline_val,1) = 0; % for left whiskers
            M(M(:,8)>midline_val,1) = 1; % for right whiskers
            M(M(:,9)<p.midline(1,2),1) = -1; % starts beyone nose
       case 'downward'
            midline_val = mean(p.midline(:,1));
            M(M(:,8)>midline_val,1) = 0; % for left whiskers
            M(M(:,8)<=midline_val,1) = 1; % for right whiskers
            M(M(:,9)>p.midline(1,2),1) = -1; % starts beyone nose
        otherwise
    end
    %%% Eliminates all traces less than length_thresh
    M(M(:,4)<p.length_thresh,1) = -1; 
    %%% Eliminate traces which start outside the whisker pad polygons
    IN_right = inpolygon(M(:,8),M(:,9),p.right_whisker_pad(:,1),p.right_whisker_pad(:,2));
    IN_left = inpolygon(M(:,8),M(:,9),p.left_whisker_pad(:,1),p.left_whisker_pad(:,2));
    M(~IN_right & M(:,1) == 1,1) = -1;
    M(~IN_left & M(:,1) == 0,1) = -1;

    nTot = p.nLeft + p.nRight;
    frames = unique(M(:,2));
    MM = zeros(nTot*length(frames),11);
    MM(:,1) = -1;
    for ij = 1:length(frames)
        M_frame = M(M(:,2)==frames(ij),:);  
        M_frame_left = M_frame(M_frame(:,1) == 0,:);
        M_frame_right = M_frame(M_frame(:,1) == 1,:);

        ind_offset = 1;
        if p.nLeft > 0
            MM(nTot*(ij-1)+ind_offset,:) = mean(M_frame_left,1);
            ind_offset = ind_offset + 1;
        end

        if p.nRight > 0
            MM(nTot*(ij-1)+ind_offset,:) = mean(M_frame_right,1);
        end
    end

    MM(MM(:,1)==1,6) = -MM(MM(:,1)==1,6);
else
    error('Non fullfield not implemented')
end
% %% For left & right sides select longest whiskers, and order from back to front
% % Go through all frames
% nTot = p.nLeft + p.nRight;
% frames = unique(M(:,2));
% MM_all = zeros(nTot*length(frames),11);
% MM_all(:,1) = -1;
% for ij = 1:length(frames)
%     M_frame = M(M(:,2)==frames(ij),:);  
%     M_frame_left = M_frame(M_frame(:,1) == 0,:);
%     M_frame_right = M_frame(M_frame(:,1) == 1,:);

%         % if isempty(M_frame_left) ~= 1 && nLeft > 0
%         %     [Y,I] = sort(M_frame_left(:,6));
%         %     M_frame_left = M_frame_left(I,:);
%         %     num_found = size(M_frame_left,1);
%         %     num_use = min(num_found,nLeft);
%         %     M_frame_left = M_frame_left(1:num_use,:);
%         %     [Y,I] = sort(M_frame_left(:,8));
%         %     M_frame_left = M_frame_left(I,:);
%         %     MM_all(nTot*(ij-1)+[1:num_use],:) = M_frame_left;
%         %     MM_all(nTot*(ij-1)+[1:num_use],1) = [1:num_use] - 1;
%         % end
    
%         % if isempty(M_frame_right) ~= 1 && nRight > 0
%         %     [Y,I] = sort(M_frame_right(:,6));
%         %     M_frame_right = M_frame_right(I,:);
%         %     num_found = size(M_frame_right,1);
%         %     num_use = min(num_found,nRight);
%         %     M_frame_right = M_frame_right(1:num_use,:);
%         %     [Y,I] = sort(M_frame_right(:,8));
%         %     M_frame_right = M_frame_right(I,:);
%         %     MM_all(nTot*(ij-1)+ nLeft +[1:num_use],:) = M_frame_right;
%         %     MM_all(nTot*(ij-1)+ nLeft +[1:num_use],1) = nLeft + [1:num_use] - 1;
%         % end
% end




% %%
% figure(3)
% clf(3)
% set(gca,'ydir','rev')
% hold on
% patch(p.face_mask_cords(:,1),p.face_mask_cords(:,2),'k')
% %plot(M(:,8),M(:,9),'.r')
% %plot(M(:,10),M(:,11),'.g')
% plot(M(M(:,1) == -1,8),M(M(:,1) == -1,9),'.b')
% plot(M(M(:,1) == 0,8),M(M(:,1) == 0,9),'.r')
% plot(M(M(:,1) == 1,8),M(M(:,1) == 1,9),'.g')

% ylim([0 640])
% xlim([0 480])

% figure(3)
% clf(3)
% set(gca,'ydir','rev')
% hold on
% patch(p.face_mask_cords(:,1),p.face_mask_cords(:,2),'k')
% %plot(M(:,8),M(:,9),'.r')
% %plot(M(:,10),M(:,11),'.g')
% plot(MM_all(MM_all(:,1) == 0,8),MM_all(MM_all(:,1) == 0,9),'.r')
% plot(MM_all(MM_all(:,1) == 1,8),MM_all(MM_all(:,1) == 1,9),'.g')
% ylim([0 640])
% xlim([0 480])


% %%
% figure(4)
% clf(4)
% hold on
% plot(MM_all(:,1))

% %%
% plot(kappa_avg)
% plot(smooth(theta_avg,100))

% %%

% figure(45)
% clf(45)
% hold on
% %plot(MM_all(1:2:end,6))
% plot(-MM_all(2:2:end,7),'r')

%  %%

% figure(43)
% clf(43)
% hist(M(:,5),150)


% %% Set length threshold
% figure(8)
% clf(8)
% hold on
% hist(M(:,4),100)
% %% Set follicle y position threshold
% figure(8)
% clf(8)
% hold on
% hist(M(M(:,4)>75,9),100)
% %% Set follicle x position threshold
% figure(8)
% clf(8)
% hold on
% hist(M(M(:,4)>75,8),100)
% %% Set tip y position threshold
% figure(8)
% clf(8)
% hold on
% hist(M(M(:,4)>75,11),100)







