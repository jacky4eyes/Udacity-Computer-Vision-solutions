%% calculate the raw image moment of order (p, q)
% M_pq = raw_moments(img,p,q)
function M_pq = raw_moments(img,p,q)
    [x_grid,y_grid] = meshgrid(1:size(img,2),1:size(img,1));
    M_mat = (x_grid.^p .* y_grid.^q .* img);
    M_pq = sum(M_mat(:));
end