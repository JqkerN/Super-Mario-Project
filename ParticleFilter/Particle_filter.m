function [estimate] = Particle_filter(z)
global S 

% initialize parameters %%%%%%%%%%%%%%%%%%%%%%%%
                                 
Sigma_Q = diag([2000 2000]);          % Measurement nosie covariance matrix
Sigma_R = diag([3 3]);                % Process noise covariance matrix 
lambda = 0.001;                       % Outlier threshold


% Particle filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_bar(1:2,:) = predict(Sigma_R);
S_bar(3,:) = weight(S_bar,z,lambda,Sigma_Q);


% Resample
S_bar = systematic_resample(S_bar);
%S_bar = multinomial_resample(S_bar);
S = S_bar;
estimate = mean(S_bar(1:2,:),2);

end




