%% Part 1 : Harris corners

transA = double(imread('./input/transA.jpg'))/255;
transB = double(imread('./input/transB.jpg'))/255;
simA =  double(imread('./input/simA.jpg'))/255;
simB =  double(imread('./input/simB.jpg'))/255;

g_size = 7;
sigma = 1.5;

[transA_x, transA_y] = gaussian_gradient(transA,g_size,sigma);
[transB_x, transB_y] = gaussian_gradient(transB,g_size,sigma);
[simA_x, simA_y] = gaussian_gradient(simA,win_size,sigma);
[simB_x, simB_y] = gaussian_gradient(simB,win_size,sigma);

%% 1-a  gradient images

% convert to [0, 1] for display
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

transA_disp_combined = [transA_x_disp transA_x_disp];
imwrite(transA_disp_combined,'./output/ps4-1-a-1.png')

simA_disp_combined = [simA_x_disp simA_x_disp];
imwrite(simA_disp_combined,'./output/ps4-1-a-2.png')


%% 1-b  R value images

w_size = 7;
w_sigma = 1.2;
W = fspecial('gaussian',w_size,w_sigma);

transA_Mmat = make_M_Matrix(transA_x,transA_y,W);
transB_Mmat = make_M_Matrix(transB_x,transB_y,W);
simA_Mmat = make_M_Matrix(simA_x,simA_y,W);
simB_Mmat = make_M_Matrix(simB_x,simB_y,W);

transA_Rmat = calc_harris(transA_Mmat,0.04);
simA_Rmat = calc_harris(simA_Mmat,0.04);
transB_Rmat = calc_harris(transB_Mmat,0.04);
simB_Rmat = calc_harris(simB_Mmat,0.04);

transA_Rmat_disp = rescale_Rmat(transA_Rmat);
transB_Rmat_disp = rescale_Rmat(transB_Rmat);
simA_Rmat_disp = rescale_Rmat(simA_Rmat);
simB_Rmat_disp = rescale_Rmat(simB_Rmat);

figure(2);
subplot(2,2,1);axis tight
imshow(transA_Rmat_disp )
subplot(2,2,2);axis tight
imshow(simA_Rmat_disp)
subplot(2,2,3);axis tight
imshow(transB_Rmat_disp )
subplot(2,2,4);axis tight
imshow(simB_Rmat_disp)


imwrite(transA_Rmat_disp,'./output/ps4-1-b-1.png')
imwrite(transB_Rmat_disp,'./output/ps4-1-b-2.png')
imwrite(simA_Rmat_disp,'./output/ps4-1-b-3.png')
imwrite(simB_Rmat_disp,'./output/ps4-1-b-4.png')


%% 1-c not-local-maxima suppression and marking corners

local_size = 9;
transA_Rsup = local_nonmax_suppress(transA_Rmat, local_size);
simA_Rsup = local_nonmax_suppress(simA_Rmat, local_size);
transB_Rsup = local_nonmax_suppress(transB_Rmat, local_size);
simB_Rsup = local_nonmax_suppress(simB_Rmat, local_size);

transA_newdisp = mark_corners(transA,transA_Rsup);
simA_newdisp = mark_corners(simA,simA_Rsup);
transB_newdisp = mark_corners(transB,transB_Rsup);
simB_newdisp = mark_corners(simB,simB_Rsup);

figure(4)

subplot(2,2,1);axis tight
imshow(transA_newdisp)
subplot(2,2,2);axis tight
imshow(simA_newdisp)

subplot(2,2,3);axis tight
imshow(transB_newdisp)
subplot(2,2,4);axis tight
imshow(simB_newdisp)

imwrite(transA_newdisp,'./output/ps4-1-c-1.png')
imwrite(transB_newdisp,'./output/ps4-1-c-2.png')
imwrite(simA_newdisp,'./output/ps4-1-c-3.png')
imwrite(simB_newdisp,'./output/ps4-1-c-4.png')


%%

















