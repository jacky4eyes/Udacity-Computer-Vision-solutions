%% draw tracking window (default linewidth 3 pixels)
% win_loc is [x y w h], where (x, y) is the top-left corner of the window
%  img_disp = draw_window(img, win_loc)
function img_disp = draw_window(img, win_loc)
    img_disp = img;
    for i = -1:1
        img_disp(win_loc(2)+i, win_loc(1)-1:win_loc(1)+win_loc(3)-1,:) = repmat([0 1 1],[win_loc(3)+1 1]);
        img_disp(win_loc(2)+win_loc(4)-1+i, win_loc(1):win_loc(1)+win_loc(3),:) = repmat([0 1 1],[win_loc(3)+1 1]);
        img_disp(win_loc(2):win_loc(2)+win_loc(4), win_loc(1)+i,:) = repmat([0 1 1],[win_loc(4)+1 1]);
        img_disp(win_loc(2)-1:win_loc(2)+win_loc(4)-1, win_loc(1)+win_loc(3)-1+i,:) = repmat([0 1 1],[win_loc(4)+1 1]);
    end
end