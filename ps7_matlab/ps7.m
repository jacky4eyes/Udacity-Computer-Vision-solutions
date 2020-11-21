%% ps7
clear all; clc;

% first, make sure your current directory is where this script is
% then add to path all functions essential to this project
addpath(genpath('../utilities'));  


%% Part 1a

vid = VideoReader('./input/PS7A1P1T1.avi'); % containing 65 frames

th = 7e-3;
sigma = 1.5;
disk_r1 = 5;
disk_r2 = 13; 
T = 50;

img2 = rgb2gray(double(readFrame(vid))./255);
binary_sequence = zeros([T, size(img2)]);
for t = 1:T
    img1 = img2;
    img2 = rgb2gray(double(readFrame(vid))./255);
    B1_new = calc_frame_diff_binary(img1, img2, sigma, disk_r1, disk_r2, th);
    binary_sequence(t,:,:) = B1_new ;
        
end

imwrite(reshape(binary_sequence(10,:,:),size(img2)),'output/ps7-1-a-1.png');
imwrite(reshape(binary_sequence(20,:,:),size(img2)),'output/ps7-1-a-2.png');
imwrite(reshape(binary_sequence(30,:,:),size(img2)),'output/ps7-1-a-3.png');


%% save temporary images for inspection

vid = VideoReader('./input/PS7A3P1T2.avi'); 

th = 5e-3;
sigma = 1;
disk_r1 = 5;
disk_r2 = 13; 
T = floor(vid.Duration * vid.FrameRate-1);

img2 = rgb2gray(double(readFrame(vid))./255);
binary_sequence = zeros([T, size(img2)]);
for t = 1:T
    img1 = img2;
    img2 = rgb2gray(double(readFrame(vid))./255);
    B1_new = calc_frame_diff_binary(img1, img2, sigma, disk_r1, disk_r2, th);
    binary_sequence(t,:,:) = B1_new ; 
end

imwrite(reshape(binary_sequence(10,:,:),size(img2)),'output/z1.png');
imwrite(reshape(binary_sequence(20,:,:),size(img2)),'output/z2.png');
imwrite(reshape(binary_sequence(30,:,:),size(img2)),'output/z3.png');
imwrite(reshape(binary_sequence(40,:,:),size(img2)),'output/z4.png');
imwrite(reshape(binary_sequence(50,:,:),size(img2)),'output/z5.png');
imwrite(reshape(binary_sequence(60,:,:),size(img2)),'output/z6.png');
imwrite(reshape(binary_sequence(end,:,:),size(img2)),'output/zz.png');

%% Part 1b

t0 = 2;
tau = 90;
M_tau = zeros([size(binary_sequence,2) size(binary_sequence,3)]);
for t = t0:t0+tau-1
    Bt = reshape(binary_sequence(t,:,:),[size(binary_sequence,2) size(binary_sequence,3)]);
    M_tau(Bt~=1) = (M_tau(Bt~=1)-1);
    M_tau(M_tau<0) = 0;
    M_tau(Bt==1) = tau;
end
M_tau = M_tau/max(M_tau(:));

figure(1);

vl_tightsubplot(2,3,1);
imshow(img1)

vl_tightsubplot(2,3,2);
imshow(img2)

vl_tightsubplot(2,3,3);
imshow(reshape(binary_sequence(30,:,:),size(img2)))

vl_tightsubplot(2,3,6);
imshow(M_tau)


% imwrite(M_tau,'output/ps7-1-b-1.png');
% imwrite(M_tau,'output/ps7-1-b-2.png');
% imwrite(M_tau,'output/ps7-1-b-3.png');


%% Part 2 setup 

th = 7e-3;
sigma = 1.5;
disk_r1 = 5;
disk_r2 = 13; 


%% activity 1

t0 = 1;
tau = 50;
vid = VideoReader('./input/PS7A1P1T1.avi');
MHI_A1P1T1 = calc_MHI(vid,t0, tau , sigma, disk_r1, disk_r2, th);

vid = VideoReader('./input/PS7A1P2T1.avi');
MHI_A1P2T1 = calc_MHI(vid,t0, tau , sigma, disk_r1, disk_r2, th);

