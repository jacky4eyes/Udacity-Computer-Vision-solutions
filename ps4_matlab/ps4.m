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

figure(1);delete(gca) % remove all overlayed contents on figure (speed up)
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

figure(2); delete(gca);
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

local_size = 11;
transA_Rsup = local_nonmax_suppress(transA_Rmat, local_size);
simA_Rsup = local_nonmax_suppress(simA_Rmat, local_size);
transB_Rsup = local_nonmax_suppress(transB_Rmat, local_size);
simB_Rsup = local_nonmax_suppress(simB_Rmat, local_size);

transA_newdisp = mark_corners(transA,transA_Rsup);
simA_newdisp = mark_corners(simA,simA_Rsup);
transB_newdisp = mark_corners(transB,transB_Rsup);
simB_newdisp = mark_corners(simB,simB_Rsup);

figure(4); delete(gca);

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


%% Part 2: SIFT descriptor 
% 2-a plot the assigned orientation

transA_grad_dir = atan2(transA_y,transA_x);
transB_grad_dir = atan2(transB_y,transB_x);

transA_fc = prep_fc_for_sift(transA_Rsup,transA_grad_dir,8);
transB_fc = prep_fc_for_sift(transB_Rsup,transB_grad_dir,8);

[transA_f,transA_d] = vl_sift(single(transA*255),'frames',transA_fc);
[transB_f,transB_d] = vl_sift(single(transB*255),'frames',transB_fc);

figure(5); delete(gca);
tightsubplot(1,2,1);
imshow(transA)
h = vl_plotframe(transA_f); set(h,'color','cyan','linewidth',1) ;
tightsubplot(1,2,2);
imshow(transB)
h = vl_plotframe(transB_f); set(h,'color','cyan','linewidth',1) ;

print(gcf, '-dpng', './output/ps4-2-a-1.png')


simA_grad_dir = atan2(simA_y,simA_x);
simB_grad_dir = atan2(simB_y,simB_x);

simA_fc = prep_fc_for_sift(simA_Rsup,simA_grad_dir,8);
simB_fc = prep_fc_for_sift(simB_Rsup,simB_grad_dir,8);

[simA_f,simA_d] = vl_sift(single(simA*255),'frames',simA_fc);
[simB_f,simB_d] = vl_sift(single(simB*255),'frames',simB_fc);

figure(6); delete(gca);
tightsubplot(1,2,1);
imshow(simA)
h = vl_plotframe(simA_f); set(h,'color','cyan','linewidth',1) ;
tightsubplot(1,2,2);
imshow(simB)
h = vl_plotframe(simB_f); set(h,'color','cyan','linewidth',1) ;

print(gcf, '-dpng', './output/ps4-2-a-2.png')


%% 2-b find putative matches

[trans_matches,trans_scores] = vl_ubcmatch(transA_d,transB_d);
trans_combined = [transA transB];
figure(7); delete(gca);
tightsubplot(1,1,1);
imshow(trans_combined)
hold on
for i = 1:size(trans_matches,2)
    plot([transA_fc(1,trans_matches(1,i)) size(transA,2)+transB_fc(1,trans_matches(2,i))],...
    [transA_fc(2,trans_matches(1,i)) transB_fc(2,trans_matches(2,i))],'cyan','linewidth',1);
end

print(gcf, '-dpng', './output/ps4-2-b-1.png')

[sim_matches,sim_scores] = vl_ubcmatch(simA_d,simB_d);
sim_combined = [simA simB];

figure(8); delete(gca);
tightsubplot(1,1,1);
imshow(sim_combined)
hold on
for i = 1:size(sim_matches,2)
    plot([simA_fc(1,sim_matches(1,i)) size(simA,2)+simB_fc(1,sim_matches(2,i))],...
    [simA_fc(2,sim_matches(1,i)) simB_fc(2,sim_matches(2,i))],'cyan','linewidth',1);
end

print(gcf, '-dpng', './output/ps4-2-b-2.png')

%% Part 3: RANSAC
% 3-a the translation image pair
clc;
desired_success_rate = 0.998;
outlier_rate = 0.9;
dist_cutoff = 15;
all_dx = transB_f(1,trans_matches(2,:)) - transA_f(1,trans_matches(1,:));
all_dy = transB_f(2,trans_matches(2,:)) - transA_f(2,trans_matches(1,:));
all_dX = [all_dx; all_dy];

% the elements of C is the index for trans_matches
C = RANSAC_translation(all_dX,outlier_rate,desired_success_rate,dist_cutoff);
avg_trans= mean(all_dX(:,C),2);

figure(9); delete(gca);tightsubplot(1,1,1);
imshow(trans_combined)
hold on
for i = 1:size(C,2)
    plot([transA_fc(1,trans_matches(1,C)); size(transA,2)+transB_fc(1,trans_matches(2,C))],...
    [transA_fc(2,trans_matches(1,C)); transB_fc(2,trans_matches(2,C))],'yellow','linewidth',2);
