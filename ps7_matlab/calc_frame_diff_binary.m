%% calculate the binary different image between two frames
% B_new  = calc_frame_diff_binary(img1,img2,sigma,disk_r1,disk_r2,th)
function B_new  = calc_frame_diff_binary(img1, img2, sigma, disk_r1, disk_r2, th)

    h = fspecial('gauss',15,sigma);
    img1_fil = imfilter(img1,h);
    img2_fil = imfilter(img2,h);
    B = abs(img1_fil-img2_fil)>th;
    my_close_strel = strel('disk',disk_r1);
    B_new = imclose(B,my_close_strel);
    my_open_strel = strel('disk',disk_r2);
    B_new = imopen(B_new ,my_open_strel);

end