signal=x3;
N=size(signal);
N=N(1);
Nf=8*2^nextpow2(N);
Fs=1;
x = 0:Fs/Nf:(Nf-1)/Nf*Fs;

y = 1/N*abs(fft(signal, Nf)).^2;
N_win=N/4;
N_noverlap=N_win/4;
periodogram_welch = pwelch(signal,N_win,N_noverlap,Nf,Fs,'twosided');

S_MUSIC= pmusic(signal,6    ,x,Fs);

subplot(2,2,1);
plot(signal);
title('Signal');
xlabel('échantillon n');
ylabel('x|n]');

subplot(2,2,2);
plot(x, y);
set(gca,'xlim',[0,Fs/2]);
title('Périodogramme du signal');
xlabel('Fréquence réduite');
ylabel('amplitude');

subplot(2,2,3);
plot(x,periodogram_welch);
set(gca,'xlim',[0,Fs/2]);
title('Périodogramme de Welch');
xlabel('Fréquence réduite');
ylabel('Amplitude');

subplot(2,2,4);
plot(x,S_MUSIC);
set(gca,'xlim',[0,Fs/2]);
title('Périodogramme MUSIC');
xlabel('Fréquence réduite');
ylabel('Amplitude');
