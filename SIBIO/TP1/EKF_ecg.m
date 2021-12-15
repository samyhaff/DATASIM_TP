function xEKF = EKF_ecg(x, rPeak, fs)



% EKF_ecg      function to estimate ECG by EKF [1]
%
% xEKF = EKF_ecg(x, rPeak, Fs)
%
% Inputs:
%   _ x: vector of ECG signals
%   _ rPeak: sample indexes of R peak
%   _ Fs: sampling frequency (in Hz)
%
% Outputs:
%   _ xEKF: estimation of periodic signal by EKF
%
% [1] RR. Sameni, M. B. Shamsollahi, C. Jutten, and G. D. Clifford, ?A nonlinear 
%     bayesian filtering framework for ECG denoising,? IEEE Transactions on 
%     Biomedical Engineering, vol. 54, no. 12, pp. 2172?2185, Dec 2007.

% Author: Bertrand Rivet
% Date: 17/01/2017


addpath('oset');

nbSamples = length(x);

peak_R = zeros(nbSamples,1);
peak_R(rPeak) = 1;


% 1. Computing mean beat
bins  = 250;                          % number of phase bins
phase = PhaseCalculation(peak_R);     % phase calculation
[ECGmean,ECGsd,meanphase] = MeanECGExtraction(x, phase, bins, 1); % mean ECG extraction

OptimumParams = ECGBeatFitter(ECGmean,ECGsd,meanphase,'OptimumParams');           % ECG beat fitter GUI


% 2. EKF
N = length(OptimumParams)/3;% number of Gaussian kernels
fm = fs./diff(rPeak);          % heart-rate
w = mean(2*pi*fm);          % average heart-rate in rads.
wsd = std(2*pi*fm,1);       % heart-rate standard deviation in rads.

y = [phase ; x];

X0 = [-pi 0]';
P0 = [(2*pi)^2 0 ;0 (10*max(abs(x))).^2];
Q = diag( [ (.1*OptimumParams(1:N)).^2 (.05*ones(1,N)).^2 (.05*ones(1,N)).^2 (wsd)^2 , (.05*mean(ECGsd(1:round(length(ECGsd)/10))))^2] );
R = [(w/fs).^2/12 0 ;0 (mean(ECGsd(1:round(length(ECGsd)/10)))).^2];
Wmean = [OptimumParams w 0]';
Vmean = [0 0]';
Inits = [OptimumParams w fs];

InovWlen = ceil(.5*fs);     % innovations monitoring window length
tau = [];                   % Kalman filter forgetting time. tau=[] for no forgetting factor
gamma = 1;                  % observation covariance adaptation-rate. 0<gamma<1 and gamma=1 for no adaptation
RadaptWlen = ceil(fs/2);    % window length for observation covariance adaptation

Xekf = EKSmoother(y,X0,P0,Q,R,Wmean,Vmean,Inits,InovWlen,tau,gamma,RadaptWlen,1);

xEKF = Xekf(2,:);