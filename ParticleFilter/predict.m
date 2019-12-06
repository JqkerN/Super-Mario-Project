function S_bar = predict(Sigma_R)
global N S 
% Calculates an estimated state 
diff = randn(2,N).*repmat(sqrt(diag(Sigma_R)),1,N);
diff = [diff(1,:);diff(2,:)];
S_bar = S(1:2,:)+diff; %+ randn(size(lim,1),N).*repmat(sqrt(diag(Sigma_R)),1,N);

% sqrt?
end
