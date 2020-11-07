%% ps6
clear all; clc;

% first, make sure your current directory is where this script is
% then add to path all functions essential to this project
addpath(genpath('../utilities'));  

%% Part 1 setup

% implay('./input/pres_debate.avi')
fileID = fopen('./input/pres_debate.txt','r');
win_loc = fscanf(fileID,'%f');


%% iterations and video creating

tic 

% hyperparameters
N = 800;  % sample size
sigma_MSE = 0.4;   % Likelihood smoothing
sigma_D = 8;       % dynamic uncertainty 

% pres_debate = VideoReader('./input/pres_debate.avi');
pres_debate = VideoReader('./input/noisy_debate.avi');
img_1 = double(read(pres_debate,[1]))./255;

v_temp = VideoWriter('temp.avi');
open(v_temp)

% similarity window size (m, n)
m = floor(win_loc(3)/2)*2+1;  % make it an odd number will make life easier!
n = floor(win_loc(4)/2)*2+1;
% m = m+32;            % trying different window sizes
% n = n+12;

u = (round(win_loc(1))+round(win_loc(1)+m-1))/2;
v = (round(win_loc(2))+round(win_loc(2)+n-1))/2;

% confirming template
template = img_1(v-(n-1)/2:v+(n-1)/2, u-(m-1)/2:u+(m-1)/2,:);


% initial round: uniform random sampling (excluding the margin area)
W = int16((m-1)/2+1:pres_debate.Width-(m-1)/2);
H = int16((n-1)/2+1:pres_debate.Height-(n-1)/2);
S = [randsample(W,N,true); randsample(H,N,true)]';  % set of particles

for t = 1:260
    
    % read new frame
    img_t = double(read(pres_debate,[t]))./255;
%     img_t = double(readFrame(pres_debate))./255;

    % update particles
    w_t = calc_particle_weights(template, img_t, S, sigma_MSE);
    
    % resampling
    i_new = randsample(size(S,1),N,true,w_t);
    S = S(i_new,:);

    % dynamic uncertainty (help particles move along)
    S(:,1) = S(:,1)+int16(round(normrnd(0,sigma_D,[N 1])));
    S(:,2) = S(:,2)+int16(round(normrnd(0,sigma_D,[N 1])));
    
    % clamp at the margin area 
    S(:,1) = min(pres_debate.Width-(m-1)/2-1, max((m-1)/2+1, S(:,1)));
    S(:,2) = min(pres_debate.Height-(n-1)/2-1, max((n-1)/2+1, S(:,2)));
    
    % visualise the new states
    weighted_u_mean = w_t'*double(S(i_new,1));
    weighted_v_mean = w_t'*double(S(i_new,2));
    loc_x = round(weighted_u_mean) -(m-1)/2;
    loc_y = round(weighted_v_mean) -(n-1)/2;
    AA = [(double(S(i_new,1)) - weighted_u_mean) (double(S(i_new,2)) - weighted_v_mean)].*w_t;
    spread_radius = sum(sum(AA.^2,2).^0.5);    
    img_new_disp = draw_window(img_t,[loc_x, loc_y, m,n]);
    img_new_disp = draw_uv(img_new_disp, S);
    img_new_disp = draw_circle(img_new_disp, [weighted_u_mean weighted_v_mean], spread_radius);
    writeVideo(v_temp, img_new_disp)
    
end

v_temp.close()

toc


%% 1a-e  save  resulsts
v1 = VideoReader('./temp.avi');
img_temp = read(v1, [46]);

ccc = gcf;
delete(ccc.Children);
figure(2);
vl_tightsubplot(1,1,1);
imshow(img_temp)
% print(gcf, '-dpng','./output/ps6-1-e-3.png')

 
%% Part 2

pres_debate = VideoReader('./input/pres_debate.avi');
img_1 = double(read(pres_debate,[1]))./255;




%%
tic

