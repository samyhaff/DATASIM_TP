function z = probleme_direct(x, h, RSB)
    N = length(x);
    y = conv(x, h, "full");
    E_signal = sum(y.^2);
    var_bruit = E_signal*10^(-RSB/10)/N;
    z = y + sqrt(var_bruit)*randn(size(y));
end