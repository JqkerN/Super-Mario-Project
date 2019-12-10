function [CP, outFrame] = CV_PLOT(Frame,OG)
%BLURR Summary of this function goes here
%   INPUT [H,W,1]

set(0,'defaulttextinterpreter','latex')

subplot(2,3,1)
imshow(OG)
title('Orignial Image','FontSize', 18)

subplot(2,3,2)
imshow(Frame)
title('RGB threshold','FontSize', 18)

se = strel('square',5);
tol = 0.001;

Frame = medfilt(Frame,2,2);
subplot(2,3,3)
imshow(Frame)
title('Median filtered','FontSize', 18)

Frame(Frame > tol) = 1;
subplot(2,3,4)
imshow(Frame)
title('Threshold, tol = 0.001','FontSize', 18)


Frame = imdilate(Frame,se);
subplot(2,3,5)
imshow(Frame)
title('Dilated','FontSize', 18)





[I, J] = find(Frame == 1);
I_mean = round(mean(I));
J_mean = round(mean(J));
CP = [J_mean, I_mean];


outFrame = Frame;
end

