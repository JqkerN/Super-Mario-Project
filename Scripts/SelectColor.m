%% Applied Estimation - Select Color:
% ARTHURS: Ilian Corneliussen, Andrej Wilczek & Daniel Hirsch.
clear all; clf; clc;

warning('off', 'Images:initSize:adjustingMag');
vidObject = VideoReader('Firstlevel.mp4');

vidObject.CurrentTime = 10;
vidFrame = readFrame(vidObject);

figure(1)
vidFrame = vidFrame(end-61:end-39,79:101,:);
imshow(vidFrame)


disp('SELECT PANTS COLOR!')
[xi, yi] = ginput(1); 
RGB = vidFrame(round(yi), round(xi),:);
pants_RGB = squeeze(squeeze(double(RGB)))';
disp('Pants color:');
disp(pants_RGB);
disp(' ');

disp('SELECT SKIN COLOR!')
[xi, yi] = ginput(1); 
RGB = vidFrame(round(yi), round(xi),:);
skin_RGB = squeeze(squeeze(double(RGB)))';
disp('Skin color:');
disp(skin_RGB);
disp(' ');

disp('SELECT SHIRT COLOR!')
[xi, yi] = ginput(1); 
RGB = vidFrame(round(yi), round(xi),:);
shirt_RGB = squeeze(squeeze(double(RGB)))';
disp('Shirt color:');
disp(shirt_RGB);
disp(' ');


answer = input('Want to store the new RGB values? (1/0)');
if answer == 1
    save(sprintf('%s\\%s\\pants_RGB',pwd,'Data'),'pants_RGB');
    save(sprintf('%s\\%s\\skin_RGB',pwd,'Data'),'skin_RGB');
    save(sprintf('%s\\%s\\shirt_RGB',pwd,'Data'),'shirt_RGB');
    disp('New color values are stored!!');
end

