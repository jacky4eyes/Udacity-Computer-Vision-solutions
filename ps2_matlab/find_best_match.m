function [y, best_col] = find_best_match(patch_in, strip_in)
    p_size = size(patch_in,2);
    s_size = size(strip_in,2);
    y = zeros([s_size-p_size 1]);
    for i = 1:(s_size-p_size+1)       
        strip_patch = strip_in(:,i:i+p_size-1);
        y(i) = sum(sum((patch_in(:) - strip_patch(:)).^2));
    end  
     [~, best_col] = min(y);  
end