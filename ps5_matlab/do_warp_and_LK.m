%% a wrapper function for some steps in hierarchical LK
% [U_new, V_new] = do_warp_and_LK(im1, im2, U, V, h)
function [U_new, V_new] = do_warp_and_LK(im1, im2, U, V, h)
    [x_grid,y_grid] = meshgrid(1:size(im1,2),1:size(im1,1));    
    im1_warped = interp2(x_grid,y_grid,im1,x_grid-U,y_grid-V,'*linear');
    im1_warped(isnan(im1_warped)) = 0; 
    [dU, dV] = get_LK_optical_flow(im1_warped, im2, h);
    U_new = U + dU;
    V_new = V + dV;
end