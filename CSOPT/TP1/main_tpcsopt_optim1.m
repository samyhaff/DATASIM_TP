close all
clear all

% DEFINITION DES PARAMETRES DU PROBLEME
params.fonction='capteur';
params.b = 2;
options.maxiter = 10 ^ 3;
options.tolX = 10 ^ (-8);
options.tolG = 10 ^ (-8);
options.tolF = 10 ^ (-8);
options.method='newton';
options.pas='variable';
options.pasInit = 1;
options.beta = 0.75;
options.const = 10 ^ (-4);
options.lambda = 0;

% OPTIMISATION
x0 = [0.5; 2];
[xh,result,xval] = optimdescent(params.fonction,params,options,x0);

% AFFICHAGE DES RESULTATS
fprintf("xh = (%0.2f, %0.2f)\n", xh(1), xh(2))
if isequal(params.fonction,  'rosenbrock')
    visualisation
    hold on;
    plot(xval(1,:),xval(2,:),'b.');
    plot(xh(1),xh(2),'rx');
elseif isequal(params.fonction, 'capteur')
    visualisation_2
    hold on;
    plot(xval(1,:),xval(2,:),'ko');
    plot(xh(1),xh(2),'ro');
    figure;
    visualisation_3(xh(1),xh(2));
end
