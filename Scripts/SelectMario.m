
clear all;clc;




vidObject = VideoReader('1level.mp4');
% vidObject.CurrentTime = 10;
possition = zeros(100,2);
figure()
idx = 0;
vidObject.CurrentTime = 10; 
while hasFrame(vidObject)
        idx = idx + 1;
        vidFrame = readFrame(vidObject);
        imshow(vidFrame)
        [xi, yi] = ginput(1); 
        possition(idx,:) = [xi, yi];
end

