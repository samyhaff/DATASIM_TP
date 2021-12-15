% Script used to the basic anaylis of ECG signal


clear all
close all
clc




%% Loading data
load('HealthyECG.mat')
nbSamples = length(x);
time = (0:nbSamples-1) / Fs;

%% Spectral analysis


%% Spectrogram

