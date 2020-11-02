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
        mse_RGB = mean(mean((template-patch).^2.^0.5));
        likelihood_RGB = exp(-mse_RGB/(2*sigma_MSE^2));

        % combine RGB likelihood (temporary method)
        likelihood = norm(reshape(likelihood_RGB,[3 1]),2)/3;
        w_arr(i) = likelihood;
        
    end

    w_arr = w_arr./norm(w_arr,1);  % normalisation
    
end