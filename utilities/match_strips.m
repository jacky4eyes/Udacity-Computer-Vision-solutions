%%
% disparity = match_strips(strip_L, strip_R, b)
%
% For each non-overlapping patch/block of width b in the left strip, find 
% the best matching position (along X-axis) in the right strip.
% Return a vector of disparities (left X-position - right X-position).
% Note: Only consider whole blocks that fit within image bounds.

function disparity = match_strips(strip_L, strip_R, b)
    num_of_col = size(strip_L,2);
    num_of_patch = floor(num_of_col / b);
    disparity = zeros([1 num_of_col ]);
    for i=1:(num_of_patch-1)
        left_col_i = (i-1)*b+1;
        patch_i_L = strip_L(:,left_col_i:i*b);
        [~, right_col_i, ~] = find_best_match(patch_i_L, strip_R);
        disparity(left_col_i:i*b) = left_col_i  - right_col_i;
    end
end