function u = entree(D,A,Delta,Te)
    n = round(D/Te);
    u = zeros(n);
    t = 0:Te:D;
    u = A * square(2 * pi * t / Delta);
    u = u';
end