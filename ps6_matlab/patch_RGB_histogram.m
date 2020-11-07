%% return 3D histogram of RGB channels (joint PMF)
% hist_patch = patch_RGB_histogram(patch, num_of_bins) 
function hist_patch = patch_RGB_histogram(patch, num_of_bins) 


    % skin histogram threshold (to improve tracking performance)
    choice_hist_min = [0.25 0.15 0.05];
    choice_hist_max = [0.7 0.5 0.60];
    
%     R_bins = 0:1/num_of_bins(1):1;  
%     G_bins = 0:1/num_of_bins(2):1;  
%     B_bins = 0:1/num_of_bins(3):1;  

    R_bins = linspace(choice_hist_min(1),choice_hist_max(1),num_of_bins(1)+1);  
    G_bins = linspace(choice_hist_min(2),choice_hist_max(2),num_of_bins(2)+1);  
    B_bins = linspace(choice_hist_min(3),choice_hist_max(3),num_of_bins(3)+1);  
    
    
    hist_patch = zeros([num_of_bins(1) num_of_bins(2) num_of_bins(3)]);
    for i = 1:num_of_bins(1)-1
        R_i = (patch(:,:,1)>=R_bins(i))&(patch(:,:,1)<R_bins(i+1));
        for j = 1:num_of_bins(2)-1
            G_j = (patch(:,:,2)>=G_bins(j))&(patch(:,:,2)<G_bins(j+1));
            for k = 1:num_of_bins(3)-1
                B_k = (patch(:,:,3)>=B_bins(k))&(patch(:,:,3)<B_bins(k+1));
                hist_patch(i,j,k) = sum(sum(R_i.*G_j.*B_k));
            end
        end
    end

end