% This function performs the ML data association
%           S_bar(t)                 4XM
%           z(t)                     2Xn
%           association_ground_truth 1Xn | ground truth landmark ID for
%           every measurement
% Outputs: 
%           outlier                  1Xn
%           Psi(t)                   1XnXM
function [outlier, Psi, c] = associate(S_bar, z, association_ground_truth)
    if nargin < 3
        association_ground_truth = [];
    end

    global DATA_ASSOCIATION % wheter to perform data association or use ground truth
    global lambda_psi % threshold on average likelihood for outlier detection
    global Q % covariance matrix of the measurement model
    global M % number of particles
    global N % number of landmarks
    global landmark_ids % unique landmark IDs
    
    % YOUR IMPLEMENTATION
    
%     disp(['N = ', num2str(N)])
%     disp(['M = ', num2str(M)])
%     disp(['z = ', num2str(size(z))])
%     disp(['size Q = ', num2str(size(Q))])
% 
%     n = size(z,2); % number of observations.
%     outlier = zeros(1,n);
%     Psi = zeros(1,n,M);
%     Psi_i = zeros(M,N);
%     c = zeros(1,n,M);
%     
%     for i = 1:n
%        for k = 1:N
%           z_h = observation_model(S_bar,k);
%           z_i = repmat(z(:,i),1,M);
%           nu_i = z_i - z_h;
%           nu_i(2,:) = mod(nu_i(2,:) + pi, 2*pi) - pi; 
%           Psi_i(:,k) = diag( 1/(2*pi*sqrt(det(Q))) * exp(-0.5*nu_i'*inv(Q)*nu_i) );
%        end
%        [Value, Index] = max(Psi_i,[],2);
%        Psi(1,i,:) = Value;
%        c(1,i,:) = Index;
%        outlier(1,i) = 1/M*sum(Psi(1,i,:)) <= lambda_psi;
%     end

    n = size(z,2); % number of observations.
    outlier = zeros(1,n);
    Qrepmat = repmat(diag(Q),1,M,N);
    z_h = zeros(2,M,N);
    Psi = zeros(1,n,M);
    c = zeros(1,n,M);
    for k = 1:N
        z_h(:,:,k) = observation_model(S_bar,k);
    end     
    for i = 1:n
        
%         disp(['size z_h = ', num2str(size(z_h))])
        z_i = repmat(z(:,i),1,M,N);
%         disp(['size z_i = ', num2str(size(z_i))])
        nu_i = z_i - z_h;
%         disp(['size nu_i = ', num2str(size(nu_i))])
        nu_i(2,:,:) = mod(nu_i(2,:,:) + pi, 2*pi) - pi;
        Psi_i = squeeze( 1/(2*pi*sqrt(det(Q))) * exp(-0.5*sum(nu_i./Qrepmat.*nu_i)) );
%         disp(['size Psi_i = ', num2str(size(Psi_i))])
        [Psi(1,i,:),c(1,i,:)] = max(Psi_i,[],2);
%         Psi(1,i,:) = Psi_i(c_i);
        outlier(1,i) = 1/M*sum(Psi(1,i,:)) <= lambda_psi;
%         disp(['size Psi = ', num2str(size(Psi))])
%         disp(['size outliers = ', num2str(size(outlier))])
%         disp(outlier)
    end

end