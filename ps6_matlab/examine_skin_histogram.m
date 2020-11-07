%% read image

pres_debate = VideoReader('./input/noisy_debate.avi');
img_1 = double(read(pres_debate,[1]))./255;
m = 71;
n = 71;


%% experiment - try plot different patches

hand_win = [540,395,m,n];  % hand and blue background
% hand_win = [640,495,m,n];  % carpet
% hand_win = [400,495,m,n];  % shirt
% hand_win = [330,220,m,n];  % face

original_template = img_1(hand_win(2):hand_win(2)+hand_win(4)-1,hand_win(1):hand_win(1)+hand_win(3)-1,:);
img_original_disp = draw_window(img_1,hand_win);
original_template_R = original_template(:,:,1);
original_template_G = original_template(:,:,2);
original_template_B = original_template(:,:,3);
hand_R = original_template_R(original_template_R>0.2);
hand_G = original_template_G(original_template_R>0.2);
hand_B = original_template_B(original_template_R>0.2);

ccc = gcf;
delete(ccc.Children);
figure(4);
vl_tightsubplot(2,4,1,'Spacing',0.05);
hist(reshape(original_template(:,:,1),[m*n 1]),0:0.02:1)
vl_tightsubplot(2,4,2,'Spacing',0.05);
hist(reshape(original_template(:,:,2),[m*n 1]),0:0.02:1)
vl_tightsubplot(2,4,3,'Spacing',0.05);
hist(reshape(original_template(:,:,3),[m*n 1]),0:0.02:1)
vl_tightsubplot(2,4,5,'Spacing',0.05);
hist(hand_R,0:0.02:1)
vl_tightsubplot(2,4,6,'Spacing',0.05);
hist(hand_G,0:0.02:1)
vl_tightsubplot(2,4,7,'Spacing',0.05);
hist(hand_B,0:0.02:1)

vl_tightsubplot(2,4,4);
imshow(original_template)
vl_tightsubplot(2,4,8);
imshow(img_original_disp)


%% conclusion: 

skin_hist_min = [0.25 0.15 0.05];
skin_hist_max = [1.00 0.75 0.60];

%%

mean(mean((original_template(:,:,1)>skin_hist_min(1))&(original_template(:,:,1)<skin_hist_max(1))))

