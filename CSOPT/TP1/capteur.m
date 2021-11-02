function [f,g,h,J] = capteur(x,params)
%
% x : valeur de la variable d'optimisation
% params : structure contenant les param?tres de la fonction objectif
% f,g,H,J : fonction objectif, gradient, hessien et Jacobien
%
%
    E = [5013 2415 1558 1000 820 621 433 201 105 55];
    R = [0.141 0.329 0.525 0.970 1.140 1.511 2.362 5.224 12.826 25.512];
    R=R/10^3;
    f = 0;
    g = [0;0];
    h = zeros(2,2);
    J = zeros(2,2); % à changer
    for i=1:length(E)
        f = f + 0.5*(R(i)- x(2)*E(i)^(-x(1)))^2;
        g(1) = g(1) + (R(i)- x(2)*E(i)^(-x(1)))*x(2)*log(E(i))*E(i)^(-x(1));
        g(2) = g(2) - (R(i)- x(2)*E(i)^(-x(1)))*E(i)^(-x(1));

        h(1,1) = h(1,1)+ x(2)*log(E(i))  * (  -log(E(i))*E(i)^(-x(1))*(R(i)-x(2)*E(i)^(-x(1)))  +  x(2)*log(E(i))*E(i)^(-x(1))  );
        h(1,2) = h(1,2) + E(i)^(-x(1))*log(E(i))*(R(i)-2*x(2)*E(i)^(-x(1)));
        h(2,1) = h(1,2);
        h(2,2) = h(2,2)+E(i)^(-x(1)*2);    
    end
end