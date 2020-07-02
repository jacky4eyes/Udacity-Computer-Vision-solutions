% ps2 Read these first

L = mean(im2double(imread(fullfile('input', 'pair1-L.png'))),3);
R = mean(im2double(imread(fullfile('input', 'pair1-R.png'))),3);
L_true = im2double(imread(fullfile('input', 'pair1-D_L.png')));
R_true = im2double(imread(fullfile('input', 'pair1-D_R.png')));


%% 1-a Read dummy images

clc;
L1a = im2double(imread(fullfile('input', 'pair0-L.png')));
R1a = im2double(imread(fullfile('input', 'pair0-R.png')));

figure(1)
subplot(2,2,1)
imshow(L1a)
subplot(2,2,2)
imshow(R1a)

D_L = disparity_ssd(L1a,R1a,5);
D_R = disparity_ssd(R1a,L1a,5);

subplot(2,2,3)
imshow(-D_L)
subplot(2,2,4)
imshow(D_R-1)


imwrite(-D_L,'./output/ps2-1-a-1.png')
imwrite(D_R-1,'./output/ps2-1-a-2.png')


%% 2-a Read real image pairs

clc; 
figure(2)
subplot(2,3,1);imshow(L);
subplot(2,3,4);imshow(R);
subplot(2,3,2);imshow(L_true);
subplot(2,3,5);imshow(R_true);

tic;
D_L = disparity_ssd(L,R,20); 
D_R = disparity_ssd(R,L,10);
t_used = toc;
fprintf('Time used: %.2f s\n',t_used);

subplot(2,3,3);imshow(-D_L/100);
colormap(gca, jet(256));colorbar;
subplot(2,3,6);imshow(D_R/100);
colormap(gca, jet(256));colorbar;

D_L_new = floor(max(-D_L,0));
D_R_new = floor(max(D_R,0));

% res2a1 = ind2rgb(uint8(D_L_new),jet(100));
% imwrite(res2a1,'./output/ps2-2-a-1.png')
% res2a2 = ind2rgb(uint8(D_R_new),jet(100));
% imwrite(res2a2,'./output/ps2-2-a-2.png')


%% 3-a Adding Gaussian noise

clc; 
sigma_3a = 0.1;
L_3a = L+randn(size(L))*(sigma_3a);
R_3a = R+randn(size(R))*(sigma_3a) ;

figure(3)
subplot(2,3,1);imshow(L_3a);
subplot(2,3,4);imshow(R_3a);
subplot(2,3,2);imshow(L_true);
subplot(2,3,5);imshow(R_true);

tic
D_L_3a = disparity_ssd(L_3a,R_3a,20); 
D_R_3a = disparity_ssd(R_3a,L_3a,10);
t_used = toc;
fprintf('Time used: %.2f s\n',t_used);

subplot(2,3,3);imshow(-D_L_3a/120);
subplot(2,3,6);imshow(D_R_3a/120);

D_L_3a_new = floor(max(-D_L_3a,0));
D_R_3a_new = floor(max(D_R_3a,0));

% res3a1 = ind2rgb(uint8(D_L_3a_new),jet(100));
% imwrite(res3a1,'./output/ps2-3-a-1.png')
% res3a2 = ind2rgb(uint8(D_R_3a_new),jet(100));
% imwrite(res3a2,'./output/ps2-3-a-2.png')
 

%% 3-b Increase contrast

clc; 
L_3b = min(L*1.1,1);
R_3b = R;

figure(4)
subplot(2,3,1);imshow(L_3b);
subplot(2,3,4);imshow(R_3b);
subplot(2,3,2);imshow(L_true);
subplot(2,3,5);imshow(R_true);

tic
D_L_3b = disparity_ssd(L_3b,R_3b,20); 
D_R_3b = disparity_ssd(R_3b,L_3b,10);
t_used = toc;
fprintf('Time used: %.2f s\n',t_used);

subplot(2,3,3);imshow(-D_L_3b/140);
subplot(2,3,6);imshow(D_R_3b/140);

D_L_3b_new = floor(max(-D_L_3b,0));
D_R_3b_new = floor(max(D_R_3b,0));

% res3b1 = ind2rgb(uint8(D_L_3b_new),jet(120));
% imwrite(res3b1,'./output/ps2-3-b-1.png')
% res3b2 = ind2rgb(uint8(D_R_3b_new),jet(120));
% imwrite(res3b2,'./output/ps2-3-b-2.png')
 

%% 4-a  Normalised cross-correlation

clc; 
L_4a = L;
R_4a = R;

figure(5)
subplot(2,3,1);imshow(L_4a);
subplot(2,3,4);imshow(R_4a);
subplot(2,3,2);imshow(L_true);
subplot(2,3,5);imshow(R_true);

tic
D_L_4a = disparity_ncorr(L,R,20); 
D_R_4a = disparity_ncorr(R,L,10);
t_used = toc;
fprintf('Time used: %.2f s\n',t_used);

subplot(2,3,3);imshow(-D_L_4a/120);
subplot(2,3,6);imshow(D_R_4a/120);

