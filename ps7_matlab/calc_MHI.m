%% calculate Motion History Image

function M_tau = calc_MHI(vid, t0, tau , sigma, disk_r1, disk_r2, th)
    img2 = rgb2gray(double(readFrame(vid))./255);
    binary_sequence = zeros([tau, size(img2)]);
    for t = t0:t0+tau-1
        img1 = img2;
        img2 = rgb2gray(double(readFrame(vid))./255);
        B1_new = calc_frame_diff_binary(img1, img2, sigma, disk_r1, disk_r2, th);
        binary_sequence(t,:,:) = B1_new ;
    end
    
    M_tau = zeros([size(binary_sequence,2) size(binary_sequence,3)]);
    for t = t0:t0+tau-1
        Bt = reshape(binary_sequence(t,:,:),[size(binary_sequence,2) size(binary_sequence,3)]);
        M_tau(Bt~=1) = (M_tau(Bt~=1)-1);
        M_tau(M_tau<0) = 0;
        M_tau(Bt==1) = tau;
    end
    M_tau = M_tau/max(M_tau(:));

end