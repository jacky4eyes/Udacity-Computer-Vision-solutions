function D = disparity_ssd(L, R, winsize)
    img_length = size(L, 1);
    img_width = size(L, 2);
    D = zeros(img_length, img_width);
    parfor row=1:(img_length - winsize + 1)
        L_strip = L(row:(row + winsize - 1),:);
        R_strip = R(row:(row + winsize - 1),:);
        D(row,:) = match_strips(L_strip, R_strip, winsize);
    end
end
