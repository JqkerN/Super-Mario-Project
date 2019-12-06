function S_bar = predict(S,bounds,N)
% Calculates an estimated state 
S_bar = S + randn(size(bounds,1),N).*repmat(sqrt(diag(Sigma_R)),1,N);
% sqrt?
end
