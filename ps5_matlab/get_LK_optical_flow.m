%% formulate the optical flow problem using brightness constancy
% [U, V] = get_LK_optical_flow(im1, im2, h)
function [U, V] = get_LK_optical_flow(im1, im2, h)
    [Ix, Iy] = gaussian_gradient(im1, 15, 1);
%     h_optional = fspecial('gauss',15, 1);
%     im1 = imfilter(im1,h_optional);
%     im2 = imfilter(im2,h_optional);
    It = im2 - im1;
    [U, V] = solve_LK_flow(Ix,Iy,It,h);

end