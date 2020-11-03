%% draw the particles (center of the window)
% img_disp = draw_uv(img, S)
function img_disp = draw_uv(img, S)
    img_disp = img;
    for i = 1:size(S,1)
        img_disp(S(i,2),S(i,1),:) = [0 1 0];
    end
end