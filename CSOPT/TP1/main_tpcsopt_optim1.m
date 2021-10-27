close all
clear all

% DEFINITION DES PARAMETRES DU PROBLEME
params.fonction='capteur';
params.b = 2;
options.maxiter = 10 ^ 3;
options.tolX = 10 ^ (-8);
options.tolG = 10 ^ (-8);
options.tolF = 10 ^ (-8);
options.method='gradient';
options.pas='fixe';
options.pasInit = 0.01;
options.beta = 0.75;
options.const = 10 ^ (-4);

% OPTIMISATION
x0 = [0.5; 3];
[xh,result,xval] = optimdescent(params.fonction,params,options,x0);

% AFFICHAGE DES RESULTATS
xh
if isequal(params.fonction,  'roszenbrock')
    visualisation
    hold on;
    plot(xval(1,:),xval(2,:),'ko');
    plot(xh(1),xh(2),'ro');
elseif isequal(params.fonction, 'capteur')
    visualisation_2
    hold on;
    plot(xval(1,:),xval(2,:),'ko');
    plot(xh(1),xh(2),'ro');
    figure;
    visualisation_3(xh(1),xh(2));
end

% ....

% A COMPLETER