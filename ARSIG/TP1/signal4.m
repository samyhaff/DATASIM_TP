signal=x4;
N=size(signal);
N=N(1);
Nf=64*2^nextpow2(N);
Fs=1;
x = 0:Fs/Nf:(Nf-1)/Nf*Fs;
P=6;
y = fft(signal, Nf);
y = 1/N*abs(y).^2;

[a, sigma2] =arcov(signal,P);
signalAR=signal.*a;

yAR = sigma2./abs(fft(a, Nf));
% yAR = 1/N*abs(y).^2;

subplot(1,3,1);
plot(signal);
title('Signal');
xlabel('échantillon n');

subplot(1,3,2);
plot(x, y);
set(gca,'xlim',[0,Fs/2]);
title('Périodogramme du signal');
xlabel('Fréquence réduite');

subplot(1,3,3);
plot(x,yAR);
set(gca,'xlim',[0,Fs/2]);
