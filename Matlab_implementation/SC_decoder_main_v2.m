
clc;
clear all;

n = 10; 
N = 2^n; % code length
K = N/2;

eps = 0.5; % erasure prob. for BEC channel
%channel_choice = 0; % 0 for BEC and 1 for AWGN


%% Generator matrix
F = [1 0; 1 1];
G = F;
for i = 2:n
    Z = zeros(2^(i-1),2^(i-1));
    G = [G Z; G G];
end


%% ordering of channel in terms of reliability, modification in G
% for BEC



%[non_frozen_ID] = BEC_non_frozen(eps,n,K);

%non_frozen_ID = [4,6,7,8];

% for AWGN channels
load('reliability_ordering_1024_channels.mat');
reliability_ordering_1024 = a' + ones(1,1024);
non_frozen_ID = reliability_ordering_1024(1,1024-K+1:1024);




frozen_ID = setdiff(1:N,non_frozen_ID);
u = zeros(1,N);
snr_list = [0,1,2,3];
%snr_list = [4, 5];
avg_BER = zeros(1,length(snr_list));
max_error_frame = 100;

for snr_index = 1:length(snr_list)
    error_frame_cnt = 0;
    num_of_frames = 0;
    while (error_frame_cnt <= max_error_frame)
        % information bits generation
        for i = 1:K
            u(1,non_frozen_ID(1,i)) = randi(2)-1;
        end
        
%          u
        % u = [0 0 0 0 0 0 0 0];
        
        %% Polar encoder
        x = mod(u*G,2);
        
        %% Channel modulation, AWGN noise adding, channel demodulation
        % BPSK modulation
        for i = 1:N
            if x(1,i) == 0
                x_BPSK(1,i) = 1;
            else
                x_BPSK(1,i) = -1;
            end
        end
        
        % AWGN generation
        mean = 0;
        snr = snr_list(1,snr_index); % can be changed later
        variance = 10^(-snr/10);
        noise = mean + sqrt(variance).*randn(1,N);
        
        % channel output
        y = x_BPSK + noise;
        
        % channel LLR calculation
        % soft decoder inputs
        channel_LLR = (2/variance).*y;
        
        
        
        %% SC decoder
        % channel LLRs
        alpha = zeros(1,N); % matrix of all soft-decoding values
        % beta = zeros(1,N);  % matrxi of all bits at every level
        
        % initialization
        leaf_node_ID = 0;
        alpha(1,:) = channel_LLR;
        level = 1;
        [beta,level,~] = SC_decoder_tree(alpha,level,n,frozen_ID,leaf_node_ID);
        u_decoded = mod(beta*G,2);
        % creating a recursion here
        
        err = mod(u+u_decoded,2);
        num_err_bits = sum(err);
        avg_BER(1,snr_index) = avg_BER(1,snr_index) + num_err_bits/K;
        
        % increase in the error frame count
        if num_err_bits ~=  0
            error_frame_cnt = error_frame_cnt + 1;
        end
        num_of_frames = num_of_frames + 1;
    end
    avg_BER(1,snr_index) = avg_BER(1,snr_index)/(num_of_frames-1);
    formatSpec = 'N is %d, K is %d, SNR is %4.2f(dB), \n #Error of frames is %d, #of frames is %d, \n avg ber is %7.6f \n';
    fprintf(formatSpec,N,K,snr,error_frame_cnt-1,num_of_frames-1,avg_BER(1,snr_index));
end