D_L_4a_new = floor(max(-D_L_4a,0));
D_R_4a_new = floor(max(D_R_4a,0));

% res4a1 = ind2rgb(uint8(D_L_4a_new),jet(80));
% imwrite(res4a1,'./output/ps2-4-a-1.png')
% res4a2 = ind2rgb(uint8(D_R_4a_new),jet(120));
% imwrite(res4a2,'./output/ps2-4-a-2.png')


%% 4-b-1 NCC when adding noises
clc; 
sigma_4b1 = 0.1;
L_4b1 = L+randn(size(L))*(sigma_4b1);
R_4b1 = R+randn(size(R))*(sigma_4b1);

figure(6)
subplot(2,3,1);imshow(L_4b1);
subplot(2,3,4);imshow(R_4b1);
subplot(2,3,2);imshow(L_true);
subplot(2,3,5);imshow(R_true);

tic
D_L_4b1 = disparity_ncorr(L_4b1,R_4b1,20); 
D_R_4b1 = disparity_ncorr(R_4b1,L_4b1,10);
t_used = toc;
fprintf('Time used: %.2f s\n',t_used);

subplot(2,3,3);imshow(-D_L_4b1/120);
subplot(2,3,6);imshow(D_R_4b1/120);

D_L_4b1_new = floor(max(-D_L_4b1,0));
D_R_4b1_new = floor(max(D_R_4b1,0));

% res4b1 = ind2rgb(uint8(D_L_4b1_new),jet(100));
% imwrite(res4b1,'./output/ps2-4-b-1.png')
% res4b2 = ind2rgb(uint8(D_R_4b1_new),jet(100));
% imwrite(res4b2,'./output/ps2-4-b-2.png')


%% 4-b-2 NCC when contrast changes

clc; 
L_4b2 = min(L*1.1,1);
R_4b2 = R;

figure(7)
subplot(2,3,1);imshow(L_4b2);
subplot(2,3,4);imshow(R_4b2);
subplot(2,3,2);imshow(L_true);
subplot(2,3,5);imshow(R_true)

tic
D_L_4b2 = disparity_ncorr(L_4b2,R_4b2,20); 
D_R_4b2 = disparity_ncorr(R_4b2,L_4b2,10);
t_used = toc;
fprintf('Time used: %.2f s\n',t_used);

subplot(2,3,3);imshow(-D_L_4b2/140);
subplot(2,3,6);imshow(D_R_4b2/140);

D_L_4b2_new = floor(max(-D_L_4b2,0));
D_R_4b2_new = floor(max(D_R_4b2,0));

% res4b3 = ind2rgb(uint8(D_L_4b2_new),jet(80));
% imwrite(res4b3,'./output/ps2-4-b-3.png')
% res4b4 = ind2rgb(uint8(D_R_4b2_new),jet(120));
% imwrite(res4b4,'./output/ps2-4-b-4.png')


%% 5-a experiment with "pair2"

L_pair2 = mean(im2double(imread(fullfile('input', 'pair2-L.png'))),3);
R_pair2 = mean(im2double(imread(fullfile('input', 'pair2-R.png'))),3);
L_pari2_true = im2double(imread(fullfile('input', 'pair2-D_L.png')));
R_pair2_true = im2double(imread(fullfile('input', 'pair2-D_R.png')));

figure(8)
subplot(2,4,1);imshow(L_pair2);
subplot(2,4,5);imshow(R_pair2);
subplot(2,4,2);imshow(L_pari2_true);
subplot(2,4,6);imshow(R_pair2_true);


%%
tic
D_L_5 = disparity_ssd(L_pair2,R_pair2,20); 
D_R_5 = disparity_ssd(R_pair2,L_pair2,10);
t_used = toc;
fprintf('Time used: %.2f s\n',t_used);

%%
tic
D_L_5b = disparity_ncorr(L_pair2,R_pair2,20); 
D_R_5b = disparity_ncorr(R_pair2,L_pair2,10);
t_used = toc;
fprintf('Time used: %.2f s\n',t_used);


%%
subplot(2,4,3);imshow(-D_L_5/120);
subplot(2,4,7);imshow(D_R_5/120);
subplot(2,4,4);imshow(-D_L_5b/120);
subplot(2,4,8);imshow(D_R_5b/120);

D_L_5a_new = floor(max(-D_L_5,0));
D_R_5a_new = floor(max(D_R_5,0));
D_L_5b_new = floor(max(-D_L_5b,0));
D_R_5b_new = floor(max(D_R_5b,0));


res5a1 = ind2rgb(uint8(D_L_5a_new),jet(120));imwrite(res5a1 ,'./output/ps2-5-a-1.png');
res5a2 = ind2rgb(uint8(D_R_5a_new),jet(120));imwrite(res5a2,'./output/ps2-5-a-2.png');
res5b1 = ind2rgb(uint8(D_L_5b_new),jet(80));imwrite(res5b1 ,'./output/ps2-5-b-1.png');
res5b2 = ind2rgb(uint8(D_R_5b_new),jet(130));imwrite(res5b2,'./output/ps2-5-b-2.png');






