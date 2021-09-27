signal=x3;
N=size(signal);
N=N(1);
Nf=8*2^nextpow2(N);
Fs=1;
x = 0:Fs/Nf:(Nf-1)/Nf*Fs;

y = fft(signal, Nf);
y = 1/N*abs(y).^2;
N_win=2^nextpow2(N/2);
N_noverlap=0.5;
periodogram_welch = pwelch(signal,N_win,N_noverlap,Nf,Fs,'twosided');

subplot(1,3,1);
plot(signal);

subplot(1,3,2);
plot(x, y);
set(gca,'xlim',[0,Fs/2]);

subplot(1,3,3);
plot(x,periodogram_welch);
set(gca,'xlim',[0,Fs/2]);
