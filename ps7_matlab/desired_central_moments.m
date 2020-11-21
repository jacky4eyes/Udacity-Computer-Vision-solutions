%% compute the particular central moments desired by question 2
% return a vector v that contains the moments satisfying these pq pairs:
% {20, 02, 12, 21, 22, 30, 03} 
% I never checked this part properly, take it with a grain of salt...

% v = desired_central_moments(img, is_scale_invariant)
function v = desired_central_moments(img, is_scale_invariant)
    % set the is_scale_invariant falg to false as default 
    if ~exist('is_scale_invariant','var')
          is_scale_invariant = false;
     end
    M_00 = raw_moments(img,0,0);    
    M_10 = raw_moments(img,1,0);
    M_01 = raw_moments(img,0,1);    
    x_bar = M_10/M_00;
    y_bar = M_01/M_00;
    M_20 = raw_moments(img,2,0);
    M_02 = raw_moments(img,0,2);
    M_11 = raw_moments(img,1,1);
    M_12 = raw_moments(img,1,2);
    M_21 = raw_moments(img,2,1);
    M_22 = raw_moments(img,2,2);
    M_30 = raw_moments(img,3,0);
    M_03 = raw_moments(img,0,3);

    mu_20 = M_20 - x_bar*M_10;
    mu_02 = M_02 - y_bar*M_01;
    mu_12 = M_12 - 2*y_bar*M_11 - x_bar*M_02 + 2*y_bar^2*M_10;
    mu_21 = M_21 - 2*x_bar*M_11 - y_bar*M_20 + 2*x_bar^2*M_01;
    mu_22 = M_22 - 2*x_bar*M_12 + x_bar^2*M_02 ...
          - 2*y_bar*M_21 + 4*x_bar*y_bar*M_11 - 2*x_bar^2*y_bar*M_01 ...
          + y_bar^2*M_20 - 2*x_bar*y_bar^2*M_10 + x_bar^2*y_bar^2;
    mu_30 = M_30 - 3*x_bar*M_20 + 2*x_bar^2*M_10;
    mu_03 = M_03 - 3*y_bar*M_02 + 2*y_bar^2*M_01;
    
    if ~is_scale_invariant
        v = [mu_20, mu_02, mu_12, mu_21, mu_22, mu_30, mu_03];   
    else
        v = [mu_20/M_00^2, mu_02/M_00^2, mu_12/M_00^2.5, mu_21/M_00^2.5,...
             mu_22/M_00^3, mu_30/M_00^2.5, mu_03/M_00^2.5];   
    end
    
end