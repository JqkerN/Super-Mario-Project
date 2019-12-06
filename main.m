%% Applied Estimation Main:
% ARTHURS: Ilian Corneliussen, Andrej Wilczek & Daniel Hirsch.
clear all; clf; close all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT PARAMETERS
VERSION = 2; % 1 or 2. 
newRGB = 0; % 0 or 1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning('off', 'Images:initSize:adjustingMag'); % Turning of warnings. 
vidObject = VideoReader('Firstlevel.mp4');      % Loading video file.
vidObject.CurrentTime = 10;                     % Skipping menu intro.

% Make color decision, 0 or 1. 
if newRGB == 0
    pants_RGB = [180,50,40];
    skin_RGB = [220,110,50];
    shirt_RGB = [100,100,0];
end

if newRGB == 1
    load(sprintf('%s\\%s\\pants_RGB',pwd,'Data'),'pants_RGB');
    load(sprintf('%s\\%s\\skin_RGB',pwd,'Data'),'skin_RGB');
    load(sprintf('%s\\%s\\shirt_RGB',pwd,'Data'),'shirt_RGB');
end



%% Version 1. 
% 1. RGB color detection for R, G, B. 
% 2. Median filtering.  (centerPoint.m)
% 3. Thresholding. (centerPoint.m)
% 4. Dilate.  (centerPoint.m)

if VERSION == 1
    while hasFrame(vidObject)
        vidFrame = readFrame(vidObject);
        vidFrame_pants = detect(vidFrame, pants_RGB,15);
        vidFrame_skin = detect(vidFrame, skin_RGB,15);
        vidFrame_shirt = detect(vidFrame, shirt_RGB,10);
        vidFrame_masked = vidFrame_pants + vidFrame_skin + vidFrame_shirt;% 
        [CP, vidFrame_masked] = centerPoint(vidFrame_masked);

        % Ploting stuff. 
        subplot(2,1,1)
        imshow(vidFrame); 
        hold on;
        plot(CP(1), CP(2), 'r+', 'MarkerSize', 10, 'LineWidth', 1);

        subplot(2,1,2)
        imshow(vidFrame_masked)
        
        pause(0.00000001) % Needed for plot update. 
    end
end


%% Verison 2.
% 1. RGB color detection for R, G, B. 
% 2. Median filtering.  (centerPoint.m)
% 3. Thresholding. (centerPoint.m)
% 4. Dilate.  (centerPoint.m)
% 5. Correlation with template. 

if VERSION == 2
    %Taking out Template.
    vidFrame = readFrame(vidObject);
    vidFrame_pants = detect(vidFrame, pants_RGB,15);
    vidFrame_skin = detect(vidFrame, skin_RGB,15);
    vidFrame_shirt = detect(vidFrame, shirt_RGB,10);
    vidFrame = vidFrame_pants + vidFrame_skin + vidFrame_shirt;
    [~, vidFrame] = centerPoint(vidFrame);
    Template = vidFrame(end-61:end-39,84:97,:); 
    
    count = 0; % Frame count.
    while hasFrame(vidObject)
        count = count + 1; 
        %Same as for Ver.1. 
        vidFrame = readFrame(vidObject);
        vidFrame_pants = detect(vidFrame, pants_RGB,15);
        vidFrame_skin = detect(vidFrame, skin_RGB,15);
        vidFrame_shirt = detect(vidFrame, shirt_RGB,10);
        vidFrame_masked = vidFrame_pants + vidFrame_skin + vidFrame_shirt;% 
        [~, Frame] = centerPoint(vidFrame_masked);
        
        % Correlation 
        correlation = normxcorr2(Template(:,:,1),Frame(:,:,1));
        [~, imax] = max((correlation(:)));
        [ymax, xmax] = ind2sub(size(correlation),imax(1));
        resize = [(xmax-size(Template,2)) (ymax-size(Template,1))];
        
        % Ploting stuff. 
        subplot(2,2,1)
        imshow(vidFrame); hold on;
        title(['Original - Tracking - Frame = ', num2str(count)])
        rectangle('position',[resize(1) resize(2) 30 30],...
                  'edgecolor','g','linewidth',2); hold off;

        subplot(2,2,2)
        imshow(correlation); hold on;
        title('Correlation - Tracking');
        plot(xmax, ymax,'r+', 'MarkerSize', 10, 'LineWidth', 1); hold off;

        subplot(2,2,3)
        imshow(Frame); hold on;
        title('Filterd - Tracking')
        rectangle('position',[resize(1) resize(2) 30 60],...
                  'curvature',[1,1],'edgecolor','g','linewidth',2); hold off;

        pause(0.00000001) % Needed for plot update. 
    end
end

