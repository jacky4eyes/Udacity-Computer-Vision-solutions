% ps2

%% 1-a
% Read images

clc;
L = im2double(imread(fullfile('input', 'pair0-L.png')));
R = im2double(imread(fullfile('input', 'pair0-R.png')));
figure(1)
subplot(1,2,1)
imshow(L)
subplot(1,2,2)
imshow(R)

D_L = disparity_ssd(L,R);
D_R = disparity_ssd(R,L);

figure(2)
subplot(1,2,1)
imshow(-D_L)
subplot(1,2,2)
imshow(D_R)

% imwrite(D_L,'./output/ps2-1-a-1.png')
% imwrite(D_R,'./output/ps2-1-a-2.png')


%% 2-a






