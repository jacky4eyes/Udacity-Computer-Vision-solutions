%% apply noise reduction
pkg load image;

function [yIndex xIndex zIndex] = find_template_2D(template, img)
    c1 = normxcorr2(template(:,:,1),img(:,:,1));
    c2 = normxcorr2(template(:,:,2),img(:,:,2));
    c3 = normxcorr2(template(:,:,3),img(:,:,3));
    c = cat(3,c1,c2,c3);
    figure(3)
    imshow(c,[0,255])
    [yIndex  xIndex zIndex] = find(c==max(c(:)));
endfunction

im1 = imread('./cloud1.png');
figure(1)
imshow(im1)
%im2 = mean(ceil(im1(:,:,:)),3);
im2 = ceil(im1(:,:,:));
im3 = im2(250:280,230:260,:);
size(im3);
figure(2)
imshow([im3],[0 255])
[yind xind zind] = find_template_2D(im3,im2)