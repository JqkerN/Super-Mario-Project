%% Frame Test:
% ARTHURS: Ilian Corneliussen, Andrej Wilczek & Daniel Hirsch.
% Testing the CV-part of the lab for one frame.
clear all; clf; clc;

warning('off', 'Images:initSize:adjustingMag');
vidObject = VideoReader('Firstlevel.mp4');


pants_RGB = [180,50,40];
shirt_RGB = [100,100,0];


vidObject.CurrentTime = 10; % {50: BIG Mario} {12: small Mario}

oneFrame = readFrame(vidObject);

% oneFrame = blurr(oneFrame, 0.1);

oneFrame_pants = detect(oneFrame, pants_RGB,20);
oneFrame_shirt = detect(oneFrame, shirt_RGB,20);
oneFrame_masked = oneFrame_pants + oneFrame_shirt;
se = strel('line',11,90);
oneFrame_masked = imdilate(oneFrame_masked,se);

subplot(2,1,1)
imshow(oneFrame)

subplot(2,1,2)
imshow(oneFrame_masked)
