% function S = multinomial_resample(S_bar)
% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       structure
% Outputs:
%           S(t):           structure
function S_tmp = multinomial_resample(S_bar)
global N
cdf = cumsum(S_bar(3,:));

S_tmp = zeros(size(S_bar));
for m = 1 : N
    r_m = rand;
    i = find(cdf >= r_m,1,'first');
    S_tmp(:,m) = S_bar(:,i);
end
S_tmp(3,:) = 1/N*ones(size(S_bar(3,:)));
end