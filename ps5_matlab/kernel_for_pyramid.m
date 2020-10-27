%% return an 1D array that contains the weights of the pyramid window
% w = kernel_for_pyramid(a)
function w = kernel_for_pyramid(a)
    c = (0.5-a)/2;
    b = (a+2*c)/2;
    w = [c b a b c];
end