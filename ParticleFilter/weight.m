function [w_bar, pos_outlier] = weight(S_bar,z,lambda,Sigma_Q)
global Outlier

% Calculates weights for all particles
p = zeros(size(z,2), size(S_bar,2));
pos_outlier = [0,0];
for i = 1:size(z,2)
    p(i,:) = exp(-0.5 * ((z(1,i) - S_bar(1,:)).^2/Sigma_Q(1) + (z(2,i) - S_bar(2,:)).^2/Sigma_Q(4)));
   % detect outliers
%    mean(p(i,:))
    if mean(p(i,:)) < lambda
%         disp('Outlier detected')
         Outlier = Outlier +1;
         p(i,:) = 1;
    end   
    % Normalize
    %w_bar = p(i,:)/sum(p(i,:));
end

p_prod = prod(p,1);

w_bar = p_prod./sum(p_prod);

end
