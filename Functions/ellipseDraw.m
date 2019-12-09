function [X,Y] = ellipseDraw(x, sigma)
%ELLIPSEDRAW Summary of this function goes here
%   Detailed explanation goes here
NP = 2^8;
alpha  = 2*pi/NP*(0:NP);
circle = [cos(alpha);sin(alpha)];
ns = 3; 

C = chol(sigma)'; %Choleski method <-????????????
ellip = ns*C*circle;
X = x(1)+ellip(1,:);
Y = x(2)+ellip(2,:);
end

