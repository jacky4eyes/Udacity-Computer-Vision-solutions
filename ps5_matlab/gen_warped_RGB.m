%% generate warp quality check
% im_disp = gen_warped_RGB(im1, im2, U, V)
function im_disp = gen_warped_RGB(im1, im2, U, V)
    [x_grid,y_grid] = meshgrid(1:size(im1,2),1:size(im1,1));
    im2_warped = interp2(x_grid,y_grid,im2,x_grid+U,y_grid+V,'*linear');
    im2_warped(isnan(im2_warped)) = 0;
    im_disp = zeros([size(im1) 3]);
    im_disp(:,:,1) = im2_warped  ;
    im_disp(:,:,3) = im1;
    
end