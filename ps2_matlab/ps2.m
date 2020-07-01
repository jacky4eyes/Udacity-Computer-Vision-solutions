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

D_L = disparity_ssd(L,R,5);
D_R = disparity_ssd(R,L,5);

figure(2)
subplot(1,2,1)
imshow(-D_L)
subplot(1,2,2)
imshow(D_R-1)


imwrite(-D_L,'./output/ps2-1-a-1.png')
imwrite(D_R-1,'./output/ps2-1-a-2.png')


%% 2-a

clc; 
L = mean(im2double(imread(fullfile('input', 'pair1-L.png'))),3);
R = mean(im2double(imread(fullfile('input', 'pair1-R.png'))),3);


figure(2)
subplot(2,2,1)
imshow(L)
subplot(2,2,2)
imshow(R)
tic;

% Using different window sizes for D_L and D_R
% It is clear that the larger window size, the "smoother" the results,
% which is good for indication of main object groups. However, the edges
% look distorted and some fine/small objects are missing. By contrast, a
% small window size will indicated a lot more small objects and more
% defined edges, with the introduction of more "noises".


D_L = disparity_ssd(L,R,20); 
D_R = disparity_ssd(R,L,10);
t_used = toc;
fprintf('Time used: %.2f s\n',t_used);

subplot(2,2,3)
imshow(-D_L/100)
colormap(gca, jet(256));colorbar;
subplot(2,2,4)
imshow(D_R/100)
colormap(gca, jet(256));colorbar;

D_L_new = floor(max(-D_L,0));
D_R_new = floor(max(D_R,0));
res2a1 = ind2rgb(uint8(D_L_new),jet(100));
imwrite(res2a1,'./output/ps2-2-a-1.png')
res2a2 = ind2rgb(uint8(D_R_new),jet(100));
imwrite(res2a2,'./output/ps2-2-a-2.png')


%% 3-a






