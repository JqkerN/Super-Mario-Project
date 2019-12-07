function estimate =  Kalmanfilter(z,mu,Sigma)
global Sigma mu

Sigma_Q = diag([1 1]);                 % Measurement nosie covariance matrix
Sigma_R = diag([50 50]);                   % Process noise covariance matrix 

% Predict
[mu_bar, Sigma_bar] = KF_predict(mu,Sigma,Sigma_R);

% Update
[mu, Sigma] = update(z,mu_bar,Sigma_bar,Sigma_Q);

% Dummy variable
estimate = 0;
end