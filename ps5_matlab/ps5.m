%% ps5 
clear all; clc;
addpath(genpath('..'));  % add all function exist in the 


%% 1a Lucas Kanade optical flow


Shift0 = double(imread('input/TestSeq/Shift0.png'))/255;
ShiftR2 = double(imread('input/TestSeq/ShiftR2.png'))/255;

%%


[Ix, Iy] = gaussian_gradient(Shift0, 5, 1);
It = ShiftR2 - Shift0;


Ix = normalise_img(Ix);
Iy = normalise_img(Iy);
It = normalise_img(It);


figure(1);
vl_tightsubplot(2,3,1);
imshow(Shift0)
vl_tightsubplot(2,3,2);
imshow(ShiftR2)
vl_tightsubplot(2,3,3);
imshow(It)

vl_tightsubplot(2,3,4);
imshow(Ix)

vl_tightsubplot(2,3,5);
imshow(Iy)



%%


% reuse the ps4 function 
h1 = fspecial('gauss',5, 1);
M = make_M_Matrix(Ix,Iy,h1);  % M = A'*A
temp = make_M_Matrix(Ix,It,h1);     
r1 = -temp(:,:,2);               
temp = make_M_Matrix(Iy,It,h1);     
r2 = -temp(:,:,2);  

U = zeros(size(Ix));
V = zeros(size(Ix));

for x = 1:size(Ix,2)
    for y = 1:size(Ix,1)
        this_M = reshape(M(y,x,:),[2 2]);
        if (rank(this_M) == 2)
            temp = this_M\([r1(y,x); r2(y,x)]);
            U(y,x) = temp(1);
            V(y,x) = temp(2);
        end
    end
end

U = normalise_img(U);
V = normalise_img(V);
vl_tightsubplot(2,3,6);
imshow(V)






























