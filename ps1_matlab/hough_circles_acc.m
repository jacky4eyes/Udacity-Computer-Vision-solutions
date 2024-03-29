function H = hough_circles_acc(BW, radius)
    % Compute Hough accumulator array for finding circles.
    %
    % BW: Binary (black and white) image containing edge pixels
    % radius: Radius of circles to look for, in pixels

    % TODO: Your code here
    [x_size,y_size] = size(BW);
    H = zeros([x_size, y_size]);
    [indx,indy] = find(BW==1);
    for i = 1:length(indx)
        x = indx(i);
        y = indy(i);
        for ta = -179:180
            a = round(x + cos(ta/180*pi)*radius); 
            b = round(y + sin(ta/180*pi)*radius);
            if (a>0)&&(b>0)&&(a<=x_size)&&(b<=y_size)
                H(a,b) = 1+H(a,b) ;
            end
        end
    end
end
