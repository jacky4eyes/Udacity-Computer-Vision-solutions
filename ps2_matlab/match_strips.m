function disparity = match_strips(strip_L, strip_R, winsize)
    num_of_col = size(strip_L, 2);
    disparity = zeros([1 num_of_col]);
    for i=1:(num_of_col - winsize + 1)
        patch_i_L = strip_L(:, i:i+winsize-1);
        right_col_ind = max(1,i-winsize-floor(num_of_col/4)):min(i+winsize+floor(num_of_col/4), num_of_col-winsize+1);
%         right_col_ind = 1:(num_of_col-winsize+1);
        [~, best_right_i] = find_best_match(patch_i_L, strip_R(:,right_col_ind));
        best_right_i = best_right_i + (best_right_i~=0)*right_col_ind(1);
        disparity(i) = best_right_i - i; 
    end
end