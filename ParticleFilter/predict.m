function S_bar = predict(Sigma_R)
global N S 
% Calculates an estimated state 
rng(10)
diff = randn(2,N).*repmat(sqrt(diag(Sigma_R)),1,N);
diff = [diff(1,:);diff(2,:)];
u = [0;0];
S_bar = S(1:2,:)+diff+u; %+ randn(size(lim,1),N).*repmat(sqrt(diag(Sigma_R)),1,N);

end
