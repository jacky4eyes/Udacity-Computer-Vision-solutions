function C = RANSAC_similarity(fc,fc_prime,matches, outlier_rate, desired_success_rate, L2_norm_cutoff)
    matches_per_sample = 2;    
    N = ceil(log(1-desired_success_rate) / log(1-(1-outlier_rate)^matches_per_sample));
    C = [0];
    for i = 1:N
        rand_order = randperm(size(matches,2));
        this_sample = matches(:,rand_order(1:matches_per_sample));
        X = fc(1:2,this_sample(1,:));
        X_prime = fc_prime(1:2,this_sample(2,:));
        p = solve_similarity(X,X_prime);
        sim_mat = [1+p(3) -p(4) p(1); p(4) 1+p(3) p(2)];
        
        other_ind = rand_order(matches_per_sample+1:end);
        other_matches = matches(:,other_ind);
        Z = fc(1:2,other_matches(1,:));
        Z_prime = fc_prime(1:2,other_matches(2,:));    
        Z_prime_hat = sim_mat * [Z; ones([1 size(Z,2)])];

        L2_norm = sum((Z_prime - Z_prime_hat).^2,1).^0.5;
        C_i = [rand_order(1:matches_per_sample) other_ind(:,L2_norm<L2_norm_cutoff)];

        if size(C_i,2)>size(C,2)
            C = C_i;
        end   
    end
end