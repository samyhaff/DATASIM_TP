signal=x2;
N=size(signal);
N=N(1);
Nf=16*2^nextpow2(N);
Fs=1;
x = 0:Fs/Nf:(Nf-1)/Nf*Fs;
P=4;

h=hamming(N);
S_MUSIC= pmusic(signal,P,x,Fs);
y = 1/N*abs(fft(signal, Nf)).^2;
yfenetre = 1/N*abs(fft(signal.*h, Nf)).^2;


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
ylabel('Amplitude');

subplot(1,4,3);
plot(x, yfenetre);
set(gca,'xlim',[0,Fs/2]);
title('Périodogramme du signal fenêtré (Hamming)');
xlabel('Fréquence réduite');
ylabel('Amplitude');

subplot(1,4,4);
plot(x,S_MUSIC);
title('Densité spéctrale MUSIC');
xlabel('Fréquence réduite');
ylabel('Amplitude');
set(gca,'xlim',[0,Fs/2]);
