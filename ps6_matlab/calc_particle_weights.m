%%  compare patches against the template to get each particle's new weight 
% the template size decides the patch size
% S contains the particles' states. In this case, they are (x, y) locations
% sigma_MSE: the similarity parameter
% q: a scalar controlling the additional likelihood bonus from histogram
%
% w_arr = calc_particle_weights(template, img, S, sigma_MSE)
function w_arr = calc_particle_weights(template, img, S, sigma_MSE, q)
    
    
    if ~exist('q','var')
        q = 0;
    end
    % size-related variables
    n = size(template,1);
    m = size(template,2);
    N = size(S,1);
    
    % the weight collector for this round
    w_arr = zeros([N 1]);

    % skin histogram threshold (to improve tracking performance)
    skin_hist_min = [0.25 0.15 0.05];
    skin_hist_max = [1.00 0.75 0.60];
    
    % create skin mask for template
    template_skin_mask_R = (template(:,:,1)>skin_hist_min(1))&(template(:,:,1)<skin_hist_max(1));
    template_skin_mask_G = (template(:,:,2)>skin_hist_min(2))&(template(:,:,2)<skin_hist_max(2));
    template_skin_mask_B = (template(:,:,3)>skin_hist_min(3))&(template(:,:,3)<skin_hist_max(3));
    
    for i = 1:N
        % grab this patch
        u_p = S(i,1);
        v_p = S(i,2);
        patch = img(v_p-(n-1)/2:v_p+(n-1)/2, u_p-(m-1)/2:u_p+(m-1)/2,:);
        
        % create skin mask for patch
        patch_skin_mask_R = (patch(:,:,1)>skin_hist_min(1))&(patch(:,:,1)<skin_hist_max(1));
        patch_skin_mask_G = (patch(:,:,2)>skin_hist_min(2))&(patch(:,:,2)<skin_hist_max(2));
        patch_skin_mask_B = (patch(:,:,3)>skin_hist_min(3))&(patch(:,:,3)<skin_hist_max(3));
                
        % calculate 3-channel similarity (likelihood)
        abs_error = abs(template-patch);
        mse_RGB = zeros([3 1]);
        
        mse_RGB(1) = mean(mean(abs_error(:,:,1).*(template_skin_mask_R|patch_skin_mask_R)));
        mse_RGB(2) = mean(mean(abs_error(:,:,2).*(template_skin_mask_G|patch_skin_mask_G)));
        mse_RGB(3) = mean(mean(abs_error(:,:,3).*(template_skin_mask_B|patch_skin_mask_B)));
        
               
%         mse_RGB = reshape(mse_RGB,[3 1]);
        likelihood_RGB = exp(-mse_RGB./(2.*sigma_MSE.^2));
        
        % combine likelihoods; still experimenting with different methods
        likelihood = norm(likelihood_RGB, 2)/3;
%         likelihood = likelihood_RGB(1)*likelihood_RGB(2)*likelihood_RGB(3);
%         likelihood = likelihood_RGB(1)+likelihood_RGB(2)+likelihood_RGB(3);

        % additional bonus from the count of skin pixels (default is q=0)
        skin_percentage = sum(sum(patch_skin_mask_R&patch_skin_mask_G&patch_skin_mask_B))/m/n;
        bonus = q*skin_percentage;
        likelihood = likelihood*(1 + bonus);
                
        w_arr(i) = likelihood;
        
    end
    [skin_percentage  max(w_arr)]
    w_arr = w_arr./norm(w_arr,1);  % normalisation
    
end