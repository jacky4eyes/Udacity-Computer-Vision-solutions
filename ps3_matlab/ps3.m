%%
%%  1a verifying function
clc; 

file_2d = fopen('./input/pts2d-norm-pic_a.txt','r');
p2d = fscanf(file_2d ,'%f',[2 inf])';
fclose(file_2d);
file_3d = fopen('./input/pts3d-norm.txt','r');
P3d = fscanf(file_3d,'%f',[3 inf])';
fclose(file_3d);

n_points = size(p2d,1);
A = [P3d ones([n_points 1]) zeros([n_points 4]) -p2d(:,1).*P3d -p2d(:,1) zeros([n_points 4]) P3d ones([n_points 1]) -p2d(:,2).*P3d -p2d(:,2)];
A = reshape(A',[12 2*n_points])';
[U,D,V] = svd(A);
M = reshape(V(:,end),4,3)';
[p_hat_1a,residual_1a] = calc_residual(M,P3d,p2d);

%% 1b  3D and 2D matching

clc; 
file_2d = fopen('./input/pts2d-pic_a.txt','r');
p2d = fscanf(file_2d ,'%f',[2 inf])';
fclose(file_2d);
file_3d = fopen('./input/pts3d.txt','r');
P3d = fscanf(file_3d,'%f',[3 inf])';
fclose(file_3d);

residual_list = zeros([100 1]);
M_list = zeros([100 3 4]);
for i=1:100
    n_choice = randperm(20);
    n_choice(1:16);
    p2d_choice = p2d(n_choice(1:16),:);
    P3d_choice = P3d(n_choice(1:16),:);

    n_points = size(p2d_choice,1);
    A = [P3d_choice ones([n_points 1]) zeros([n_points 4]) -p2d_choice(:,1).*P3d_choice -p2d_choice(:,1) zeros([n_points 4]) P3d_choice ones([n_points 1]) -p2d_choice(:,2).*P3d_choice -p2d_choice(:,2)];
    A = reshape(A',[12 2*n_points])';
    [U,D,V] = svd(A);
    M = reshape(V(:,end),4,3)';
    [p_hat_1b,residual_1b] = calc_residual(M,P3d(n_choice(17:end),:),p2d(n_choice(17:end),:));
    residual_list(i) = mean(residual_1b);
    M_list(i,:,:) = M;
end 

[val,ind] = min(residual_list);
M_best = reshape(M_list(ind,:,:),3,4)


%% 1c  finding camera centre

world_coor_of_centre = [-inv(M_best(1:3,1:3))*M_best(:,4); 1]


%% 2abd fundamental matrix with normalisation of feature points

clc; 
file_a = fopen('./input/pts2d-pic_a.txt','r');
p_a = fscanf(file_a ,'%f',[2 inf])';
fclose(file_a);
file_b = fopen('./input/pts2d-pic_b.txt','r');
p_b = fscanf(file_b,'%f',[2 inf])';
fclose(file_b);

n_points = size(p_a,1);


%% normalisation

c_ax = mean(p_a(:,1));  % mean of x values
c_ay = mean(p_a(:,2));  % mean of x values
c_bx = mean(p_b(:,1));  % mean of x values
c_by = mean(p_b(:,2));  % mean of x values
s = 1/1000;   % scaling factor

T_a = [s 0 0; 0 s 0;0 0 1]*[1 0 -c_ax; 0 1 -c_ay; 0 0 1];
p_a_norm = (T_a * [p_a ones([n_points 1])]')';
T_b = [s 0 0; 0 s 0;0 0 1]*[1 0 -c_bx; 0 1 -c_by; 0 0 1];
p_b_norm = (T_b * [p_b ones([n_points 1])]')';

% B = [ p_a(:,1).*p_b(:,1)  p_a(:,2).*p_b(:,1) p_b(:,1) p_a(:,1).*p_b(:,2) p_a(:,2).*p_b(:,2) p_b(:,2) p_a(:,1) p_a(:,2) ones([n_points 1])];
B = [ p_a_norm(:,1).*p_b_norm(:,1)  p_a_norm(:,2).*p_b_norm(:,1) p_b_norm(:,1) p_a_norm(:,1).*p_b_norm(:,2) p_a_norm(:,2).*p_b_norm(:,2) p_b_norm(:,2) p_a_norm(:,1) p_a_norm(:,2) p_a_norm(:,3)];
[U, D, V] = svd(B);
F = reshape(V(:,end),3,3)';
[U_F, D_F, V_F] = svd(F);
D_F(3,3) = 0 ;
F_hat = (U_F * D_F * V_F');
F_hat_final = T_b' * F_hat * T_a;

%% 2ce overlaying epipolar lines 

lines_a = F_hat_final' * [p_b ones([n_points 1])]';
lines_b = F_hat_final * [p_a ones([n_points 1])]';

line_L = [1 0 0]';
line_R = [1 0 -1100]';

img_a = imread('./input/pic_a.jpg');
img_b = imread('./input/pic_b.jpg');

figure(2)
subplot(1,2,1)
imshow(img_b)
for i=1:20
    p1 = cross(line_L,lines_b(:,i));
    p1 = p1(1:2)./p1(3);
    p2 = cross(line_R,lines_b(:,i));
    p2 = p2(1:2)./p2(3);
    line([p1(1) p2(1)],[p1(2) p2(2)], 'linewidth',1,'color','g')
end


subplot(1,2,2)
imshow(img_a)
for i=1:20
    p1 = cross(line_L,lines_a(:,i));
    p1 = p1(1:2)./p1(3);
    p2 = cross(line_R,lines_a(:,i));
    p2 = p2(1:2)./p2(3);
    line([p1(1) p2(1)],[p1(2) p2(2)], 'linewidth',1,'color','g')
end



