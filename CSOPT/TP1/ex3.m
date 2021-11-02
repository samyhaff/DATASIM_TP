close all
clear all

n = 100;

x = simsignal(n, 'spectre');

figure(1)
plot(x)
title('Signal de mesure')
xlabel('n')
ylabel('Amplitude')

E = std(x)^2;
variance = E / 100;
b = sqrt(variance)*randn([1, n]);
y = x + b;

figure(2)
plot(y);
title('Signal de mesure en présence de bruit')
xlabel('n')
ylabel('Amplitude')

options.maxiter = 10 ^ 3;
options.tolX = 10 ^ (-4);
options.tolG = 10 ^ (-4);
options.tolF = 10 ^ (-4);
options.method='gradient';
options.pas='variable';
options.pasInit = 0.01;
options.beta = 0.75;
options.const = 10 ^ (-4);

critfun = 'critere_debruitage';
params.y = y';
params.lambda = 0.5;
x0 = y';

[xh,result,xval] = optimdescent(critfun,params,options,x0);

figure(3)
plot(xh)
hold on
plot(x)
plot(y)
legend('signal estimé','signal original','signal bruité')

lambdas = 0:0.05:1;
err = zeros(1,length(lambdas));
xmin = zeros(n,length(lambdas));
for i = 1:length(lambdas)
    params.lambda = lambdas(i);
    [xh,result,xval] = optimdescent(critfun,params,options,x0);
    err(i) = sqrt(sum((x'-xh).^2));
    xmin(:,i) = xh;
end

figure(4)
plot(lambdas, err)
title('Erreur en fonction de lambda')
xlabel('lambda')
ylabel('Erreur')

f0 = zeros(1,length(lambdas));
f1 = zeros(1,length(lambdas));
D = diag(ones(n, 1)) - diag(ones(n-1,1),-1);
for i = 1:length(lambdas)
    f0(i) = norm(params.y - xmin(:,i)) ^ 2;
    f1(i) = norm(D * xmin(:,i))^2;
end

figure(5)
plot(f1, f0)
title('f0 en fonction de f1')
xlabel('f1')
ylabel('f0')
hold on
plot(1:length(lambdas),1:length(lambdas))
