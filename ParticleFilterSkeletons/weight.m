% This function calcultes the weights for each particle based on the
% observation likelihood
%           S_bar(t)            4XM
%           outlier             1Xn
%           Psi(t)              1XnXM
% Outputs: 
%           S_bar(t)            4XM
function S_bar = weight(S_bar, Psi, outlier)

    % YOUR IMPLEMENTATION
    idx = 0;
    for j = 1:length(outlier)
       if outlier(1,j) == 0
           idx = idx + 1;
           Psi_legit(1,idx,:) = Psi(1,j,:);
       end
    end
    if idx > 0
        w = prod(Psi_legit,2);
        w = w/sum(w);
        S_bar(4,:) = w;
    end
    
end