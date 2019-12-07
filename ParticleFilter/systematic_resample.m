% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S_tmp = systematic_resample(S_bar)
	
    global N % number of particles 

    S_tmp = zeros(3,N);
    CDF = cumsum(S_bar(3,:));
    r_0 = (1/N)*rand;
    for m =1:N
        i = find(CDF >= r_0 + (1/N)*(m-1), 1);
        S_tmp(1:2,m) = S_bar(1:2,i);
    end
    S_tmp(3,:) = 1/N;
end
    

%     % YOUR IMPLEMENTATION
%     S_tmp = zeros(3,N);
%     CDF = zeros(1,N);
%     for m = 1:N
%        CDF(m) = sum(S_bar(2,1:m));
%     end
%     r0 = (1/N)*rand;
%     for m = 1:N
%         CDF(CDF < r0 + (m-1)/N) = inf;
%         [~,i] = min(CDF);
%         S_tmp(1:2,m) = S_bar(1:2, i);
%         S_tmp(3,m) = 1/N;
%     end
% end