%% a customised function only for part 4 of PS6
% S = clamp_state(S)
function S = clamp_state(S)
    W = 480;
    H = 360;
    m0 = 101;
    n0 = 293;
    for i = 1:size(S,1)
        u = min(W,max(20,S(i,1)));
        v = min(H,max(30,S(i,2)));
        W_margin = min(W-u,u);
        H_margin = min(H-v,v);
        c = max(0.1,min(min(S(i,3),W_margin/(m0-1)*2),H_margin/(n0-1)*2));
        S(i,:) = [round(u) round(v) c];
    end

end