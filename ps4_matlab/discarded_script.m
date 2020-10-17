%% Notes
% MATLAB 1D digital filter does not have the option of padding.
% I don't want to impletement it, too tedious
% use 1)fspecial and then 2)imfilter instead 

x = (-floor(win_size/2)):floor(win_size/2);
y = (1/(2*pi*sigma^2).^0.5)*exp(-x.^2./(2*sigma^2));
z = y - [y(2:end) 0];

B1 = uint8(zeros(size(A)));
for i = 1:size(A,1)
    b1 = (filter(y,1,A(i,:)));
    B1(i,:) = uint8(b1);
end

for j = 1:size(A,2)
    b1 = (filter(y,1,B1(:,j)));
    B1(:,j) = uint8(b1);
end



%% continuous gaussian derivatives do not need these guys below, so discarded

diff_y = fspecial('sobel')/8;   
diff_x = diff_y';
B3y = imfilter(B,diff_y);

B3x = uint8(zeros(size(B)));
B3x(:,1:end-1) = B(:,2:end) - B(:,1:end-1);  
% B3x(:,2:end) = B(:,2:end) - B(:,1:end-1);  
% B3x = imfilter(B,diff_x);


%% plot sift descriptor "frame" direction histograms


[f,d] = vl_sift(single(transA*255),'frames',fc);
perm = randperm(size(f,2)) ;
sel = perm(1:5);
h1 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)); 