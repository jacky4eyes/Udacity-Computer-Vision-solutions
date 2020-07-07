function [p_hat,residual] = calc_residual(M, P3d, p2d)
    n_points = size(p2d,1);
    P3d = [P3d(:,:) ones([n_points 1])];
    p_hat = M*P3d';
    p_hat = (p_hat(1:2,:)./p_hat(3,:))';
    se_arr = (p2d - p_hat).^2;
    residual = ((se_arr(:,1) + se_arr(:,2)).^0.5);
end