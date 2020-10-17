%% return an image containing Harris R values
function R = calc_harris(M, alpha)
    R = zeros([size(M,1) size(M,2)]);
    for i = 1:size(M,1)
        for j = 1:size(M,2)
            M_ij = [M(i,j,1) M(i,j,2); M(i,j,3) M(i,j,4)];
            R(i,j) = det(M_ij) - alpha*(trace(M_ij)^2);
        end
    end
end