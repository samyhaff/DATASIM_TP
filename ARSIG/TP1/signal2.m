signal=x2;
N=size(signal);
N=N(1);
Nf=16*2^nextpow2(N);
Fs=1;
x = 0:Fs/Nf:(Nf-1)/Nf*Fs;

h=blackman(N);
P=4;
y = fft(signal, Nf);
yfenetre = fft(signal.*h, Nf);

y = 1/N*abs(y).^2;
yfenetre =1/N*abs(yfenetre).^2;
% S_MUSIC= pmusic(signal,P,x,Fs);

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
plot(x, yfenetre);
set(gca,'xlim',[0,Fs/2]);
% plot(x,S_MUSIC);
% set(gca,'xlim',[0,Fs/2]);
