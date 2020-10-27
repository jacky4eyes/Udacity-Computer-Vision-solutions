%% expand the image by 1 level; h is the 1D version of the window function
% g1_1 is the upsized image
% if the input has size [m  n]
% then the output is [2*m-1 2*n-1]
function g1_1 = EXPAND_1_level(g1,w)
    W = w'*w;
    W_L = size(W,1);
    W_halfL = (W_L-1)/2;
    g1_1 = zeros(size(g1,1)*2-1,size(g1,2)*2-1);
    for i = 1:size(g1_1 ,1)
        for j = 1:size(g1_1 ,2)
            for m = -W_halfL:W_halfL 
                for n = -W_halfL:W_halfL 
                    ind_m = (i-m)/2;
                    ind_n = (j-n)/2;
                    if (mod(ind_m,1)==0) && (mod(ind_n,1)==0) && (ind_m>0) && (ind_n>0)
                        w = W(m+(W_L+1)/2,n+(W_L+1)/2);
                        g1_1 (i,j) = g1_1 (i,j)+ 4*w.*g1(ind_m,ind_n);
                    end
                end
            end
        end
    end
end