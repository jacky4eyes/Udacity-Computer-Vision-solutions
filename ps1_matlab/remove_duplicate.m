function [out_centers, out_radii] = remove_duplicate(centers, radii, xsize,ysize)
%%   This function is a utility which removes the duplicated concentric circles
%     The circles with the largest radius in the vicinity (11x11 area) are
%     kept.
    coverage = zeros([xsize, ysize]);
    out_centers = [];
    out_radii = [];
    for i = 1:length(radii)
        r = radii(end+1-i);
        x = centers(end+1-i,1);
        y = centers(end+1-i,2);
        if coverage(x,y) == 0
            out_centers = [out_centers;[x y]];
            out_radii = [out_radii; r];
        end
        coverage((max(1,x-5):min(xsize,x+3)),(max(1,y-5):min(ysize,y+5))) = 1;
    end
end