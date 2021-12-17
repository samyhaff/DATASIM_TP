% Script to apply EKF

clear all
close all
clc


%% Loading data
load('FetalECG.mat')

[nbSamples, nbSensors] = size(x);
time = (0:nbSamples-1) / Fs;
Ts   = 1/Fs;



%% Preprocessing: highpass filtering

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


%% EKF
xEKF = EKF_ecg(y_4, rPeak_4, Fs); % Apply EKF

%% Figures

figure()
subplot(2,2,1)
plot(time, x_filtre(:,1)); hold on; plot(time, xEKF)
title('Canal 1')
xlabel('temps')
xlim([0 8])
legend('channel', 'fetal ECG')

subplot(2,2,2)
plot(time, x_filtre(:,2)); hold on; plot(time, xEKF)
title('Canal 2')
xlabel('temps')
xlim([0 8])
legend('channel', 'fetal ECG')

subplot(2,2,3)
plot(time, x_filtre(:,3)); hold on; plot(time, xEKF)
title('Canal 3')
xlabel('temps')
xlim([0 8])
legend('channel', 'fetal ECG')

subplot(2,2,4)
plot(time, x_filtre(:,4)); hold on; plot(time, xEKF)
title('Canal 4')
xlabel('temps')
xlim([0 8])
legend('channel', 'fetal ECG')