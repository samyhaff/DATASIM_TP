close all
clear all

load('HealthyECG.mat')

n = length(x);
t = (0:n-1) / Fs;
Nf = 8*2^nextpow2(n);

figure(1)
plot(t,x)
set(gca, "xlim", [35 37])
xlabel('Temps')
ylabel('Amplitude')

% spectre

y = fft(x, Nf);
f = 0:Fs/Nf:(Nf-1)/Nf*Fs;
y = 1/n*abs(y).^2;

figure(2)
plot(f, y)
set(gca, "xlim", [0 50])
xlabel('Fréquence (Hz)')
ylabel('Amplitude')
title('Spectre ECG')

% spectrogramme

h1 = hamming(0.15*Fs);
h2 = hamming(2*Fs);
h3 = hamming(15*Fs);

figure(3)
subplot(3,1,1)
spectrogram(x,h1,0.5*length(h1),16*2^nextpow2(length(h1)), Fs,'yaxis')
title('fenêtre 150ms')
set(gca, "ylim", [0 50])
subplot(3,1,2)
spectrogram(x,h2,0.5*length(h2), 8*2^nextpow2(length(h2)),Fs,'yaxis')
title('fenêtre 2s')
set(gca, "ylim", [0 50])
subplot(3,1,3)
spectrogram(x,h3,0.5*length(h3),8*2^nextpow2(length(h3)), Fs,'yaxis')
title('fenêtre 15s')
set(gca, "ylim", [0 50])
