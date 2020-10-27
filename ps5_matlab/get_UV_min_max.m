%%  input has to be a cell
% [total_min, total_max] = get_UV_min_max(X)
function [total_min, total_max] = get_UV_min_max(X)
    total_max = 0;
    total_min = 0;
    for i = 1:size(X,2)
        arr = X{i};
        total_max = max(max(max(arr)),total_max);
        total_min = min(min(min(arr)),total_min);
    end
end