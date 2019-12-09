%% Applied Estimation Main:
% ARTHURS: Ilian Corneliussen, Andrej Wilczek & Daniel Hirsch.
clear all; clf; close all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT PARAMETERS
VERSION = 3; % 1, 2, or 3.        2:Particle   3:Kalman 
newRGB = 0; % 0 or 1.
warning_mode = 'off'; % 'off' or 'on'
mpFil = '1'; % '1' or '2'. The level number.
getTemplate = true; % true or false. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(['Version: ',num2str(VERSION)])
disp(['Color absmode: ',num2str(newRGB)])
disp(['Warning mode: ',warning_mode])
disp(['Level mode: ',mpFil])
disp(['Get template: ',num2str(getTemplate)])
disp(' ')
disp('Visual Tracking of Mario - START')
disp('---------------------------------')
warning(warning_mode,'all') % Turning of warnings. 
vidObject = VideoReader([mpFil, 'level.mp4']);      % Loading video file.
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
    
    % Global variables
    global N S lim
    % Sample uniformly from the state space bounds
    N = 500;
    lim = [480,360];  
    w = (1/N)*ones(1,N);
    S = [rand(1,N)*lim(1);rand(1,N)*lim(2);w];
    
    distTol = 10;
    firstEntry = true;
    
    count = 0;
    while hasFrame(vidObject)
        count = count +1;
        vidFrame = readFrame(vidObject);
        vidFrame_pants = detect(vidFrame, pants_RGB,15);
        vidFrame_skin = detect(vidFrame, skin_RGB,15);
        vidFrame_shirt = detect(vidFrame, shirt_RGB,10);
        vidFrame_masked = vidFrame_pants + vidFrame_skin + vidFrame_shirt;% 
        [CP, vidFrame_masked] = centerPoint(vidFrame_masked);
        
        xmax = CP(1);
        ymax = CP(2);
        
        if firstEntry == true
            xold = xmax;
            yold = ymax;
            firstEntry = false;      
        end
        
        if distTol < sqrt( abs(xmax-xold) + abs(ymax - yold) )
            xmax = xold;
            ymax = yold;
        end 
        
        for i = 1:5
            estimate = Particle_filter(CP);
        end
        
        
        % Ploting stuff. 
        subplot(2,1,1)
        imshow(vidFrame); 
        title(['Original - Tracking - Frame = ', num2str(count)])
        hold on;
%         plot(CP(1), CP(2), 'r+', 'MarkerSize', 10, 'LineWidth', 1);
        plot(CP(1),CP(2),'r+','MarkerSize',10, 'LineWidth', 1);  
        plot(estimate(1),estimate(2),'g+','MarkerSize',10, 'LineWidth', 1);   hold off;
%         legend('CV estimate','Particles Center')


        subplot(2,1,2)
        imshow(vidFrame_masked); hold on;
        title(['Filtered - Tracking - Frame = ', num2str(count)])
        scatter(S(1,:),S(2,:),'b+', 'LineWidth', 1);
        plot(CP(1),CP(2),'r+','MarkerSize',10, 'LineWidth', 1);  
        plot(estimate(1),estimate(2),'g+','MarkerSize',10, 'LineWidth', 1);   hold off;
%         legend('Particles','CV estimate','Particles Center')
        

        yold = ymax;
        xold = xmax;
        pause(0.00000001) % Needed for plot update. 
    end
end


%% Verison 2. Particle Filter
% 1. RGB color detection for R, G, B. 
% 2. Median filtering.  (centerPoint.m)
% 3. Thresholding. (centerPoint.m)
% 4. Dilate.  (centerPoint.m)
% 5. Correlation with template. 

