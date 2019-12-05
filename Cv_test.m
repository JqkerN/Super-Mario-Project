clc
clear all

RGB = [236,0,51];

japan = imread('japan.jpg');
size(japan)
figure(1)
imshow(japan)
H = size(japan,1);
W = size(japan,2);

japan = reshape(japan,H*W,3);


mask = zeros(W*H,1);
tol = 10; 


dist = pdist2(japan,RGB);

mask(dist<tol) = 1;

mask = reshape(mask,H,W,1);
figure(2)
imshow(mask)











