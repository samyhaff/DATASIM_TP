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

n_filter = Fs/0.5;
num = zeros(2*(n_filter+1),1);
num(1) = -1/(2*n_filter+1);
num(n_filter+1) = 1;
num(n_filter+2) = -1;
num(end) = 1/(2*n_filter+1);
den = [1, -1];

for i = 1:4
    x(:,i) = filter(num,den,x(:,i));
end


%% R peak detection
% 1. TO DO Selection of channel used to detect R peak

% 2. Apply R peak detection

[rPeak, rPeak_BP, rPeak_MA] = ecgRPeakDetector(x(:,1), 25, 125, 149, 0, Fs);

%% Spatial fitlers estimated by PiCA

[y, W, A] = periodicComponentAnalysis(x(:,1), rPeak);


%% Comparison with PCA



%% Comparison with ICA




%% Figures





