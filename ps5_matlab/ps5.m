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

%% 2-a

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

%% 2b

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


%% 























