function MM_all = func_reclassify_measurements(M,length_thresh,face_mask_cords,midline,nLeft,nRight)
% %%
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

% length_thresh = 75;
% nLeft = 1;
% nRight = 1;
% face_mask_cords = p.face_mask_cords;
% midline = mean(face_mask_cords(:,2));

%% First eliminate all traces less than length_thresh
M(M(:,4)<length_thresh,:) = [];
%% Eliminate those that start too far left
M(M(:,8)>midline(1,1),:) = [];

%% Eliminate traces which start outside the face_mask_cords
IN = inpolygon(M(:,8),M(:,9),face_mask_cords(:,1),face_mask_cords(:,2));
M(~IN,:) = [];
%% For left & right sides select longest whiskers, and order from back to front
% Go through all frames
nTot = nLeft + nRight;
frames = unique(M(:,2));
MM_all = zeros(nTot*length(frames),11);
MM_all(:,1) = -1;
midline = midline(1,2);

for ij = 1:length(frames)
    M_frame = M(M(:,2)==frames(ij),:);  
    M_frame_left = M_frame(M_frame(:,9) > midline & M_frame(:,11) > midline,:);
    M_frame_right = M_frame(M_frame(:,9) < midline & M_frame(:,11) < midline,:);

        if isempty(M_frame_left) ~= 1 && nLeft > 0
            [Y,I] = sort(M_frame_left(:,6));
            M_frame_left = M_frame_left(I,:);
            num_found = size(M_frame_left,1);
            num_use = min(num_found,nLeft);
            M_frame_left = M_frame_left(1:num_use,:);
            [Y,I] = sort(M_frame_left(:,8));
            M_frame_left = M_frame_left(I,:);
            MM_all(nTot*(ij-1)+[1:num_use],:) = M_frame_left;
            MM_all(nTot*(ij-1)+[1:num_use],1) = [1:num_use] - 1;
        end
    
        if isempty(M_frame_right) ~= 1 && nRight > 0
            [Y,I] = sort(M_frame_right(:,6));
            M_frame_right = M_frame_right(I,:);
            num_found = size(M_frame_right,1);
            num_use = min(num_found,nRight);
            M_frame_right = M_frame_right(1:num_use,:);
            [Y,I] = sort(M_frame_right(:,8));
            M_frame_right = M_frame_right(I,:);
            MM_all(nTot*(ij-1)+ nLeft +[1:num_use],:) = M_frame_right;
            MM_all(nTot*(ij-1)+ nLeft +[1:num_use],1) = nLeft + [1:num_use] - 1;
        end
end

% %%
% figure(3)
% clf(3)
% hold on
% patch(face_mask_cords(:,1),face_mask_cords(:,2),'k')
% plot(MM_all(MM_all(:,1) == 0,8),MM_all(MM_all(:,1) == 0,9),'.r')
% plot(MM_all(MM_all(:,1) == 1,8),MM_all(MM_all(:,1) == 1,9),'.g')
% 
% 
% 
% %%
% figure(4)
% clf(4)
% hold on
% plot(MM_all(:,1))
% 
% %%
%plot(kappa_avg)
%plot(smooth(theta_avg,100))
%
% %%
% 
% figure(45)
% clf(45)
% hold on
% plot(-MM_all(1:2:end,6))
% plot(MM_all(2:2:end,6),'r')
% 
%  %%
% 
% figure(43)
% clf(43)
% hist(M(:,5),150)
% 
% 
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
% 






