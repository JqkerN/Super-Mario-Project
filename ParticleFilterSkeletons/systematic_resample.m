% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = systematic_resample(S_bar)
	
    global M % number of particles 
    
    % YOUR IMPLEMENTATION
    S = zeros(4,M);
    CDF = zeros(1,M);
    for m = 1:M
       CDF(m) = sum(S_bar(4,1:m));
    end
    r0 = (1/M)*rand;
    for m = 1:M
        CDF(CDF < r0 + (m-1)/M) = inf;
        [~,i] = min(CDF);
        S(1:3,m) = S_bar(1:3, i);
        S(4,m) = 1/M;
    end
end