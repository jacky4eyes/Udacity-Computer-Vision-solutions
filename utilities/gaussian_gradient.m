%% return x-derivative and y-derivative images
% [img_x, img_y] = gaussian_gradient(img, g_size, sigma)
function [img_x, img_y] = gaussian_gradient(img, g_size, sigma)
    x = (-floor(g_size/2)):floor(g_size/2);
    H = fspecial('gaussian',g_size,sigma);
    H_x = H.*(repmat(-x./(sigma^2),g_size,1)); % x gaussian derivative kernel
    H_y = H.*(repmat(-x'./(sigma^2),1,g_size)); % y gaussian derivative kernel
    img_x = imfilter(img,H_x);
%     img_x = conv2(img,H_x);
    img_y = imfilter(img,H_y);
end