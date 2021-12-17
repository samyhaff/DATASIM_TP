% Script to estimate and apply spatial filtering

clear all
close all
clc


%% Loading data
load('FetalECG.mat')

[nbSamples, nbSensors] = size(x);
time = (0:nbSamples-1) / Fs;
Ts   = 1/Fs;


%% Preprocessing: highpass filtering to remove baseline on each channel

n_filter = 1000/40;
num = zeros(2*(n_filter+1),1);
num(1) = -1/(2*n_filter+1);
num(n_filter+1) = 1;
num(n_filter+2) = -1;
num(end) = 1/(2*n_filter+1);
den = [1, -1];

x_filtre = filter(num,den,x);


%% R peak detection

[rPeak_1, ~, ~] = ecgRPeakDetector(x_filtre(:,1), 25, 125, 149, 60, Fs);
[rPeak_2, ~, ~] = ecgRPeakDetector(x_filtre(:,2), 25, 125, 149, 60, Fs);
[rPeak_3, ~, ~] = ecgRPeakDetector(x_filtre(:,3), 25, 125, 149, 60, Fs);
[rPeak_4, ~, ~] = ecgRPeakDetector(x_filtre(:,4), 25, 125, 149, 60, Fs);


%% Spatial fitlers estimated by PiCA

[y_1, ~, ~] = periodicComponentAnalysis(x_filtre(:,1), rPeak_1);
[y_2, ~, ~] = periodicComponentAnalysis(x_filtre(:,2), rPeak_2);
[y_3, ~, ~] = periodicComponentAnalysis(x_filtre(:,3), rPeak_3);
[y_4, ~, ~] = periodicComponentAnalysis(x_filtre(:,4), rPeak_4);


%% Comparison with PCA

V = cov(x_filtre);
[eig_val,eig_vect] = eig(V);
[eig_val,ind] = sort(diag(eig_val), 'descend');
eig_vect = eig_vect(ind,:);
PCA = x_filtre * eig_vect;

%% Comparison with ICA

ICA = x_filtre*BSS(x_filtre',4);


%% Figures

figure()

subplot(4,4,1)
plot(time, x_filtre(:,1))
title('canal 1')
xlabel('temps')
xlim([0 8])
subplot(4,4,2)
plot(time, y_1)
xlabel('temps')
xlim([0 8])
title('PiCA')
subplot(4,4,3)
plot(time, PCA(:,1))
xlabel('temps')
xlim([0 8])
title('PCA')
subplot(4,4,4)
plot(time, ICA(:,1))
xlabel('temps')
xlim([0 8])
title('ICA')

subplot(4,4,5)
plot(time, x_filtre(:,2))
title('canal 2')
xlabel('temps')
xlim([0 8])
subplot(4,4,6)
plot(time, y_2)
xlabel('temps')
xlim([0 8])
subplot(4,4,7)
plot(time, PCA(:,2))
xlabel('temps')
xlim([0 8])
subplot(4,4,8)
plot(time, ICA(:,2))
xlabel('temps')
xlim([0 8])

subplot(4,4,9)
plot(time, x_filtre(:,3))
title('canal 3')
xlabel('temps')
xlim([0 8])
subplot(4,4,10)
plot(time, y_3)
xlabel('temps')
xlim([0 8])
subplot(4,4,11)
plot(time, PCA(:,3))
xlabel('temps')
xlim([0 8])
subplot(4,4,12)
plot(time, ICA(:,3))
xlabel('temps')
xlim([0 8])

subplot(4,4,13)
plot(time, x_filtre(:,4))
title('canal 4')
xlabel('temps')
xlim([0 8])
subplot(4,4,14)
plot(time, y_4)
xlabel('temps')
xlim([0 8])
subplot(4,4,15)
plot(time, PCA(:,4))
xlabel('temps')
xlim([0 8])
subplot(4,4,16)
plot(time, ICA(:,4))
xlabel('temps')
xlim([0 8])

%% Subsrt

x_filtre = x_filtre(:,1:2);

V = cov(x_filtre);
[eig_val,eig_vect] = eig(V);
[eig_val,ind] = sort(diag(eig_val), 'descend');
eig_vect = eig_vect(ind,:);
PCA = x_filtre * eig_vect;

ICA = x_filtre*BSS(x_filtre',2);

figure()

subplot(2,4,1)
plot(time, x_filtre(:,1))
title('canal 1')
xlabel('temps')
xlim([0 8])
subplot(2,4,2)
plot(time, y_1)
xlabel('temps')
xlim([0 8])
title('PiCA')
subplot(2,4,3)
plot(time, PCA(:,1))
xlabel('temps')
xlim([0 8])
title('PCA')
subplot(2,4,4)
plot(time, ICA(:,1))
xlabel('temps')
xlim([0 8])
title('ICA')

subplot(2,4,5)
plot(time, x_filtre(:,2))
title('canal 2')
xlabel('temps')
xlim([0 8])
subplot(2,4,6)
plot(time, y_2)
xlabel('temps')
xlim([0 8])
title('PiCA')
subplot(2,4,7)
plot(time, PCA(:,2))
xlabel('temps')
xlim([0 8])
title('PCA')
subplot(2,4,8)
plot(time, ICA(:,2))
xlabel('temps')
xlim([0 8])
title('ICA')