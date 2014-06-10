%% ISI ANALYSIS
overview = imread('/Volumes/svoboda/users/Sofroniewn/WGNR_DATA/anm_0248792/ISI/overview.tif');
c2 = imread('/Volumes/svoboda/users/Sofroniewn/WGNR_DATA/anm_0248792/ISI/d1.tif');
c1 = imread('/Volumes/svoboda/users/Sofroniewn/WGNR_DATA/anm_0248792/ISI/c1.tif');
overview = overview(31:end-56,83:end-82,:);


%%
I = imrotate(overview(:,:,1),180);
c2_I = imrotate(c2(:,:,1),180);
c1_I = imrotate(c1(:,:,1),180);
J = repmat(I,[1 1 3]);
J(:,:,1) = 255 - c2_I;
J(:,:,2) = 255 - c1_I;

figure(32)
subplot(2,2,1)
imshow(I)
title('Anm 0140946 111213')
subplot(2,2,2)
imshow(J)
title('OVERLAY')
subplot(2,2,3)
imshow(c2_I)
title('ISI C2')
subplot(2,2,4)
imshow(c1_I)
title('ISI C1')


