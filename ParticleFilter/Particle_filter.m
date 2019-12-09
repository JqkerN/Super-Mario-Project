function [estimate, pos_outlier] = Particle_filter(z)
global S 

% initialize parameters %%%%%%%%%%%%%%%%%%%%%%%%
                                 
Sigma_Q = diag([10000 20000])*1;          % Measurement nosie covariance matrix
Sigma_R = diag([80 20])*2;              % Process noise covariance matrix 
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

end




