%%  solve LK equation 
% [U,V] = solve_LK_flow(Ix, Iy, It, h)
% h is the window ( kernel for weighted summation)
function [U,V] = solve_LK_flow(Ix, Iy, It, h)
    
    % LHS of LK equation (reuse the ps4 function)
    M = make_M_Matrix(Ix,Iy,h);  % M = A'*A
    
    % RHS of LK equation
    temp1 = make_M_Matrix(Ix,It,h);     
    temp2 = make_M_Matrix(Iy,It,h);     
    r1 = -temp1(:,:,2);               % the sum of I_x*I_t
    r2 = -temp2(:,:,2);               % the sum of I_y*I_t

    % initialise output arrays
    U = zeros(size(Ix));
    V = zeros(size(Ix));

    for x = 1:size(Ix,2)
        for y = 1:size(Ix,1)
            this_M = reshape(M(y,x,:),[2 2]);
            if (rank(this_M) == 2)   % skip when M is singular
                temp = this_M\([r1(y,x); r2(y,x)]);
                U(y,x) = temp(1);
                V(y,x) = temp(2);
            end
        end
    end
end