vid = VideoReader('./input/PS7A1P3T1.avi');
MHI_A1P3T1 = calc_MHI(vid,t0, tau , sigma, disk_r1, disk_r2, th);

%% activity 2
t0 = 10;
tau = 30;
vid = VideoReader('./input/PS7A2P1T1.avi');
MHI_A2P1T1 = calc_MHI(vid,t0, tau , sigma, disk_r1, disk_r2, th);

vid = VideoReader('./input/PS7A2P2T1.avi');
MHI_A2P2T1 = calc_MHI(vid,t0, tau , sigma, disk_r1, disk_r2, th);

vid = VideoReader('./input/PS7A2P3T1.avi');
MHI_A2P3T1 = calc_MHI(vid,t0, tau , sigma, disk_r1, disk_r2, th);

%% activity 3

t0 = 40;
tau = 30;
vid = VideoReader('./input/PS7A3P1T1.avi');
MHI_A3P1T1 = calc_MHI(vid,t0, tau , sigma, disk_r1, disk_r2, th);

vid = VideoReader('./input/PS7A3P2T1.avi');
MHI_A3P2T1 = calc_MHI(vid,t0, tau , sigma, disk_r1, disk_r2, th);

vid = VideoReader('./input/PS7A3P3T1.avi');
MHI_A3P3T1 = calc_MHI(vid,t0, tau , sigma, disk_r1, disk_r2, th);

%%  performance is not very good... I think the MHI can be improved
clc;
fprintf('+++++ activity 1 person 1 +++++ activity 1 person 2 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A1P1T1,MHI_A1P2T1))
fprintf('+++++ activity 1 person 1 +++++ activity 1 person 3 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A1P1T1,MHI_A1P3T1))
fprintf('+++++ activity 1 person 1 +++++ activity 2 person 2 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A1P1T1,MHI_A2P2T1))
fprintf('+++++ activity 1 person 1 +++++ activity 2 person 3 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A1P1T1,MHI_A2P3T1))
fprintf('+++++ activity 1 person 1 +++++ activity 3 person 2 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A3P1T1,MHI_A3P2T1))
fprintf('+++++ activity 1 person 1 +++++ activity 3 person 3 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A3P1T1,MHI_A3P3T1))
fprintf('\n');
fprintf('+++++ activity 2 person 1 +++++ activity 1 person 2 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A2P1T1,MHI_A1P2T1))
fprintf('+++++ activity 2 person 1 +++++ activity 1 person 3 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A2P1T1,MHI_A1P3T1))
fprintf('+++++ activity 2 person 1 +++++ activity 2 person 2 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A2P1T1,MHI_A2P2T1))
fprintf('+++++ activity 2 person 1 +++++ activity 2 person 3 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A2P1T1,MHI_A2P3T1))
fprintf('+++++ activity 2 person 1 +++++ activity 3 person 2 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A2P1T1,MHI_A3P2T1))
fprintf('+++++ activity 2 person 1 +++++ activity 3 person 3 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A2P1T1,MHI_A3P3T1))
fprintf('\n');
fprintf('+++++ activity 3 person 1 +++++ activity 1 person 2 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A3P1T1,MHI_A1P2T1))
fprintf('+++++ activity 3 person 1 +++++ activity 1 person 3 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A3P1T1,MHI_A1P3T1))
fprintf('+++++ activity 3 person 1 +++++ activity 2 person 2 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A3P1T1,MHI_A2P2T1))
fprintf('+++++ activity 3 person 1 +++++ activity 2 person 3 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A3P1T1,MHI_A2P3T1))
fprintf('+++++ activity 3 person 1 +++++ activity 3 person 2 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A3P1T1,MHI_A3P2T1))
fprintf('+++++ activity 3 person 1 +++++ activity 3 person 3 +++++:\t %f\n',calc_dist_between_2_activities(MHI_A3P1T1,MHI_A3P3T1))




%% (the confusion matrix part is too tedious... I skipped...)

%% that's it, I'm done with this PS, and thus this whole course...














