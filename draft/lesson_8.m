% Hough transform
pkg load image;

im1 = mean(imread('shapes1.png'),axis=3);
figure(1)
imshow(im1)
im2 = edge(im1,'Canny',sigma=0.8);
figure(2)
imshow(im2*1)
figure(3)
H = houghtf(im2*1,method='line');
peaks = houghpeaks(H);
imshow(H)
[r_ind theta_ind] = find(H >= 0.5*max(H(:)))
figure(4)
hold on
for i = 1:length(r_ind)
  theta = (pi.*(-0:180)/180)(theta_ind(i));
  r = (1:0.5:1180)(r_ind(i))
  plot_x = 1:2:500;
  plot_y = (r - plot_x*cos(theta))/sin(theta);
##  plot_y = 1:10:200;
##  plot_x = (r - plot_y*sin(theta))/cos(theta);
  plot(plot_x, plot_y)
end  