% hyperparameters
N = 500;  % sample size
sigma_MSE = [0.01 0.01 0.01]*1;   % Likelihood smoothing
sigma_D = 5;       % dynamic uncertainty 
alpha = 0.5;
m = 71;
n = 71;
hand_win = [540,395,m,n];

u = (round(hand_win(1))+round(hand_win(1)+hand_win(3)-1))/2;
v = (round(hand_win(2))+round(hand_win(2)+hand_win(4)-1))/2;

% initial round: uniform random sampling (excluding the margin area)
W = int16(hand_win(1)-50:hand_win(1)+hand_win(3)+49);
H = int16(hand_win(2)-50:hand_win(2)+hand_win(4)+49);
S = [randsample(W,N,true); randsample(H,N,true)]';  % set of particles
template = img_1(hand_win(2):hand_win(2)+hand_win(4)-1,hand_win(1):hand_win(1)+hand_win(3)-1,:);
img_1_disp = draw_window(img_1,hand_win);
img_1_disp(1:n, size(img_1,2)-m+1:end,:) = template;
img_1_disp = draw_uv(img_1_disp,S);

v_temp = VideoWriter('temp.avi');
open(v_temp)


for t = 1:60
    
    % read new frame
%     if mod(t,2)==1
    img_t = double(read(pres_debate,[t]))./255;
%     end
    % update particles
    w_t = calc_particle_weights(template, img_t, S, sigma_MSE);
    
    % resampling
    i_new = randsample(size(S,1),N,true,w_t);
    S = S(i_new,:); 

    % dynamic uncertainty (help particles move along)
    S(:,1) = S(:,1)+int16(round(normrnd(0,sigma_D,[N 1])));
    S(:,2) = S(:,2)+int16(round(normrnd(0,sigma_D,[N 1])));
%     S(:,1) = S(:,1)+int16(round(unifrnd(-10,10,[N 1])));
%     S(:,2) = S(:,2)+int16(round(unifrnd(-10,10,[N 1])));
    
    % clamp at the margin area 
    S(:,1) = min(pres_debate.Width-(m-1)/2-1, max((m-1)/2+1, S(:,1)));
    S(:,2) = min(pres_debate.Height-(n-1)/2-1, max((n-1)/2+1, S(:,2)));
    
    % visualise the new states
    weighted_u_mean = w_t'*double(S(i_new,1));
    weighted_v_mean = w_t'*double(S(i_new,2));
    loc_x = round(weighted_u_mean) -(m-1)/2;
    loc_y = round(weighted_v_mean) -(n-1)/2;
    AA = [(double(S(i_new,1)) - weighted_u_mean) (double(S(i_new,2)) - weighted_v_mean)].*w_t;
    spread_radius = sum(sum(AA.^2,2).^0.5);    
    img_1_disp_with_template = draw_window(img_t,[loc_x, loc_y, m,n]);
    img_1_disp_with_template = draw_uv(img_1_disp_with_template, S);
    img_1_disp_with_template = draw_circle(img_1_disp_with_template, [weighted_u_mean weighted_v_mean], spread_radius);
    
    [~,ind] = max(w_t);
    best_patch = img_t(S(ind,2)-int16(n-1)/2:S(ind,2)+int16(n-1)/2, S(ind,1)-int16(m-1)/2:S(ind,1)+int16(m-1)/2, :);
%     best_patch = img_t(loc_y:loc_y+n-1,loc_x:loc_x+m-1,:);
    template = alpha.*best_patch + (1-alpha).*template;
    img_1_disp_with_template(1:n, size(img_1,2)-m+1:end,:) = template;
    writeVideo(v_temp, img_1_disp_with_template)

end

v_temp.close()

toc


ccc = gcf;
delete(ccc.Children);
figure(3);
vl_tightsubplot(1,2,1);
imshow(img_1_disp)
vl_tightsubplot(1,2,2);
imshow(img_1_disp_with_template)


 


%%


sum(sum(abs(template - template.^2),1),2)

