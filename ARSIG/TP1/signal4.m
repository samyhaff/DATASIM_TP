signal=x4;
N=size(signal);
N=N(1);
Nf=64*2^nextpow2(N);
Fs=1;
x = 0:Fs/Nf:(Nf-1)/Nf*Fs;
p=6;
y = fft(signal, Nf);
y = 1/N*abs(y).^2;

S_MUSIC= pmusic(signal,4,x,Fs);

[a, sigma2] =arcov(signal,p);
yAR = (sigma2./abs(fft(a, Nf))).^2;

subplot(1,4,1);
plot(signal);
title('Signal');
xlabel('échantillon n');
ylabel('x[n]');

subplot(1,4,2);
plot(x, y);
set(gca,'xlim',[0,Fs/2]);
title('Périodogramme du signal');
xlabel('Fréquence réduite');
ylabel('amplitude');

subplot(1,4,3);
plot(x, S_MUSIC);
set(gca,'xlim',[0,Fs/2]);
title('Périodogramme Music');
xlabel('Fréquence réduite');
ylabel('Densité spectrale MUSIC');

subplot(1,4,4);
plot(x,yAR);
title('modelisation auto regressive');
xlabel('Fréquence réduite');
ylabel('Debsuté spectrake AR');
set(gca,'xlim',[0,Fs/2]);
