function [mu, Sigma] = update(z,mu_bar,Sigma_bar,Sigma_Q)
K = Sigma_bar*(Sigma_bar + Sigma_Q)^-1;
mu = mu_bar  + K*(z-mu_bar);
Sigma = (eye(2)-K)*Sigma_bar;
end
