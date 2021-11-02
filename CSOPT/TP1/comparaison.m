close all
clear all

params.fonction='capteur';
params.b = 2;
options.maxiter = 10 ^ 4;
options.tolX = 10 ^ (-8);
options.tolG = 10 ^ (-8);
options.tolF = 10 ^ (-8);
options.pas='variable';
options.pasInit = 0.01;
options.beta = 0.75;
options.const = 10 ^ (-4);
options.lambda = 0.001;

x0 = [-0.5; 2];
methodes = {'gradient'; 'gradient_conjugue'; 'newton'; 'BFGS'; 'gauss-newton'; 'levenberg-marquardt'};

% figure(1)
% hold on
% title('Evolution du critere')
% xlabel('iterations')
% ylabel('critere')

for i = 1:6
    options.method = methodes(i);
    [xh,result,xval] = optimdescent(params.fonction,params,options,x0);

    % critere = zeros(result.iter-1);
    % grad = zeros(result.iter-1);
    % for i = 1:length(critere)
    %     [y, g, h, j] = rosenbrock(xval(:,i), params);
    %     critere(i) = y; grad(i) = norm(g);
    % end
    % plot(critere)

    fprintf('Méthode : %s\n', char(options.method))
    fprintf("Cause de fin : %s\n", result.stop)
    fprintf("xh = (%0.2f, %0.2f)\n", xh(1), xh(2))
    fprintf("Nb iterations : %i\n", result.iter)
    fprintf("Temps : %f\n\n", result.temps)
end
