%% Use RANSAC to determine the largest possible consensus set C (affine)
% C contains the index for the matches array
function C = RANSAC_affine(fc,fc_prime,matches, outlier_rate, desired_success_rate, dist_cutoff)
    matches_per_sample = 3;    
    N = ceil(log(1-desired_success_rate) / log(1-(1-outlier_rate)^matches_per_sample));
    C = [0];
    for i = 1:N
        rand_order = randperm(size(matches,2));
        this_sample = matches(:,rand_order(1:matches_per_sample));
        X = fc(1:2,this_sample(1,:));
        X_prime = fc_prime(1:2,this_sample(2,:));
        p = solve_affine_params(X,X_prime);
        affine_mat = [1+p(3) p(4) p(1); p(5) 1+p(6) p(2)];
        
        other_ind = rand_order(matches_per_sample+1:end);
        other_matches = matches(:,other_ind);
        Z = fc(1:2,other_matches(1,:));
        Z_prime = fc_prime(1:2,other_matches(2,:));    
        Z_prime_hat = affine_mat * [Z; ones([1 size(Z,2)])];

        dist = sum((Z_prime - Z_prime_hat).^2,1).^0.5;
        C_i = [rand_order(1:matches_per_sample) other_ind(:,dist<dist_cutoff)];

        if size(C_i,2)>size(C,2)
            C = C_i;
        end   
    end
end