function [f,g,h,J] = critere_debruitage(x, params)
    f0 = norm(params.y - x) ^ 2;
    n = length(x);
    D = diag(ones(n, 1)) - diag(ones(n-1,1),-1);
    f1 = norm(D * x')^2;
    f = (1 - params.lambda) * f0 + params.lambda * f1;
    g = -2 * (1 - params.lambda) * (params.y - x)' + 2 * params.lambda * D' * D * x';
    h = 2 * (1 - params.lambda) + 2 * params.lambda * D' * D;
    J = 0; % à changer
end