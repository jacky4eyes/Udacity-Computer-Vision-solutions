%% ps5 
clear all; clc;

% first, make sure your current directory is where this script is
% then add to path all functions essential to this project
addpath(genpath('../utilities'));  


%% 1 Lucas Kanade optical flow
% read images
clc;
Shift0 = double(imread('input/TestSeq/Shift0.png'))/255;
ShiftR2 = double(imread('input/TestSeq/ShiftR2.png'))/255;
ShiftR10 = double(imread('input/TestSeq/ShiftR10.png'))/255;
ShiftR20 = double(imread('input/TestSeq/ShiftR20.png'))/255;
ShiftR40 = double(imread('input/TestSeq/ShiftR40.png'))/255;
ShiftR5U5 = double(imread('input/TestSeq/ShiftR5U5.png'))/255;


%% 1a compare base-ShiftR2 and base-Shift2U5

[Ix, Iy] = gaussian_gradient(Shift0, 15, 1);
It_R2 = ShiftR2 - Shift0;

h_R5U5 = fspecial('gauss',15, 1);

Shift0_fil = imfilter(Shift0, h_R5U5);
ShiftR5U5_fil = imfilter(ShiftR5U5, h_R5U5);

It_R5U5 = ShiftR5U5_fil - Shift0_fil ;
ccc = gcf;
delete(ccc.Children);

figure(1);
vl_tightsubplot(2,3,1);
imshow(Shift0)
vl_tightsubplot(2,3,2);
imshow(ShiftR2)
vl_tightsubplot(2,3,3);
imshow(ShiftR5U5)

vl_tightsubplot(2,3,4);
imshow(normalise_img(U_R2))
vl_tightsubplot(2,3,5);
imshow(normalise_img(It_R2))
vl_tightsubplot(2,3,6);
imshow(normalise_img(It_R5U5))

h1 = fspecial('gauss', 25, 9);
[U_R2, V_R2] = solve_LK_flow(Ix,Iy,It_R2,h1);
[U_R5U5, V_R5U5] = solve_LK_flow(Ix,Iy,It_R5U5,h1);

ccc = gcf;
delete(ccc.Children);
plot_optical_flow_displacement(2,U_R2,V_R2)
print(gcf, '-dpng', './output/ps5-1-a-1.png')

ccc = gcf;
delete(ccc.Children);
H = plot_optical_flow_displacement(2,U_R5U5,V_R5U5);
print(gcf, '-dpng', './output/ps5-1-a-2.png')


%% 1b compare 

ShiftR10_fil = imfilter(ShiftR10, h_R5U5);
ShiftR20_fil = imfilter(ShiftR20, h_R5U5);
ShiftR40_fil = imfilter(ShiftR40, h_R5U5);

It_R10 = ShiftR10_fil - Shift0_fil ;
It_R20 = ShiftR20_fil - Shift0_fil ;
It_R40 = ShiftR40_fil - Shift0_fil ;

[U_R10, V_R10] = solve_LK_flow(Ix,Iy,It_R10,h1);
ccc = gcf;
delete(ccc.Children);
plot_optical_flow_displacement(2,U_R10,V_R10)
print(gcf, '-dpng', './output/ps5-1-b-1.png')


[U_R20, V_R20] = solve_LK_flow(Ix,Iy,It_R20,h1);
ccc = gcf;
delete(ccc.Children);
plot_optical_flow_displacement(2,U_R20,V_R20)
print(gcf, '-dpng', './output/ps5-1-b-2.png')


[U_R40, V_R40] = solve_LK_flow(Ix,Iy,It_R40,h1);
ccc = gcf;
delete(ccc.Children);
plot_optical_flow_displacement(2,U_R40,V_R40)
print(gcf, '-dpng', './output/ps5-1-b-3.png')


%% 2 setup

clc
yos_1 = double(imread('input/DataSeq1/yos_img_01.jpg'))/255;
yos_2 = double(imread('input/DataSeq1/yos_img_02.jpg'))/255;
yos_3 = double(imread('input/DataSeq1/yos_img_03.jpg'))/255;

% need to be resized for the pyramid purpose:

yos_1 = yos_1(6:end-6,6:end-6);
yos_2 = yos_2(6:end-6,6:end-6);
yos_3 = yos_3(6:end-6,6:end-6);

%% 2-a REDUCE operator

