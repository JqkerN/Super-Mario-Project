%% Applied Estimation Main:
% ARTHURS: Ilian Corneliussen, Andrej Wilczek & Daniel Hirsch.
clear all; clf; clc;

warning('off', 'Images:initSize:adjustingMag');
vidObject = VideoReader('Firstlevel.mp4');

vidObject.CurrentTime = 10;
pants_RGB = [180,50,40];
shirt_RGB = [100,100,0];

while hasFrame(vidObject)
    vidFrame = readFrame(vidObject);
    vidFrame_pants = detect(vidFrame, pants_RGB,20);
    vidFrame_shirt = detect(vidFrame, shirt_RGB,20);
    vidFrame_masked = vidFrame_pants + vidFrame_shirt;

    subplot(2,1,1)
    imshow(vidFrame)
    
    subplot(2,1,2)
    imshow(vidFrame_masked)
    pause(0.00000000001)
end