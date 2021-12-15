% Script to analyse the filters used in the R peak detection algorithm

clear all
close all
clc


%% Loading data
load('HealthyECG.mat')
nbSamples = length(x);
time = (0:nbSamples-1) / Fs;
nbFreq = 1024; % Number of frequency bins


%% 1. Lowpass filter
n = 25;
num=zeros(1,n+1);
num(1)=1;
num(end)=-1;
den=[1 -1]; 
[h,W] = freqz(num,den, nbFreq);
figure(1); clf

axs1(1) = subplot(211); % Plot the gain of the filter
plot(W/pi*Fs/2,abs(h).*abs(h))
xlabel('Fréquence (Hz)')
ylabel('Magnitude (dB)')
title('lowpass')

axs1(2) = subplot(212); % Plot the phase of the filter
plot(W/pi*Fs/2,unwrap(phase(h)*2))
linkaxes(axs1, 'x');
    
    
%% 2. Filtrage passe haut

figure(2); clf
nh=125;
numh=zeros(1,nh+1);
numh(1)=-1;
numh((nh-1)/2)=nh
numh((nh-1)/2+1)=-nh
numh(end)=1
denh=den
[h_haut,W_haut] = freqz(numh,denh, nbFreq);

axs2(1) = subplot(211); % Plot the gain of the filter
plot(W_haut/pi*Fs/2,abs(h_haut))
xlabel('Fréquence (Hz)')
ylabel('Magnitude (dB)')
title('highpass')
axs2(2) = subplot(212); % Plot the phase of the filter
plot(W_haut/pi*Fs/2,unwrap(phase(h_haut)))
linkaxes(axs2, 'x');


%% 3. Derivateur


figure(3); clf
gain=Fs/8;
num_dev=[1 2 0 -2 -1]
den_dev=[0 0 1]
[h_dev,W_dev] = freqz(gain*num_dev,den_dev, nbFreq);
axs3(1) = subplot(211); % Plot the gain of the filter
plot(W_dev/pi*Fs/2,abs(h_dev))
xlabel('Fréquence (Hz)')
ylabel('Magnitude (dB)')  
title('dérivateur')
axs3(2) = subplot(212); % Plot the phase of the filter
plot(W_dev/pi*Fs/2,unwrap(phase(h_dev)))
linkaxes(axs3, 'x');


%% 4. MA
nma=149;
gain_ma=1/nma;  
num_ma=zeros(1,nma+1);
num_ma(1)=1;
num_ma(end)=-1;
den_ma=[1 -1];
[h_ma,W_ma] = freqz(gain_ma*num_ma,den_ma, nbFreq);
figure(4); clf
axs4(1) = subplot(211); % Plot the gain of the filter
plot(W_ma/pi*Fs/2,abs(h_ma))
xlabel('Fréquence (Hz)')
ylabel('Magnitude (dB)')   
title('MA')
axs4(2) = subplot(212); % Plot the phase of the filter
plot(W_ma/pi*Fs/2,unwrap(phase(h_ma)))
linkaxes(axs4, 'x');