if VERSION == 2
    % Distance tolerance    % Global variables
    global N S lim
    % Sample uniformly from the state space bounds
    N = 500;
    lim = [480,360];  
    w = (1/N)*ones(1,N);
    S = [rand(1,N)*lim(1);rand(1,N)*lim(2);w];

    distTol = 10;
    firstEntry = true;
    
    if getTemplate == true
        %Taking out Template.
        vidFrame = readFrame(vidObject);
        vidFrame_pants = detect(vidFrame, pants_RGB,15);
        vidFrame_skin = detect(vidFrame, skin_RGB,15);
        vidFrame_shirt = detect(vidFrame, shirt_RGB,10);
        vidFrame = vidFrame_pants + vidFrame_skin + vidFrame_shirt;
        [~, vidFrame] = centerPoint(vidFrame);
        T = vidFrame(end-61:end-39,84:97,:); 
        % save(sprintf('%s\\%s\\T',pwd,'Data'),'T');
        % disp('Template saved.')
    else 
%         load(sprintf('%s\\%s\\T',pwd,'Data'),'T');
        load('T.mat')
    end
    
    % Global variables
    global N S lim
    % Sample uniformly from the state space bounds
    N = 500;
    lim = [480,360];  
    w = (1/N)*ones(1,N);
    S = [rand(1,N)*lim(1);rand(1,N)*lim(2);w];

    count = 0; % Frame count.
    while hasFrame(vidObject)
        count = count + 1; 
        %Same as for Ver.1. 
        vidFrame = readFrame(vidObject);
        vidFrame_pants = detect(vidFrame, pants_RGB,10);
        vidFrame_skin = detect(vidFrame, skin_RGB,10);
        vidFrame_shirt = detect(vidFrame, shirt_RGB,10);
        vidFrame_masked = vidFrame_pants + vidFrame_skin + vidFrame_shirt;% 
        [~, Frame] = centerPoint(vidFrame_masked);
        
        % Correlation 
        correlation = normxcorr2(T(:,:,1),Frame(:,:,1));
        [valueMax, imax] = max(abs(correlation(:)));
        [ymax, xmax] = ind2sub(size(correlation),imax(1));
        
        if firstEntry == true
            xold = xmax;
            yold = ymax;
            firstEntry = false;      
        end
        
        if distTol < sqrt( abs(xmax-xold) + abs(ymax - yold) )
            xmax = xold;
            ymax = yold;
        end
        
        resize = [(xmax-size(T,2)) (ymax-size(T,1))];
        for i = 1:5
            [estimate] = Particle_filter(resize);
        end
        
        
        % Ploting stuff. 
        subplot(2,2,1)
        imshow(vidFrame); hold on;
        title(['Original - Tracking - Frame = ', num2str(count)])
%         plot(estimate(1),estimate(2),'g+','MarkerSize',10, 'LineWidth', 1); hold off;
        rectangle('position',[estimate(1) estimate(2) 30 30],...
                  'edgecolor','g','linewidth',2); 
        rectangle('position',[resize(1) resize(2) 30 30],...
                  'edgecolor','r','linewidth',2); hold off;

        subplot(2,2,2)
        imshow(correlation > 0.2); hold on;
        title('Correlation - Tracking');
%         scatter(S(1,:),S(2,:),'r+', 'LineWidth', 1); hold off;

        subplot(2,2,3)
        imshow(Frame); hold on;
        title('Filterd - Tracking')
        rectangle('position',[resize(1) resize(2) 30 30],...
                  'edgecolor','r','linewidth',2); 
        scatter(S(1,:),S(2,:),'b+', 'LineWidth', 1); 
        rectangle('position',[estimate(1) estimate(2) 30 30],...
                  'edgecolor','g','linewidth',2); 
        
        subplot(2,2,4)
        imshow(T)
        
        yold = ymax;
        xold = xmax;
        pause(0.00000001) % Needed for plot update. 
    end
end


%% Verison 4. Kalman Filter
% 1. RGB color detection for R, G, B. 
% 2. Median filtering.  (centerPoint.m)
% 3. Thresholding. (centerPoint.m)
% 4. Dilate.  (centerPoint.m)
% 5. Correlation with template. 

