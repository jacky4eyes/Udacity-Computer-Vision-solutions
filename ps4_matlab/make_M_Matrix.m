%% calculate M matrix, which has size (n_row, n_col, 4)
% M = make_M_Matrix(I_x, I_y, W)
% W is the window (kernel with weights)
function M = make_M_Matrix(I_x, I_y, W)
    
    % get second-order derivatives
    I_xx = I_x.^2;
    I_yy = I_y.^2;
    I_xy = I_x.*I_y;
    
    % make M
    M = zeros([size(I_x) 4]);
    M(:,:,1) = imfilter(I_xx ,W);
    M(:,:,2) = imfilter(I_xy ,W);
    M(:,:,3) = M(:,:,2);
    M(:,:,4) = imfilter(I_yy ,W);
end