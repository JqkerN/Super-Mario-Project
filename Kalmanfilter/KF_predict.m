function [mu_bar, Sigma_bar] = KF_predict(mu,Sigma,Sigma_R)
mu_bar = mu + [3;0];
Sigma_bar = Sigma + Sigma_R;
end
