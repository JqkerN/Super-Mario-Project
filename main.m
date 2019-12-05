vidObject = VideoReader('Firstlevel.mp4');

vidObject.CurrentTime = 1;
while hasFrame(vidObject)
    vidFrame = readFrame(vidObject);
    imshow(vidFrame)
    pause(1/vidObject.FrameRate)
end