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
imwrite(img3_smooth, fullfile('output', 'ps1-3-a-1.png'))
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
imwrite(img3_edges, fullfile('output', 'ps1-3-b-1.png')); 
imwrite(img3_smooth_edges, fullfile('output', 'ps1-3-b-2.png'));


[H_noisy, theta_noisy, rho_noisy] = hough_lines_acc(img3_edges); 
peaks_noisy = hough_peaks(H_noisy, 8,'Threshold',0.2*max(H_noisy(:)),'NHoodSize',[21 21]);
figure(4)
imshow(imadjust(rescale(H_noisy)),'XData',theta,'YData',rho,'InitialMagnification','fit');
hold on
plot(theta_noisy(peaks_noisy(:,2)),rho_noisy(peaks_noisy(:,1)),'s','color','blue','linewidth',10);
xlabel('\theta'), ylabel('\rho');
colormap(gca,hot);
axis on, axis normal;
saveas(gcf, fullfile('output','ps1-3-c-1.png'))

% Jacky: I personally think you don't need to smooth the image for edge
% detection. It has a built-in smoothing already
hough_lines_draw(img3, 'ps1-3-c-2.png', peaks_noisy, rho_noisy, theta_noisy)


%% q4

img4 = imread(fullfile('input', 'ps1-input1.png'));  
img4_gray = mean(img4,3)/255.0;
figure(5);
subplot(2,2,1);  imshow(img4_gray);
hsize4 = 50.*[1 1];
sigma4 = 3;
% Jacky: the idea of bluring the image is so that the unneccessary
% detections are minimised. But I do think  the edge detection algorithm
% can cover that well enough.
h4 = fspecial('gaussian',hsize4,sigma4);    
img4_smooth = imfilter(img4_gray,h4,sigma4);
subplot(2,2,2); imshow(img4_smooth); 
imwrite(img4_smooth, fullfile('output', 'ps1-4-a-1.png')); 
[img4_smooth_edges, threshOut_smooth4]  = edge(img4_smooth,'canny',0.1,3);
subplot(2,2,3); imshow(img4_smooth_edges)
imwrite(img4_smooth_edges, fullfile('output', 'ps1-4-b-1.png')); 
[H_4, theta_4, rho_4] = hough_lines_acc(img4_smooth_edges); 
peaks_4 = hough_peaks(H_4, 8,'Threshold',0.2*max(H_4(:)),'NHoodSize',[5 5]);
% figure(6)
% imshow(imadjust(rescale(H_4)),'XData',theta_4,'YData',rho_4,'InitialMagnification','fit');
% hold on
% plot(theta_4(peaks_4(:,2)),rho_4(peaks_4(:,1)),'s','color','blue','linewidth',10);
% xlabel('\theta'), ylabel('\rho');
% colormap(gca,hot);
% axis on, axis normal;
% saveas(gcf, fullfile('output','ps1-4-c-1.png'))

% Jacky: note that the line-drawing function here needs to be modified. you
% it is better not to restrict the boundary condition
hough_lines_draw(img4_gray, 'ps1-4-c-2.png', peaks_4, rho_4, theta_4)

%% q5 

figure(6)
subplot(2,2,1); imshow(img4_smooth);
subplot(2,2,2); imshow(img4_smooth_edges);
imwrite(img4_smooth, fullfile('output', 'ps1-5-a-1.png'))
imwrite(img4_smooth_edges, fullfile('output', 'ps1-5-a-2.png'))
radius_5 = 22;
H_5 = hough_circles_acc(img4_smooth_edges,radius_5);
subplot(2,2,3); imshow(imadjust(rescale(H_5)))
centers_5 = hough_peaks(H_5,5);
% figure(7)
% imshow(img4_gray); hold on; 
% for i =1:length(centers_5)
%     plot(centers_5(i,2)+round(cos([-179:180]./180*pi)*radius_5),...
%     centers_5(i,1)+round(sin([-179:180]./180*pi)*radius_5),'color','b','linewidth',3)
% end
% saveas(gcf, fullfile('output','ps1-5-a-3.png'))


[centers_5b, radii_5b] = find_circles(img4_smooth_edges, [15 50]);
[centers_5b_big,radii_5b_big] = remove_duplicate(centers_5b, radii_5b,...
    size(img4_smooth_edges,1),size(img4_smooth_edges,2));
% [idx,idy,idr] = find();
% IND = find(H_5b==4);
% [idx idy idr] = ind2sub(size(H_5b),IND);

figure(8)
imshow(img4_gray); hold on; 
for i =1:size(centers_5b_big,1)
    x = centers_5b_big(i,2);
    y = centers_5b_big(i,1);
    radius = radii_5b_big(i);
    plot(x+round(cos([-179:180]./180*pi)*radius),...
    y+round(sin([-179:180]./180*pi)*radius),'color','b','linewidth',3)
end
saveas(gcf, fullfile('output','ps1-5-b-1.png'))

%% q6

clc;
img6 = imread(fullfile('input', 'ps1-input2.png'));  
img6_gray = mean(img6,3)/255.0;
figure(9);
subplot(2,2,1);  imshow(img6_gray);
hsize6 = 3.*[1 1];
sigma6 = 11;

h6 = fspecial('gaussian',hsize6,sigma6);    
img6_smooth = imfilter(img6_gray,h6,sigma6);
subplot(2,2,2);  imshow(img6_smooth);
img6_smooth_edges = edge(img6_smooth,'canny',0.1,5);
subplot(2,2,3);  imshow(img6_smooth_edges);
[H6, theta6, rho6] = hough_lines_acc(img6_smooth_edges);
peaks6 = hough_peaks(H6, 12,'Threshold', 0.1*max(H6(:)), 'NHoodSize', [21 21]);
hough_lines_draw(img6_gray, 'ps1-6-a-1.png', peaks6, rho6, theta6)

% Jacky: at this stage, the task of pen detection is not very well-done
% because of the non-pen objects. The problem is that these edges are very
% distinguishable and are very straight as well

% Jacky: the next is to find parallel lines that are not too far apart
%%
pens = [];
for i = 1:length(peaks)
    prl_ind = find((abs(peaks6(:,2)- peaks6(i,2))<2));
    for j = 1:length(prl_ind)
        if (prl_ind(j) ~= i) && (abs(peaks6(i,1)-peaks6(prl_ind(j),1))<35)
            pens = [pens; peaks6(i,:);peaks6(prl_ind(j),:) ];
        end
    end
end
hough_lines_draw(img6_gray, 'ps1-6-c-1.png', pens, rho6, theta6)

% obviously you can continue to improve this detection.
% but if we want to properly remove the two parallel lines on top, need to 
% figure out how to ascertain the length of the object and filter it out

%% q7




