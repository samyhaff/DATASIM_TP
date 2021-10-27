
addpath ecg
randn('state', 0);
rand('state', 1);               % Set rand/randn states for reproducibility
Fs = 256;                       % Fs : sampling frequency (samples/sec)

ecg_10 = ecgsyn(Fs, 10);        % Simulate 10 heart beats


M = 3;                          % M : number of beats
ecg = ecg_10(Fs/2+(1:M*Fs));    % Extract M beats from simulated ECG

N = length(ecg);
n = 0:N-1;

sigma = 0.1;                    % sigma : noise standard deviation
noise = sigma * randn(N, 1);    % noise : white Gaussian noise
data = ecg + noise;             % data : noisy ECG

ax1 = [0 N -1.0 2.0];

figure(1)
clf
subplot(2,1,1)
plot(n, ecg)
title('ECG (noise-free)')
axis(ax1)

subplot(2,1,2)
plot(n, data)
title('ECG + noise');
axis(ax1)