ccc = gcf;
delete(ccc.Children);
figure(3);
vl_tightsubplot(1,3,1);
imshow(yos_1)
vl_tightsubplot(1,3,2);
imshow(yos_2)
vl_tightsubplot(1,3,3);
imshow(yos_3)

% although it is called "Gaussian pyramid", the kernel introduced by Burt
% and Adelson is actually not a Gaussian function. 
a = 0.4;
c = (0.5-a)/2;
b = (a+2*c)/2;
h = [c b a b c];

[g0,g1,g2,g3] = REDUCE_4_levels(yos_1,h);

ccc = gcf;
delete(ccc.Children);
figure(4);

vl_tightsubplot(1,4,1);
imshow(g0)
vl_tightsubplot(1,4,2);
imshow(g1)
vl_tightsubplot(1,4,3);
imshow(g2)
vl_tightsubplot(1,4,4);
imshow(g3)

print(gcf, '-dpng', './output/ps5-2-a-1.png')

%% 2b  EXPAND operator

g3_1 = EXPAND_1_level(g3,h);
L2 = g2 - g3_1;
g2_1 = EXPAND_1_level(g2,h);
L1 = g1 - g2_1;
g1_1 = EXPAND_1_level(g1,h);
L0 = g0 - g1_1;

ccc = gcf;
delete(ccc.Children);
figure(4);

vl_tightsubplot(1,4,1);
imshow(g3)
vl_tightsubplot(1,4,2);
imshow(L2)
vl_tightsubplot(1,4,3);
imshow(L1)
vl_tightsubplot(1,4,4);
imshow(L0)

print(gcf, '-dpng', './output/ps5-2-b-1.png')


%% 3a try and find a good level for LK flow purposes
% first, the Yosemite sequence LK optical flow result

a = 0.4;
c = (0.5-a)/2;
b = (a+2*c)/2;
h = [c b a b c];

[yos_1_g0, yos_1_g1, yos_1_g2, yos_1_g3] = REDUCE_4_levels(yos_1,h);
[yos_2_g0, yos_2_g1, yos_2_g2, yos_2_g3] = REDUCE_4_levels(yos_2,h);
[yos_3_g0, yos_3_g1, yos_3_g2, yos_3_g3] = REDUCE_4_levels(yos_3,h);

% it turns out that the Gaussian level 0 and level 1 are both acceptable,
% but level 1 has slightly less noise.
im1 = yos_1_g1;
im2 = yos_2_g1;
im3 = yos_3_g1;

[Ix1, Iy1] = gaussian_gradient(im1, 15, 1);
[Ix2, Iy2] = gaussian_gradient(im2, 15, 1);
It12 = im2 - im1;
It23 = im3 - im2;

h3 = fspecial('gauss', 25,3);

[U12, V12] = solve_LK_flow(Ix1,Iy1,It12,h3);
[U23, V23] = solve_LK_flow(Ix2,Iy2,It23,h3);
ccc = gcf;
delete(ccc.Children);
figure(5)
plot_double_optical_flow_displacement(5,U12,V12,U23,V23)

print(gcf, '-dpng', './output/ps5-3-a-1.png')

%% Yosemite sequence warping result

[x_grid,y_grid] = meshgrid(1:size(im1,2),1:size(im1,1));
im2_warped = interp2(x_grid,y_grid,im2,x_grid+U12,y_grid+V12,'*linear');
im2_warped(isnan(im2_warped)) = 0;
seq12_disp = zeros([size(im1) 3]);
seq12_disp(:,:,1) = im2_warped  ;
seq12_disp(:,:,3) = im1;
RMSE12 = mean(mean((im2_warped - im1).^2)).^0.5;

figure(6)
ccc = gcf; delete(ccc.Children);
vl_tightsubplot(1,2,1);
imshow(seq12_disp)
title(sprintf('Img 1 -> Img 2 based on Gaussian level 1; RMSE = %.05f',RMSE12 ))

im3_warped = interp2(x_grid,y_grid,im3,x_grid+U23,y_grid+V23,'*linear');
im3_warped(isnan(im3_warped)) = 0;
seq23_disp = zeros([size(im2) 3]);
seq23_disp(:,:,1) = im3_warped  ;
seq23_disp(:,:,3) = im2;
RMSE23 = mean(mean((im3_warped - im2).^2)).^0.5;

