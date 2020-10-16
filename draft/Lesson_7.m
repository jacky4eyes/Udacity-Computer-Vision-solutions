pkg load image;

%%
im1 = imread('./chester.jpg');
im2 = double(mean(im1,3)/255.);
im3 = edge(im2,'Canny',sigma=0.05);
figure(1)
imshow(im3)