end
title(sprintf('average translation vector: (%f, %f)',avg_trans(1),avg_trans(2)));
print(gcf, '-dpng', './output/ps4-3-a-1.png')


figure(88);
scatter(all_dx,all_dy,100,'.')
grid on;

print(gcf, '-dpng', './output/trans_pair_dxdy_scatter.png')




%% 3-b the similarity image pair
clc;
desired_success_rate = 0.995;
outlier_rate = 0.8;
dist_cutoff = 9;

C = RANSAC_similarity(simA_fc,simB_fc,sim_matches, outlier_rate, desired_success_rate, dist_cutoff);

X = simA_fc(1:2,sim_matches(1,C));
X_prime = simB_fc(1:2,sim_matches(2,C));
p = solve_similarity_params(X, X_prime);
sim_mat = [1+p(3) -p(4) p(1); p(4) 1+p(3) p(2)];


figure(10); delete(gca);tightsubplot(1,1,1);
imshow(sim_combined)
hold on
for i = 1:size(C,2)
    plot([simA_fc(1,sim_matches(1,C)); size(simA,2)+simB_fc(1,sim_matches(2,C))],...
    [simA_fc(2,sim_matches(1,C)); simB_fc(2,sim_matches(2,C))],'yellow','linewidth',2);
end
title(sprintf('Consensus set''s similarity vector: (%f, %f, %f, %f)',p(1),p(2),p(3),p(4)));
print(gcf, '-dpng', './output/ps4-3-b-1.png')


%% 3-c fit affine transform on the similarity images pair

desired_success_rate = 0.995;
outlier_rate = 0.9;
dist_cutoff = 15;

C = RANSAC_affine(simA_fc,simB_fc,sim_matches, outlier_rate,...
    desired_success_rate, dist_cutoff);

X = simA_fc(1:2,sim_matches(1,C));
X_prime = simB_fc(1:2,sim_matches(2,C));
p = solve_affine_params(X, X_prime);
affine_mat = [1+p(3) p(4) p(1); p(5) 1+p(6) p(2)];

figure(11); delete(gca); tightsubplot(1,1,1); 
imshow(sim_combined)
hold on
for i = 1:size(C,2)
    plot([simA_fc(1,sim_matches(1,C)); size(simA,2)+simB_fc(1,sim_matches(2,C))],...
    [simA_fc(2,sim_matches(1,C)); simB_fc(2,sim_matches(2,C))],'yellow','linewidth',2);
end
title(sprintf('Consensus set''s affine vector: (%f, %f, %f, %f, %f, %f)',p(1),p(2),p(3),p(4),p(5),p(6)));
print(gcf, '-dpng', './output/ps4-3-c-1.png')


%% 3-d warping image B to image A based on similarity parameter vector


warpedB = zeros(size(simA));
for i = 1:size(simA,2)
    for j = 1:size(simA,1)
        new_ind = sim_mat * double([i;j;1]);
        new_i = max(min(round(new_ind(1)),640),1);
        new_j = max(min(round(new_ind(2)),480),1);
        warpedB(j,i) = simB(new_j,new_i);
    end
end

overlayed_B = zeros([size(simA,1) size(simA,2) 3]);
overlayed_B(:,:,1) = simA;
% overlayed_B(:,:,2) = warpedB;
overlayed_B(:,:,3) = warpedB;

figure(12); delete(gca); tightsubplot(1,1,1)
imshow(warpedB);hold on;
title('Warped B');
print(gcf, '-dpng', './output/ps4-3-d-1.png')

figure(13); delete(gca); tightsubplot(1,1,1);
imshow(overlayed_B);hold on;
title('Purple is match; blue is warped from B but not in A; red is in A but not warped from B')
print(gcf, '-dpng', './output/ps4-3-d-2.png')


%% 3-e warping image B to image A based on affine parameter vector

warpedB = zeros(size(simA));
for i = 1:size(simA,2)
    for j = 1:size(simA,1)
        new_ind = affine_mat * double([i;j;1]);
        new_i = max(min(round(new_ind(1)),640),1);
        new_j = max(min(round(new_ind(2)),480),1);
        warpedB(j,i) = simB(new_j,new_i);
    end
end

overlayed_B = zeros([size(simA,1) size(simA,2) 3]);
overlayed_B(:,:,1) = simA;
% overlayed_B(:,:,2) = warpedB;
overlayed_B(:,:,3) = warpedB;


figure(14); delete(gca); tightsubplot(1,1,1)
imshow(warpedB);hold on;
title('Warped B via affine');
print(gcf, '-dpng', './output/ps4-3-e-1.png')

figure(15); delete(gca); tightsubplot(1,1,1);
imshow(overlayed_B);hold on;
title(sprintf('Overlayed via affine; \nPurple is match; blue is warped from B but not in A; red is in A but not warped from B'))
print(gcf, '-dpng', './output/ps4-3-e-2.png')






