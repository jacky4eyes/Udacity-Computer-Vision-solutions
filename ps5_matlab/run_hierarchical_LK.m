%% hierarchical Lucas-Kanade with desired starating level as "n"
% currently n<=7, but usually the size becomes very awkward.
% so recommend n<=5
% [U, V] = run_hierarchical_LK(orig_1, orig_2, w, h, start_n)
function [U, V] = run_hierarchical_LK(orig_1, orig_2, w, h, start_n)

    % make Gaussian images compact
    
    if start_n <= 4
        [orig_1_g0, orig_1_g1, orig_1_g2, orig_1_g3] = REDUCE_4_levels(orig_1,w);
        [orig_2_g0, orig_2_g1, orig_2_g2, orig_2_g3] = REDUCE_4_levels(orig_2,w);
        Pyr1 = {orig_1_g0, orig_1_g1, orig_1_g2, orig_1_g3};
        Pyr2 = {orig_2_g0, orig_2_g1, orig_2_g2, orig_2_g3};
    elseif start_n == 5    
        [orig_1_g0, orig_1_g1, orig_1_g2, orig_1_g3, orig_1_g4] = REDUCE_5_levels(orig_1,w);
        [orig_2_g0, orig_2_g1, orig_2_g2, orig_2_g3, orig_2_g4] = REDUCE_5_levels(orig_2,w); 
        Pyr1 = {orig_1_g0, orig_1_g1, orig_1_g2, orig_1_g3, orig_1_g4};
        Pyr2 = {orig_2_g0, orig_2_g1, orig_2_g2, orig_2_g3, orig_2_g4};
    elseif start_n == 6
        [orig_1_g0,orig_1_g1,orig_1_g2,orig_1_g3,orig_1_g4,orig_1_g5] = REDUCE_6_levels(orig_1,w);
        [orig_2_g0,orig_2_g1,orig_2_g2,orig_2_g3,orig_2_g4,orig_2_g5] = REDUCE_6_levels(orig_2,w); 
        Pyr1 = {orig_1_g0,orig_1_g1,orig_1_g2,orig_1_g3,orig_1_g4,orig_1_g5};
        Pyr2 = {orig_2_g0,orig_2_g1,orig_2_g2,orig_2_g3,orig_2_g4,orig_2_g5};
    else
        [orig_1_g0,orig_1_g1,orig_1_g2,orig_1_g3,orig_1_g4,orig_1_g5,orig_1_g6] = REDUCE_7_levels(orig_1,w);
        [orig_2_g0,orig_2_g1,orig_2_g2,orig_2_g3,orig_2_g4,orig_2_g5,orig_2_g6] = REDUCE_7_levels(orig_2,w); 
        Pyr1 = {orig_1_g0,orig_1_g1,orig_1_g2,orig_1_g3,orig_1_g4,orig_1_g5,orig_1_g6};
        Pyr2 = {orig_2_g0,orig_2_g1,orig_2_g2,orig_2_g3,orig_2_g4,orig_2_g5,orig_2_g6};        
    end
    
    % initialise empty motion vector fields
    U = zeros(size(Pyr1{start_n}));
    V = zeros(size(Pyr1{start_n}));
    
    % start from the top level of interest
    for i = start_n:-1:1
        
        % choose appropriate Gaussian images
        im1 = Pyr1{i};
        im2 = Pyr2{i};
        
        % calculate the U and V
        [U, V] = do_warp_and_LK(im1, im2, U, V, h);
        
        % expand size for next iteration, unless this is the bottom level
        if i > 1
            U = 2.*EXPAND_1_level(U,w);
            V = 2.*EXPAND_1_level(V,w);
        end
    end
    
end