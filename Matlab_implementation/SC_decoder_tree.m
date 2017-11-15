function [beta,level,leaf_node_ID_updated] = SC_decoder_tree(alpha,level,n,frozen_ID,leaf_node_ID)
    % input to each node in SC decoder tree is LLR "alpha" and output is constituent codeword "beta"
    if level < (n+1)  % if not a leaf node 
        % left branch
        alpha_l = f(alpha); % determining the left child's LLR
        [beta_l,level,leaf_node_ID1] = SC_decoder_tree(alpha_l,level+1,n,frozen_ID,leaf_node_ID); % determining the codeword coming from the left child
        
        %right branch
        alpha_r = g(beta_l,alpha); % determining the right child's LLR
        [beta_r,level,leaf_node_ID_updated] = SC_decoder_tree(alpha_r,level+1,n,frozen_ID,leaf_node_ID1); % determining the codeword coming from right child
        
        % determining beta
        constituent_code_dim = length(alpha);
        beta(1,1:constituent_code_dim/2) = mod(beta_l+beta_r,2);
        beta(1,(constituent_code_dim/2)+1:constituent_code_dim) = beta_r;
    else % is a leaf node 
        % Hard decision decoding at leaf node
        leaf_node_ID_updated = leaf_node_ID + 1;
        if (ismember(leaf_node_ID_updated,frozen_ID) == 1)
            beta = 0;
        else
            if alpha >= 0
                beta = 0;
            else
                beta = 1;
            end
        end
    end
    level = level - 1;
end