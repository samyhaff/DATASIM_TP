function [x, tau] = debruitage(y, k)
    coeffs = sort(abs(y), 'descend');
    tau = coeffs(k);
    x = y;
    x(abs(x)<tau) = 0;
end