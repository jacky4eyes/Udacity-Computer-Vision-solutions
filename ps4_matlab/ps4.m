%% Part 1: Harris corners


% ls ./input/transA.jpg
A = imread('./input/transA.jpg');
a = A(123,:);

% figure(1)
% imshow(a)



%% testing
A = imread('./input/transA.jpg');
win_size = 15;
sigma = 3;

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

H = fspecial('gaussian',win_size,sigma);
B2  = imfilter(A,H);



figure(99);delete(gca);delete(gca);
subplot(1,2,1);hold on
imshow(B1)
% plot(A(end,:))
% plot(b1)
% legend()

subplot(1,2,2);hold on
imshow(B2)

%%

figure(3)
imshow(B1(57:end-43,57:end-43)-B2(50:end-50,50:end-50))