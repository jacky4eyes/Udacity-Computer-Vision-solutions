%% dist = calc_dist_between_2_activities(MHI1,MHI2)
function dist = calc_dist_between_2_activities(MHI1,MHI2)
    MEI1 = MHI1>0;
    MEI2 = MHI2>0;
    V1 = [desired_central_moments(MHI1,true) desired_central_moments(MEI1,true)];
    V2 = [desired_central_moments(MHI2,true) desired_central_moments(MEI2,true)];
    dist = sum((V1 - V2).^2);
end