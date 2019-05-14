function [centers, radii] = find_circles(BW, radius_range)
    % Find circles in given radius range using Hough transform.
    %
    % BW: Binary (black and white) image containing edge pixels
    % radius_range: Range of circle radii [min max] to look for, in pixels

    % TODO: Your code here
    
    r_size = radius_range(2)-radius_range(1)+1;
    H = zeros([size(BW,1),size(BW,2),r_size]);   % Jacky: collect all layers (different radius) in order to choose proper threshold
    for r = 1:r_size
        H(:,:,r) = hough_circles_acc(BW,radius_range(1)-1+r);
    end
    H_max = max(H(:));
    fprintf('\nthe max value in the 3D H array is: %d\n', H_max)
    centers = [];
    radii = [];
    r = radius_range(1);
    for i = 1:size(H,3)
       centers_r = hough_peaks(H(:,:,i),5,'Threshold',0.5*H_max,'NHoodSize',[1 1]*7); 
       centers = [centers; centers_r];
       radii = [radii; ones([size(centers_r,1),1]).*r];
       r = r+1;
    end
    
    % Jacky: up to this point, we can remove duplicate concentric circles.
    % it shall be straightforward. it should be better to take primary
    % circles from greater radius downwards
    
    
    
    
end
