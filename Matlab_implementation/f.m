% constituent_code_dim is dimension of the parent node 
function [alpha_l] = f(alpha)
    constituent_code_dim = length(alpha);
    alpha_l = zeros(1,constituent_code_dim/2); % left child
    alpha_l(1,:) = 2.*atanh(tanh(alpha(1,1:(constituent_code_dim)/2)/2).*tanh(alpha(1,(constituent_code_dim/2)+1:constituent_code_dim)/2));

%     for i = 1:(constituent_code_dim/2)
%         a = alpha(1,i);
%         b = alpha(1,(constituent_code_dim/2)+i);
%         alpha_l(1,i) = 2*atanh(tanh(a/2)*tanh(b/2));
%     end
end