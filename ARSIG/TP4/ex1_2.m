clear all
close all

load('sig_dct.mat')

tau = 0.1*sqrt(2*log(length(y)));
indice_opti = sum(dct(y)>tau);
[x_opti_dct, tau_opti] = debruitage(dct(y), indice_opti);
x_opti = idct(x_opti_dct);

plot(x_opti)
hold on
plot(y_true)
plot(y)
title('Signaux')
xlabel('n')
ylabel('Amplitude')
legend('Signal débruité', 'Singal non bruité', 'Signal original')

snr1 = 10*log10(norm(y_true)^2/norm(y-y_true)^2);
snr2 = 10 *log10(norm(y_true)^2/norm(x_opti-y_true)^2);

fprintf('snr1 = %f\n', snr1);
fprintf('snr2 = %f\n', snr2);
