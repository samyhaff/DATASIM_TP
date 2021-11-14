clear all
close all

load('sig_peaks.mat')

sigma = 0.1;

k = 1:20;
errs = zeros(length(k),1);
seuils = zeros(length(k),1);
for i = 1:length(k)
    [x, tau] = debruitage(y, k(i));
    errs(i) = sqrt(sum((y_true - x).^2));
    seuils(i) = tau;
end

figure(1)
plot(seuils, errs);
fprintf('tau = %f\n', tau)
title('Erreur en fonction de la valeur du seuil')
xlabel('Seuil')
ylabel('Erreur')

tau = sigma*sqrt(2*log(length(y_true)));
[errmin, indice] = min(errs);
[x_opti, tau_opti] = debruitage(y,indice);

figure(2)
plot(y_true)
hold on
plot(x_opti);
legend('y\_true', 'x\_opti')

snr1 = 10*log10(norm(y_true)^2/norm(y-y_true)^2);
snr2 = 10 *log10(norm(y_true)^2/norm(x_opti-y_true)^2);

fprintf('snr1 = %f\n', snr1);
fprintf('snr2 = %f\n', snr2);