vl_tightsubplot(1,2,2);
imshow(seq23_disp)
title(sprintf('Img 2 -> Img 3 based on Gaussian level 1; RMSE = %.05f',RMSE23 ))

print(gcf, '-dpng', './output/ps5-3-a-2.png')


%% girl-and-dog image set up

clc;

gd0 = double(imread('input/DataSeq2/0.png'))/255;
gd1 = double(imread('input/DataSeq2/1.png'))/255;
gd2 = double(imread('input/DataSeq2/2.png'))/255;

% convert to grayscale
gd0 = mean(gd0,3);
gd1 = mean(gd1,3);
gd2 = mean(gd2,3);

% append image to make its size fit the paradigm; 
gd0(end+1,:) = gd0(end,:);
gd0(:,end+1) = gd0(:,end);
gd1(end+1,:) = gd1(end,:);
gd1(:,end+1) = gd1(:,end);
gd2(end+1,:) = gd2(end,:);
gd2(:,end+1) = gd2(:,end);


ccc = gcf;
delete(ccc.Children);
figure(7)
vl_tightsubplot(1,3,1);
imshow(gd0)
vl_tightsubplot(1,3,2);
imshow(gd1)
vl_tightsubplot(1,3,3);
imshow(gd2)


%% girl-and-dog sequence LK optical flow results

a = 0.4;
c = (0.5-a)/2;
b = (a+2*c)/2;
h = [c b a b c];

[gd0_g0, gd0_g1, gd0_g2, gd0_g3, gd0_g4] = REDUCE_5_levels(gd0,h);
[gd1_g0, gd1_g1, gd1_g2, gd1_g3, gd1_g4] = REDUCE_5_levels(gd1,h);
[gd2_g0, gd2_g1, gd2_g2, gd2_g3, gd2_g4] = REDUCE_5_levels(gd2,h);

% Gauss level 2 is found to be the best granuality for this sequence

im0 = gd0_g2;
im1 = gd1_g2;
im2 = gd2_g2;

[Ix0, Iy0] = gaussian_gradient(im0, 15, 1);
[Ix1, Iy1] = gaussian_gradient(im1, 15, 1);
It01 = im1 - im0;
It12 = im2 - im1;

h3 = fspecial('gauss', 25,3);

[U01, V01] = solve_LK_flow(Ix0,Iy0,It01,h3);
[U12, V12] = solve_LK_flow(Ix1,Iy1,It12,h3);


ccc = gcf;
delete(ccc.Children);
figure(8)
plot_double_optical_flow_displacement(8,U01,V01,U12,V12)
print(gcf, '-dpng', './output/ps5-3-a-3.png')

%% girl-and-dog sequence warping results

[x_grid,y_grid] = meshgrid(1:size(im1,2),1:size(im1,1));

figure(9)
ccc = gcf;
delete(ccc.Children);

im1_warped = interp2(x_grid,y_grid,im1,x_grid+U01,y_grid+V01,'*linear');
im1_warped(isnan(im1_warped)) = 0;
seq01_disp = zeros([size(im1) 3]);
seq01_disp(:,:,1) = im1_warped  ;
seq01_disp(:,:,3) = im0;
RMSE01 = mean(mean((im1_warped - im0).^2)).^0.5;
vl_tightsubplot(1,2,1);
imshow(seq01_disp)
title(sprintf('Img 2 -> Img 3 based on Gaussian level 1; RMSE = %.05f',RMSE01 ))


im2_warped = interp2(x_grid,y_grid,im2,x_grid+U12,y_grid+V12,'*linear');
im2_warped(isnan(im2_warped)) = 0;
seq12_disp = zeros([size(im1) 3]);
seq12_disp(:,:,1) = im2_warped  ;
seq12_disp(:,:,3) = im1;
RMSE12 = mean(mean((im2_warped - im1).^2)).^0.5;
vl_tightsubplot(1,2,2);
imshow(seq12_disp)
title(sprintf('Img 1 -> Img 2 based on Gaussian level 1; RMSE = %.05f',RMSE12 ))
print(gcf, '-dpng', './output/ps5-3-a-4.png')

% The dog's tail's motion is different from other parts of the image; so is
% the girl's right foot
%
% A sensible solution the iterative approach.



%% 4a Hierarchical LK optical flow






