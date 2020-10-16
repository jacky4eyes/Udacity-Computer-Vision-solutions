pkg load image;

% Gradient Direction
function result = select_gdir(gmag, gdir, mag_min, angle_low, angle_high)
    mask1 = gmag>mag_min;
    mask2 = gdir>(angle_low);
    mask3 = gdir<(angle_high);
    mask = mask1.*mask2.*mask3;
    result = mask;
    % TODO Find and return pixels that fall within the desired mag, angle range
endfunction


%% Load and convert image to double type, range [0, 1] for convenience
img = double(imread('./3D_Saturn.png')) / 255.; 
figure(1)
img = mean(img,3);
imshow(img); % assumes [0, 1] range for double images

%% Compute x, y gradients
[gx gy] = imgradientxy(img, 'sobel'); % Note: gx, gy are not normalized

%% Obtain gradient magnitude and direction
[gmag gdir] = imgradient(gx, gy);
figure(2)
imshow(gmag / (4 * sqrt(2))); % mag = sqrt(gx^2 + gy^2), so [0, (4 * sqrt(2))]
figure(3)
imshow((gdir + 180.0) / 360.0); % angle in degrees [-180, 180]

%% Find pixels with desired gradient direction
my_grad = select_gdir(gmag, gdir, 0.05, 30, 60); % 45 +/- 15
imshow(my_grad);  % NOTE: enable after you've implemented select_gdir
