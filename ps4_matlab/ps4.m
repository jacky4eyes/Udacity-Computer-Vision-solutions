%% Part 1 : Harris corners

transA = double(imread('./input/transA.jpg'))/255;
simA =  double(imread('./input/simA.jpg'))/255;

g_size = 7;
sigma = 1.5;

[transA_x, transA_y] = gaussian_gradient(transA,g_size,sigma);
[simA_x, simA_y] = gaussian_gradient(simA,win_size,sigma);

% convert to [0, 1]
transA_x_disp = transA_x+0.5;
transA_y_disp = transA_y+0.5;
simA_x_disp = simA_x+0.5;
simA_y_disp = simA_y+0.5;

figure(1);delete(gca);delete(gca);
subplot(2,3,1);hold on;axis tight
imshow(transA)
subplot(2,3,2);hold on;axis tight
imshow(transA_x_disp)
subplot(2,3,3);hold on;axis tight
imshow(transA_y_disp )


subplot(2,3,4);hold on;axis tight
imshow(simA)
subplot(2,3,5);hold on;axis tight
imshow(simA_x_disp )
subplot(2,3,6);hold on;axis tight
imshow(simA_y_disp)

%% a
transA_disp_combined = [transA_x_disp transA_x_disp];
imwrite(transA_disp_combined,'./output/ps4-1-a-1.png')

simA_disp_combined = [simA_x_disp simA_x_disp];
imwrite(simA_disp_combined,'./output/ps4-1-a-2.png')


%% b

w_size = 7;
w_sigma = 1.2;
W = fspecial('gaussian',w_size,w_sigma);

transA_xx = transA_x.^2;
transA_yy = transA_y.^2;
transA_xy = transA_x.*transA_y;

imfilter(transA_xx ,W);















