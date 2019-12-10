clear all; clf; close all; clc;
set(0,'defaulttextinterpreter','latex')
vidObject = VideoReader('1level.mp4');      % Loading video file.
vidObject.CurrentTime = 10;                     % Skipping menu intro.


pants_RGB = [180,50,40];
skin_RGB = [220,110,50];
shirt_RGB = [100,100,0];

vidFrame = readFrame(vidObject);
OG = vidFrame;
vidFrame_pants = detect(vidFrame, pants_RGB,15);
vidFrame_skin = detect(vidFrame, skin_RGB,15);
vidFrame_shirt = detect(vidFrame, shirt_RGB,10);
vidFrame = vidFrame_pants + vidFrame_skin + vidFrame_shirt;
CV_PLOT(vidFrame, OG);