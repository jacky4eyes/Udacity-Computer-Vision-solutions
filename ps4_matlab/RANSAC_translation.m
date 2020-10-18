%% determine the largest possible consensus set C
% 
function C = RANSAC_translation(all_dX, outlier_rate, ...
    desired_success_rate, L2_norm_cutoff)
    matches_per_sample = 1;
    N = ceil(log(1-desired_success_rate) / log(1-(1-outlier_rate)^matches_per_sample));
    C = [0];             
    for i = 1:N        
        rand_order = randperm(size(all_dX,2));
        this_sample = all_dX(:,rand_order(1));
        other_ind = rand_order(2:end);
        other_samples = all_dX(:,other_ind);
        L2_norm = sum((this_sample - other_samples).^2,1).^0.5;
        C_i = [rand_order(1) other_ind(L2_norm<L2_norm_cutoff)];
        if size(C_i,2)>size(C,2)
            C = C_i;
        end   
    end

end