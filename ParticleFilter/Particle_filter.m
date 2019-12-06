function [estimate, particles] = Particle_filter(frame,z)



% initialize parameters %%%%%%%%%%%%%%%%%%%%%%%%
N = 100;                                            % number of particles
Sigma_Q = diag([1 1]);                                % Measurement nosie covariance matrix
Sigma_R = diag([1 1]);                                 % Process noise covariance matrix 
bounds = [size(frame,1),size(frame,2)];               % State space bounds
lambda = 0.01;                                       % Outlier threshold

     
% Sample uniformly from the state space bounds
S = [rand(1,N)*bounds(1);rand(1,N)*bounds(2)];
% Initialize equal weights
w = (1/N)*ones(1,N);


% Particle filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For i = 1:all observations:
S_bar = predict(S,bounds,N,Sigma_R);

w = weight(S_bar,z,lambda,Sigma_Q);

% Resample



end




