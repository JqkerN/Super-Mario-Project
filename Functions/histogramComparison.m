function [M, CV_estimate] = histogramComparison(vidFrame, T)
% vidObject = VideoReader('1level.mp4');      % Loading video file.
% vidObject.CurrentTime = 10;                     % Skipping menu intro.
% vidFrame = readFrame(vidObject);
% T = vidFrame(end-61:end-39,84:97,:); 
hT = imhist(T);
numRow = size(vidFrame,1)-size(T,1);
numCol = size(vidFrame,2)-size(T,2);

M = zeros(numRow,numCol);
for c = 1:numCol
    for r = 1:numRow
       partFrame = vidFrame(r:r+size(T,1)-1,c:c+size(T,2)-1);
       hF = imhist(partFrame);
       rmse=  sqrt(mean((hF-hT).^2));
       if rmse > 4 % 2 for gray, 4 for RGB
           rmse = 0;
       end
       M(r,c) = rmse;
    end
end
[I, J] = find(M > 0);
I_mean = round(mean(I));
J_mean = round(mean(J));
CV_estimate = [J_mean+size(T,1)-1, I_mean+size(T,2)-1];


% subplot(2,2,1),imshow(vidFrame);
% subplot(2,2,2),imshow(T);
% subplot(2,2,3),imhist(vidFrame);
% subplot(2,2,4),showgray(M)
end

