function x = ista(z, h, C, mu, max_iter, x0)
    for q = 1:max_iter
        x0 = seuillage_doux(x0 + 1/C*conv(z - conv(x0, h, 'full'), flip(h), 'valid'),mu/C);
    end
    x = x0;
end