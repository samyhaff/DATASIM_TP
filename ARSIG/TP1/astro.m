N=length(win);
Nf=2^12;
Fs=1/0.025;
f = 0:Fs/Nf:(Nf-1)/Nf*Fs;
y = fft(win, Nf);
y = abs(y).^2;

figure(1);
subplot(1,2,1);
plot(t, win);
title('fenêtre d''observation');
xlabel('temps (jour)');
% set(gca,'ylim',[0,1.1]);

subplot(1,2,2);
plot(f, y);
set(gca,'xlim',[0,Fs/2]);
title('Transformée de Fourier en module de win');
xlabel('Fréquence réduite');

y = fft(x.*win, Nf);
y = 1/N*abs(y).^2;

figure(2);
subplot(1,2,1);
plot(t, x .* win);
title('Signal');
xlabel('temps (jour)');

subplot(1,2,2);
plot(f, y);
set(gca,'xlim',[0,Fs/2]);
title('Périodogramme du signal');
xlabel('Fréquence réduite');

residu = x.*win;
M = max(y);
iter = 1
tolerance = 8
while M > tolerance 
    [M, i] = max(y);
    f_est = f(i);
    [amp_est, phi_est] = estim_amp_phase(residu, t, f_est);
    contrib = amp_est * sin(2 * pi * f_est * t + phi_est);
    residu = residu - contrib;
    y = fft(residu, Nf);
    y = 1/N*abs(y).^2;

    printf('Itération : %d    Composante détectée : %d\n', iter, f_est);
    figure(3 + iter);
    subplot(1,2,1);
    plot(t, residu);
    title('Residu');
    xlabel('temps (jour)');
    subplot(1,2,2);
    plot(f, y);
    set(gca,'xlim',[0,Fs/2]);
    title('Transformee de Fourier du residu');
    xlabel('temps (jour)');

    iter = iter + 1;
end
