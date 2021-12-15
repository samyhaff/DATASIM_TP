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



%% R peak detection
% 1. TO DO Selection on channel to detect R peak

% 2. Apply R peak detection



%% Spatial fitlers estimated by PiCA





%% EKF
indexFetalECG = ; % Select the component
xEKF = EKF_ecg(yPiCA(indexFetalECG,:), rPeak, Fs); % Apply EKF

% TO DO: Estimate fetal ECG



%% Figures

        
