%% R value can be negative and can be very small, so map it to [0, 1]
function Rmat_disp = rescale_Rmat(Rmat)
    Rmat_disp = Rmat - min(min(Rmat));
    Rmat_disp = Rmat_disp / max(max(Rmat_disp ));
end