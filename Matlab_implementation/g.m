% constituent_code_dim is dimension of the parent node 
function [alpha_r] = g(beta_l,alpha)
    constituent_code_dim = length(alpha);
    alpha_r = zeros(1,constituent_code_dim/2);
    alpha_r(1,:) = (1-2.*beta_l(1,1:(constituent_code_dim/2))).*alpha(1,1:(constituent_code_dim/2)) + alpha(1,(constituent_code_dim/2)+1:constituent_code_dim);

%     for i=1:(constituent_code_dim/2)
%         alpha_r(1,i) = (1-2*beta_l(1,i))*alpha(1,i) + alpha(1,(constituent_code_dim/2)+i);
%     end
end