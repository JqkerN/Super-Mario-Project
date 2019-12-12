function [estimate, pos_outlier] = Particle_filter(z)
global S 

% initialize parameters %%%%%%%%%%%%%%%%%%%%%%%%
                                 
Sigma_Q = diag([9500 9500]);          % Measurement nosie covariance matrix
Sigma_R = diag([250 250]);              % Process noise covariance matrix 
lambda = 0.2;                       % Outlier threshold

[r,c] = find(z == 1);
z = [c';r'];
% Particle filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_bar(1:2,:) = predict(Sigma_R);
[S_bar(3,:), pos_outlier] = weight(S_bar,z,lambda,Sigma_Q);


% Resample
S_bar = systematic_resample(S_bar);
%S_bar = multinomial_resample(S_bar);
S = S_bar;
estimate = mean(S_bar(1:2,:),2);

x_s = max(S(1,:))-min(S(1,:));
y_s = max(S(2,:))-min(S(2,:));




end




