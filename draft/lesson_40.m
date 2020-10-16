im1 = imread('doberman2.jpg');
im1 = double(im1(:,:,1))/255;
% im1 = im1(:,:,1);
figure(1)
imshow(im1,[0,1])
h = fspecial('gaussian',5,0.8);
ha = fspecial('gaussian',5,0.5);
hb = fspecial('gaussian',5,0.5);
im2 = imfilter(im1,h);
im3 = im2(1:2:end,1:2:end);
im3a = imfilter(im3,h);
im3b = imfilter(im3a(1:2:end,1:2:end),ha);
im3c = imfilter(im3b(1:2:end,1:2:end),hb);
im4 = im3c;
% im4 = im1(1:8:end,1:8:end);
im5 = imresize(im4,8);
% im4 = zeros(size(im3)*2);
% im4(1:2:end,1:2:end) = im3;
% im4(2:2:end,1:2:end) = im3;
% im4(1:2:end,2:2:end) = im3;
% im4(2:2:end,2:2:end) = im3;

figure(2)
imshow(im5)
