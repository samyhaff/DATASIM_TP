close all
clear all

load('dataCND.mat')

z = probleme_direct(x, h, inf);

figure(1)
plot(x);
hold on;
plot(z);
xlabel('n')
legend('x', 'z')
xlim([0 length(x)+1])

% solution moindres carres

z = probleme_direct(x, h, inf);

x_mc = linsolve(H'*H,H'*z);
figure(2)
plot(x_mc)
hold on
plot(x)
xlabel('n')
legend('x\_mc', 'x')
xlim([0 length(x)+1])
title('RSB infini')

z = probleme_direct(x, h, 40);

x_mc = linsolve(H'*H,H'*z);
figure(3)
plot(x_mc)
hold on
plot(x)
xlabel('n')
legend('x\_mc', 'x')
xlim([0 length(x)+1])
title('RSB infini')

% ista

max_iter = 100;
C =  max(eig(H'*H));
mu = 0.01;
z = probleme_direct(x, h, 10);
x_ista = ista(z, h, C, mu, max_iter, zeros(length(z)-length(h)+1,1));
figure(4)
plot(x)
hold on
plot(x_ista)
legend('x', 'x_ista')


load('dataplaques.mat')
figure(5)
plot(z1)

h = z1(1:250);
C = max(abs(fft(h,8*2^nextpow2(length(h)))).^2);
mu = 1;
max_iter = 1000;
x_ista1 = ista(z1, h, C, mu, max_iter, zeros(length(z1)-length(h)+1,1));

figure(6)
plot(z1)
hold on
plot(x_ista1)
legend('z1', 'z1 ista')
xlabel('n')
ylabel('z1(n)')

mu = 1;
max_iter = 1000;
%x_ista2 = ista(z2, h, C, mu, max_iter, zeros(length(z2)-length(h)+1,1));

figure(7)
plot(z2)
hold on
%plot(x_ista2)
legend('z2', 'z2 ista')
xlabel('n')
ylabel('z2(n)')