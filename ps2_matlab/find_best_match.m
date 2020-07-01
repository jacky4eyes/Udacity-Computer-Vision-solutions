function [y, best_col] = find_best_match(patch_in, strip_in)
    p_size = size(patch_in,2);
    s_size = size(strip_in,2);
%     patch_norm = patch_in./sum(sum(patch_in));    
    y = zeros([s_size-p_size 1]);
    for i = 1:(s_size-p_size+1)       
        strip_patch = strip_in(:,i:i+p_size-1);
%         strip_patch_norm = strip_patch ./sum(sum(strip_patch));    
%         y(i) = sum(sum(patch_norm .* strip_patch_norm ));
        y(i) = sum(sum((patch_in - strip_patch).^2));
    end
%    best_col = y;
%      [~, best_col] = max(y);  
     [~, best_col] = min(y);  
%      best_patch = strip_in(:,best_col:best_col+p_size-1);
%      best_x = best_x + p_size/2;
     
end