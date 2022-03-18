function s_hat = mne(x, G, lambda, method)
    n = size(G, 1);
    eps = 10^-6;
    switch  method
        case 'svd'
            [U,S,V] = svd(G*G'+eps*ones(n));
            s_hat = (U*pinv((1./S)+lambda*eye(n))*V)*x; 
        case 'pinv'
            s_hat = G'*pinv(G*G'+lambda*eye(n))*x;  
    end
   %Samy tu dis que avec svd c'est pareil mais que c'est plus rapide, il
   %faut penser à la svd plutot que pinv c'est souvent pratique.
end