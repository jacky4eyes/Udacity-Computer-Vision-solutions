%% project a point from 3D to 2D using a matrix operation

p = [200 100 50];
f = 50;
% disp(project_point(p, f));

a1 = [1 0 0]';
a2 = [0 1 0]';
A = [a1 a2];
P_mat = A*inv(A'*A)*A'


%% 

hsize1 = 11.*[1 1];
sigma1 = 2;
h1 = fspecial('gaussian',hsize1,sigma1);
figure(1)

im_L = double(imread('IMG_1283.jpg'))/255.0;
im_L_gray = mean(im_L,3);
im_L_gray_smooth = imfilter(im_L_gray, h1);
im_L_gray_smooth = im_L_gray_smooth(1:2:end,1:2:end);
subplot(1,2,1)
imshow(im_L_gray_smooth);
im_R = double(imread('IMG_1284.jpg'))/255.0;
im_R_gray = mean(im_R,3);
im_R_gray_smooth = imfilter(im_R_gray, h1);
im_R_gray_smooth = im_R_gray_smooth(1:2:end,1:2:end);

subplot(1,2,2)
imshow(im_R_gray_smooth);

%%
clc;

patch_row = 900;
b = 200;   % block size
strip_L = im_L_gray_smooth(patch_row:(patch_row+b-1),:);
strip_R = im_R_gray_smooth(patch_row:(patch_row+b-1),:);
figure(2)
subplot(3,1,1)
imshow(strip_L)
subplot(3,1,2)
imshow(strip_R)


%%
clc;
disparity = match_strips(strip_L,strip_R,b);

%%

subplot(3,1,3)
plot(disparity)

%%
patch_L = im_L_gray_smooth(patch_loc(1):(patch_loc(1)+patch_size(1)-1),patch_loc(2):(patch_loc(2)+patch_size(2)-1));
% patch_L = patch_L ./ sum(sum(patch_L));

strip_R = im_R_gray_smooth(patch_loc(1):(patch_loc(1)+patch_size(1)-1),:);


[y, best_x, best_patch] = find_best_match(patch_L,strip_R);










