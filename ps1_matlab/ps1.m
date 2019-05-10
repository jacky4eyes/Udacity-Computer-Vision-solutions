% ps1

%% 1-a
clc;
img = imread(fullfile('input', 'ps1-input0.png'));  % already grayscale
[img_edges, threshOut]  = edge(img,'canny',0.1,0.01);
figure(1)

subplot(2,2,1)
imshow(img);
subplot(2,2,2)
imshow(img_edges);
imwrite(img_edges, fullfile('output', 'ps1-1-a-1.png'));  % save as output/ps1-1-a-1.png

%% 2-a
% TODO: Plot/show accumulator array H, save as output/ps1-2-a-1.png
[H, theta, rho] = hough_lines_acc(img_edges);  % defined in hough_lines_acc.m
subplot(2,2,3)
imshow(imadjust(rescale(H)),'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
colormap(gca,hot);
axis on, axis normal;
imwrite(imadjust(rescale(H)), fullfile('output', 'ps1-2-a-1.png'));  % save as output/ps1-1-a-1.png

%% 2-b
% find and choose peaks 
peaks = hough_peaks(H, 6,'Threshold',0.2*max(H(:)),'NHoodSize',[5 5]);  % defined in hough_peaks.m
% peaks = houghpeaks(H, 15,'Threshold',0.4*max(H(:)),'NHoodSize',[5 5]);  % compare with MATLAB version 
% subplot(2,2,4)
% imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
% plot(theta(peaks(:,2)),rho(peaks(:,1)),'s','linewidth',10,'color','white');

%% 2-c 
% TODO: Highlight peak locations on accumulator array, save as output/ps1-2-b-1.png
hough_lines_draw(img, 'ps1-2-c-1.png', peaks, rho, theta)

%% q3

clc;
img3 = imread(fullfile('input', 'ps1-input0-noise.png'));  
hsize3 = 7.*[1 1];
sigma3 = 5;
h3 = fspecial('gaussian',hsize3,sigma3);
img3_smooth = imfilter(img3, h3);
[img3_edges, threshOut3]  = edge(img3,'canny',0.4,4);
[img3_smooth_edges, threshOut_smooth3]  = edge(img3_smooth,'canny',0.4,4);
% img3_gray = mean(img3,3);% converte to grayscale

figure(3)
subplot(2,2,1)
imshow(img3);
subplot(2,2,2)
imshow(img3_smooth);
subplot(2,2,3)
imshow(img3_edges);
subplot(2,2,4)
imshow(img3_smooth_edges)
imwrite(img3_smooth_edges, fullfile('output', 'ps1-3-a-1.png'));  % save as output/ps1-1-a-1.png



