function peaks = hough_peaks(H, varargin)
    % Find peaks in a Hough accumulator array.
    %
    % Threshold (optional): Threshold at which values of H are considered to be peaks
    % NHoodSize (optional): Size of the suppression neighborhood, [M N]
    %
    % Please see the Matlab documentation for houghpeaks():
    % 
    % Your code should imitate the matlab implementation.

    %% Parse input arguments
    p = inputParser;
    addOptional(p, 'numpeaks', 1, @isnumeric);
    addParameter(p, 'Threshold', 0.5 * max(H(:)));
    addParameter(p, 'NHoodSize', floor(size(H) / 100.0) * 2 + 1);  % odd values >= size(H)/50
    parse(p, varargin{:});

    numpeaks = p.Results.numpeaks;
    threshold = p.Results.Threshold;
    nHoodSize = p.Results.NHoodSize;
    
    % Jacky: I started with array masking, but cannot find a good way of
    % finishing it. After consulting some solutions I decide to write for
    % loop instead. Here is some draft I've tried but not quite work:
    % H_new = H.*(H==ordfilt2(H,nHoodSize(1)*nHoodSize(2),ones(nHoodSize)));
    % H_new = H.*(H>=threshold);
    % val = sort(H_new(:),'descend');
    % num_local_max = length((H_new(H_new(:)>0)));
    % numpeaks = min(numpeaks,num_local_max);
    % cutoffpoint = val(numpeaks);
    % [rho, theta] = find(H_new>=cutoffpoint);
    % peaks = [rho theta];
    % peaks = peaks(1:numpeaks,:);
    
    % the one below is a really good idea. Instead of finding local maxmima
    % and then do sorting, you can find the global maximum and then remove
    % the neighbour of it and itself. This is much neater, and less prone
    % to bugs.
    
    
    drho = (nHoodSize(1) - 1)/2;
    dtheta = (nHoodSize(2) - 1)/2;
    H_new = H.*(H > threshold);
    peaks = zeros(numpeaks, 2);
    for i = 1:numpeaks
        [rho, theta] = find(H_new == max(H_new(:)));    
        if (rho(1) ~= 1) || (theta(1) ~= 1)
            peaks(i,:) = [rho(1) theta(1)];
            ind_ro_update = max(1,rho(1)-drho):min(rho(1)+drho,size(H_new,1))
            ind_ta_update = max(1,theta(1)-dtheta):min(theta(1)+dtheta,size(H_new,2))
            H_new(ind_ro_update,ind_ta_update) = H_new(ind_ro_update, ind_ta_update)*0;
        else
            peaks = peaks(1:end-1,:);
        end
    end
    
    
    
end
