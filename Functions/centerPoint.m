function [CP, outFrame] = centerPoint(Frame)
%BLURR Summary of this function goes here
%   INPUT [H,W,1]
se = strel('square',5);
tol = 0.001;
Frame = medfilt(Frame,2,2);
Frame(Frame > tol) = 1;
Frame = imdilate(Frame,se);

[I, J] = find(Frame == 1);
I_mean = round(mean(I));
J_mean = round(mean(J));
CP = [J_mean, I_mean];


outFrame = Frame;
end

