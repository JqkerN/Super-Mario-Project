%% Applied Estimation Main:
% ARTHURS: Ilian Corneliussen, Andrej Wilczek & Daniel Hirsch.
clear all; close all; clf; clc;

warning('off', 'Images:initSize:adjustingMag');
vidObject = VideoReader('Firstlevel.mp4');

vidObject.CurrentTime = 10;
pants_RGB = [180,50,40];
skin_RGB = [220,110,50];
shirt_RGB = [100,100,0];

NewRGB = 0;
if NewRGB == 1
    load(sprintf('%s\\%s\\pants_RGB',pwd,'Data'),'pants_RGB');
    load(sprintf('%s\\%s\\skin_RGB',pwd,'Data'),'skin_RGB');
    load(sprintf('%s\\%s\\shirt_RGB',pwd,'Data'),'shirt_RGB');
end

while hasFrame(vidObject)
    vidFrame = readFrame(vidObject);
    vidFrame_pants = detect(vidFrame, pants_RGB,15);
    vidFrame_skin = detect(vidFrame, skin_RGB,15);
    vidFrame_shirt = detect(vidFrame, shirt_RGB,10);
    vidFrame_masked = vidFrame_pants + vidFrame_skin + vidFrame_shirt;% 
    [CP, vidFrame_masked] = centerPoint(vidFrame_masked);

    
    subplot(2,1,1)
    imshow(vidFrame); 
    hold on;
    plot(CP(1), CP(2), 'r+', 'MarkerSize', 10, 'LineWidth', 1);
    
    subplot(2,1,2)
    imshow(vidFrame_masked)
    pause(0.00000001)
end
