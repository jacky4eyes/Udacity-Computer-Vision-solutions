% ps1

%% 1-a
clc;
img = imread(fullfile('input', 'ps1-input0.png'));  % already grayscale

% figure(1), imshow(img);
[img_edges, threshOut]  = edge(img,'canny',[],0.2);
% figure(2), imshow(img_edges);
imwrite(img_edges, fullfile('output', 'ps1-1-a-1.png'));  % save as output/ps1-1-a-1.png

%% 2-a

[H, theta, rho] = hough_lines_acc(img_edges);  % defined in hough_lines_acc.m
%% TODO: Plot/show accumulator array H, save as output/ps1-2-a-1.png

%% 2-b
peaks = hough_peaks(H, 10);  % defined in hough_peaks.m
%% TODO: Highlight peak locations on accumulator array, save as output/ps1-2-b-1.png

%% TODO: Rest of your code here
