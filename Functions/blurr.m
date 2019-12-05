function [outFrame] = blurr(Frame,sigma)
%BLURR Summary of this function goes here
%   Detailed explanation goes here

d = 2*ceil(sigma*2) + 1;
h = fspecial('gaussian', [d d], sigma);
outFrame = imfilter(Frame, h);

end

