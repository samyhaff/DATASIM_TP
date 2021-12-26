function y = seuillage_doux(z, mu)
    y = zeros(length(z),1);
    for i = 1:length(z)
       if z(i) >= mu
           y(i) = z(i) - mu;
       elseif z(i) <= -mu
           y(i) = z(i) + mu;
       end
    end
end