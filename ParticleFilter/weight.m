function w_bar = weight(S_bar,z,lambda,Sigma_Q)
% Calculates weights for all particles
p = exp(-0.5 * ((z(1) - S_bar(1,:)).^2/Sigma_Q(1) + (z(2) - S_bar(2,:)).^2/Sigma_Q(4)));

% detect outliers
if mean(p) < lambda
    disp('Outlier detected')
     p(:) = 1;
end
% Normalize
w_bar = p/sum(p);
end
