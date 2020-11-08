%% a customised function only for part 4 of PS6
% patch = grab_patch(img,S_i)
function patch = grab_patch(img,S_i)
    W = 480;
    H = 360;
    m0 = 101;
    n0 = 293;
    u = min(W,max(20,S_i(1)));
    v = min(H,max(30,S_i(2)));
    W_margin = min(W-u,u);
    H_margin = min(H-v,v);
    c = max(0.1,min(min(S_i(3),W_margin/(m0-1)*2),H_margin/(n0-1)*2));
    m = round((c*(m0-1)/2)*2);
    n = round((c*(n0-1)/2)*2);
%     [m,n,c]
    patch = img(round(v-(n-1)/2):round(v+(n-1)/2), round(u-(m-1)/2):round(u+(m-1)/2),:);
end

% 
% S_i = [282 163 1.1151] 
% W = 480;
% H = 360;
% m0 = 101;
% n0 = 293;
% u = min(W,max(20,S_i(1)));
% v = min(H,max(30,S_i(2)));
% W_margin = min(W-u,u);
% H_margin = min(H-v,v)
% 
% c = max(0.2,min(min(S_i(3),W_margin/(m0-1)*2),H_margin/(n0-1)*2));
% m = round((c*(m0-1)/2)*2);
% n = round((c*(n0-1)/2)*2);
% 
% [m,n,c]
