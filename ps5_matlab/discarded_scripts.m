%% trying gradient images

[x_grid,y_grid] = meshgrid(1:40, 1:30);

I_rx = x_grid/100;
I_ry = y_grid/100;
I_gx = x_grid/1000;
I_by = 0.2./(y_grid.^0.5+x_grid.^0.5);

I_r = cumsum(I_rx,2) + cumsum(I_ry,1);
I_r = I_r./max(max(I_r));
I_g = cumsum(I_gx,2);
I_b = cumsum(I_by,1);

I = zeros([size(I_r) 3]);
I(:,:,1) = I_r;
I(:,:,2) = I_g;
I(:,:,3) = I_b;

figure(1);vl_tightsubplot(1,1,1);
imshow(I);


%% check whether image size is good for pyramid
clc
temp = size(jg0);
for i = 1:6
    temp = (temp+1)./2
end

