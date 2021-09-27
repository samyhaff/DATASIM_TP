close all
clear all

% DEFINITION DES PARAMETRES DU PROBLEME
params.fonction='rosenbrock';
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
x0 = [15; -3];
[xh,result,xval] = optimdescent(params.fonction,params,options,x0);

% AFFICHAGE DES RESULTATS
% ....

% A COMPLETER