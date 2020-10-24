%% map the numerical range of the input 2D array to [0, 1] 
% y = normalise_img(x)
function y = normalise_img(x)
    x_max = double(max(max(x)));
    x_min = double(min(min(x)));
    y = (double(x) - x_min) ./ (x_max - x_min); 
end