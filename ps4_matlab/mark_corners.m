%% marking corners as green circles
% pass the orginal image and the R-image (both 2D) 
% return a RGB image in [0,1]
function img_marked = mark_corners(img, R_sup)
    img_marked = repmat(img,[1 1 3]);    
    img_marked(:,:,2) = img_marked(:,:,2).*(R_sup<=0);    
    H = fspecial('gauss',11,1);
    img_marked(:,:,2) = img_marked(:,:,2)+(imfilter(double(R_sup>0),H)>0.001);
end