function disparity = match_strips(strip_L, strip_R, winsize)
    num_of_col = size(strip_L, 2);
    disparity = zeros([1 num_of_col]);
    for i=1:(num_of_col-winsize+1)
        patch_i_L = strip_L(:,i:i+winsize-1);
        [~, right_col_i, ~] = find_best_match(patch_i_L, strip_R);
        disparity(i) = right_col_i - i; 
    end
end