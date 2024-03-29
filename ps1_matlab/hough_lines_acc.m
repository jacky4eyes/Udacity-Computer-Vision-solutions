function [H, theta, rho] = hough_lines_acc(BW, varargin)
    % Compute Hough accumulator array for finding lines.
    %
    % BW: Binary (black and white) image containing edge pixels
    % RhoResolution (optional): Difference between successive rho values, in pixels
    % Theta (optional): Vector of theta values to use, in degrees
    %
    % Please see the Matlab documentation for hough():
    % http://www.mathworks.com/help/images/ref/hough.html
    % Your code should imitate the Matlab implementation.
    %
    % Pay close attention to the coordinate system specified in the assignment.
    % Note: Rows of H should correspond to values of rho, columns those of theta.

    %% Parse input arguments
    p = inputParser();
    addParameter(p, 'RhoResolution', 1); % Jacky: the 3rd argument is the default for this parameter
    addParameter(p, 'Theta', linspace(-90, 89, 180));
    parse(p, varargin{:});

    rhoStep = p.Results.RhoResolution;
    theta = p.Results.Theta;
    
    %% TODO: Your code here
    diag_dist = norm(size(BW));   % diagonal length
    nrho = 2*ceil(diag_dist/rhoStep)+1;     % axis 1 size of H matrix 
    diag = ceil(diag_dist/rhoStep)*rhoStep;   % discrete length of diagonal
    rho = -diag:diag;
    ntheta = length(theta);
    H = zeros(nrho,ntheta);
    [idy, idx] = find(BW==1);
    for i = 1:length(idx)
        for j =  1:ntheta
            ta = (theta(j))/180*pi;
            d = idx(i)*cos(ta) + idy(i)*sin(ta);
            H(round(d)+diag,j) = H(round(d)+diag,j)+1;
        end
    end
end
