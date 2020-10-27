%% only reduce 5 times, resulting in 6 levels; g0 is the original
% [g0,g1,g2,g3,g4,g5,g6] = REDUCE_7_levels(im, h)
function [g0,g1,g2,g3,g4,g5,g6] = REDUCE_7_levels(im, h)
    g0 = im;
    g0_fil = imfilter(g0,h);
    g1 = g0_fil(1:2:end,1:2:end);
    g1_fil = imfilter(g1,h);
    g2 = g1_fil(1:2:end,1:2:end);
    g2_fil = imfilter(g2,h);
    g3 = g2_fil(1:2:end,1:2:end);
    g3_fil = imfilter(g3,h);
    g4 = g3_fil(1:2:end,1:2:end);
    g4_fil = imfilter(g4,h);
    g5 = g4_fil(1:2:end,1:2:end);
    g5_fil = imfilter(g5,h);
    g6 = g5_fil(1:2:end,1:2:end);
end