function D = disparity_ssd(L, R)
    img_size = size(L, 1);
    win_size = 5;
    D = zeros(img_size, img_size);
    for row=1:(img_size - win_size + 1)
        L_strip = L(row:(row + win_size - 1),:);
        R_strip = R(row:(row + win_size - 1),:);
        D(row,:) = match_strips(L_strip, R_strip, win_size);
    end
    
end
