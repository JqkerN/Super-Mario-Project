%% Applied Estimation Main:
% ARTHURS: Ilian Corneliussen, Andrej Wilczek & Daniel Hirsch.
clear all; clf; clc;

warning('off', 'Images:initSize:adjustingMag');
vidObject = VideoReader('Firstlevel.mp4');

vidObject.CurrentTime = 10;
pants_RGB = [180,50,40];
skin_RGB = [220,110,50];
shirt_RGB = [100,100,0];
se = strel('square',10);
sigma = 3;
tol = 0.001;

while hasFrame(vidObject)
    vidFrame = readFrame(vidObject);
    vidFrame_pants = detect(vidFrame, pants_RGB,15);
    vidFrame_skin = detect(vidFrame, skin_RGB,15);
    vidFrame_shirt = detect(vidFrame, shirt_RGB,10);
    vidFrame_masked = vidFrame_pants + vidFrame_skin + vidFrame_shirt;% vidFrame_skin +
    [CP, vidFrame_masked] = centerPoint(vidFrame_masked);
    
    subplot(2,1,1)
    imshow(vidFrame); 
    hold on;
    plot(CP(2),CP(1), 'r+', 'MarkerSize', 10, 'LineWidth', 1);
    
    subplot(2,1,2)
    imshow(vidFrame_masked)
    pause(0.001)
end