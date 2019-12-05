function [outFrame] = detect(Frame, RGB, tol)
% Detects RGB color in a frame with a certain tolerans tol. 
if nargin <2
RGB = [180,50,40];
tol = 10;
end
Frame = double(Frame);
H = size(Frame,1);
W = size(Frame,2);
Frame = reshape(Frame,H*W,3);

% Filtering frame
mask = zeros(W*H,1);
dist = pdist2(Frame,RGB);
mask(dist<tol) = 1;

outFrame = reshape(mask,H,W,1);

end

