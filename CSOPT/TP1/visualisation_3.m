function visualisation_3(alpha,beta)
    E = [5013 2415 1558 1000 820 621 433 201 105 55];
    R = [0.141 0.329 0.525 0.970 1.140 1.511 2.362 5.224 12.826 25.512];
    R=R/10^3;
    plot(E,R,'-');
    E_theo=0:100:6000;
    y_theo = beta*E_theo.^-alpha;
    hold on;
    plot(E_theo,y_theo,'-r');
end