if VERSION == 3
    % Distance tolerance
    distTol = 10;
    firstEntry = true;
    
    if getTemplate == true
        %Taking out Template.
        vidFrame = readFrame(vidObject);
        vidFrame_pants = detect(vidFrame, pants_RGB,15);
        vidFrame_skin = detect(vidFrame, skin_RGB,15);
        vidFrame_shirt = detect(vidFrame, shirt_RGB,10);
        vidFrame = vidFrame_pants + vidFrame_skin + vidFrame_shirt;
        [~, vidFrame] = centerPoint(vidFrame);
        T = vidFrame(end-61:end-39,84:97,:); 
        % save(sprintf('%s\\%s\\T',pwd,'Data'),'T');
        % disp('Template saved.')
    else 
        load(sprintf('%s\\%s\\T',pwd,'Data'),'T');
    end
    
    % Global variables
    global mu Sigma 

    count = 0; % Frame count.
    while hasFrame(vidObject)
        count = count + 1; 
        %Same as for Ver.1. 
        vidFrame = readFrame(vidObject);
        vidFrame_pants = detect(vidFrame, pants_RGB,10);
        vidFrame_skin = detect(vidFrame, skin_RGB,10);
        vidFrame_shirt = detect(vidFrame, shirt_RGB,10);
        vidFrame_masked = vidFrame_pants + vidFrame_skin + vidFrame_shirt;% 
        [~, Frame] = centerPoint(vidFrame_masked);
        
        % Correlation 
        correlation = normxcorr2(T(:,:,1),Frame(:,:,1));
        [~, imax] = max(abs(correlation(:)));
        [ymax, xmax] = ind2sub(size(correlation),imax(1));
        
        if firstEntry == true
            xold = xmax;
            yold = ymax;
            % Initialize parametes
            Sigma = eye(2);
            mu = [100 100]'; %[(xmax-size(T,2)) (ymax-size(T,1))]';
            firstEntry = false;
        end
        
        if distTol < sqrt( abs(xmax-xold) + abs(ymax - yold) )
            xmax = xold;
            ymax = yold;
        end
        
        z = [(xmax-size(T,2)) (ymax-size(T,1))]';
        for i = 1:1
            [~] = Kalmanfilter(z,mu,Sigma);
        end
        
        [X, Y] = ellipseDraw(mu,20*Sigma);
        
        
        %Ploting stuff. 
        subplot(2,2,1)
        imshow(vidFrame); hold on;
        title(['Original - Tracking - Frame = ', num2str(count)])
        plot(X,Y,'g','MarkerSize',10, 'LineWidth', 1); 
        plot(mu(1),mu(2),'b+','MarkerSize',10, 'LineWidth', 1); hold off;
%         rectangle('position',[z(1) z(2) 50 50],...
%                   'edgecolor','r','linewidth',2); hold off;
%         rectangle('position',[mu(1) mu(2) 30 30],...
%                   'edgecolor','g','linewidth',2); hold off
              
        subplot(2,2,2)
        imshow(correlation); hold on;
        title('Correlation - Tracking');
%         scatter(z(1),z(2),'r+', 'LineWidth', 1); hold off;

        subplot(2,2,3)
        imshow(Frame); hold on;
        title('Filterd - Tracking')
%         rectangle('position',[z(1) z(2) 50 50],...
%                   'edgecolor','r','linewidth',2); hold off;
%         rectangle('position',[mu(1) mu(2) 30 30],...
%                   'edgecolor','g','linewidth',2); hold off
              
%         rectangle('position',[mu(1) mu(2) 50*Sigma(1) 50*Sigma(4)],...
%                   'curvature',[1,1],'edgecolor','g','linewidth',2);
%         scatter(mu(1),mu(2),'r+', 'LineWidth', 1);
%         plot(estimate(1),estimate(2),'g+','MarkerSize',10, 'LineWidth', 1); hold off;
        % Prob ellipse not correct!!!!!!!!
        
        yold = ymax;
        xold = xmax;
        pause(0.00000001) % Needed for plot update. 
    end
end



disp('DONE.')