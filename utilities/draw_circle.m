%% draw circle on an RGB image
% both C and r could be floating point numbers
% img_disp = draw_circle(img)
function img_disp = draw_circle(img, C, r)
    x_max = size(img, 2);
    y_max = size(img, 1);
    img_disp = img;
    for i = -1:0.01:1
        theta = pi*i;
        x = min(max(1,round(C(1) + r*cos(theta))),x_max);
        y = min(max(1,round(C(2) + r*sin(theta))),y_max);
        img_disp(y,x,:) = [1 0 0];
    end
end
