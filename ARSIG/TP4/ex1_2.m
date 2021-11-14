clear all
close all

load('sig_dct.mat')


tau = 0.1*sqrt(2*log(length(y_true)));
indice_opti = sum(dct(y)>tau);
[x_opti_dct, tau_opti] = debruitage(dct(y), indice_opti);
x_opti = idct(x_opti_dct);

plot(x_opti)
hold on
plot(y_true)
