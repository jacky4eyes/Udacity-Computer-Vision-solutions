%%  compare patches against the template to get each particle's new weight 
% the template size decides the patch size
% S contains the particles' states
% in this case, a state is (x, y) location
% sigma_MSE is a paramter for the similarity funciton
% w_arr = calc_particle_weights(template, img, S, sigma_MSE)
function w_arr = calc_particle_weights(template, img, S, sigma_MSE)
    
    % size-related variables
    n = size(template,1);
    m = size(template,2);
    N = size(S,1);
    
    % the weight collector for this round
    w_arr = zeros([N 1]);

    for i = 1:N
        % grab this patch
        u_p = S(i,1);
        v_p = S(i,2);
        patch = img(v_p-(n-1)/2:v_p+(n-1)/2, u_p-(m-1)/2:u_p+(m-1)/2,:);
        
        % calculate 3-channel similarity (likelihood)
        mse_RGB = mean(mean(abs(template-patch)));
        mse_RGB = reshape(mse_RGB,[3 1]);
%         mse_R = mean(mean(abs(template(:,:,1) - patch(:,:,1))));
%         mse_G = mean(mean(abs(template(:,:,2) - patch(:,:,2))));
%         mse_B = mean(mean(abs(template(:,:,3) - patch(:,:,3))));
        
        likelihood_RGB = exp(-mse_RGB./(2.*sigma_MSE.^2));
%         likelihood_RGB(3) = likelihood_RGB(3)/5;
        
%         combine likelihoods; still experimenting with different methods
        likelihood = norm(likelihood_RGB, 2)/3;
%         likelihood = likelihood_RGB(1)*likelihood_RGB(2)*likelihood_RGB(3);
%         likelihood = likelihood_RGB(1)+likelihood_RGB(2)+likelihood_RGB(3);
        w_arr(i) = likelihood;
        
    end

    w_arr = w_arr./norm(w_arr,1);  % normalisation
    
end