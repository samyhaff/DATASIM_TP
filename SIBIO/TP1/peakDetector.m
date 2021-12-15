function [peakDetected, locDetected, ...
            pks, loc, ...
            THR_Sig_Store, THR_Noise_Store, ...
            SIG_LEV_Store, NOISE_LEV_Store] = peakDetector(ecg, Fs, minPeakInterval)

        
% peakDetector      function to detect peak in signal based on [1]
%
%[peakDetected, locDetected, peakRaw, locPeakRaw, ...
%   THR_Sig_Store, THR_Noise_Store, SIG_LEV_Store, NOISE_LEV_Store] = peakDetector(ecg, Fs, minPeakInterval)
%
% Inputs:
%   _ ecg: signal
%   _ Fs: sampling frequency
%   _ minPeakInterval (optional): minimun samples between consecutive
%   peaks. Default value corresponds to 200ms.
%
% Outputs:
%   _ peakDetected: amplitudes of detected peaks
%   _ locDetected: sample indexes of detected peaks
%   _ peakRaw: amplitude of local peaks before classification
%   _ locPeakRaw: sample indexes of local peak before classification
%   _ THR_Sig_Store: signal threshold used in [1]
%   _ THR_Noise_Store: noise threshold used in [1]
%   _ SIG_LEV_Store: signal level used in [1]
%   _ NOISE_LEV_Store: noise level used in [1]
%
% [1] J. Pan and W. J. Tompkins, ?A real-time QRS detection algorithm,? 
%     IEEE Transactions on Biomedical Engineering, vol. BME-32, no. 3, 
%     pp. 230?236, March 1985.

% Author: Bertrand Rivet
% Date: 17/01/2017


if nargin <= 2
    minPeakInterval = round(.2*Fs);
end

% Detect raw peaks
[pks, loc] = findpeaks(ecg, 'MINPEAKDISTANCE', minPeakInterval);
nbPeaks = length(pks);



THR_SIG   = max(ecg(1:2*Fs))*1/4; % 0.25 of the max amplitude 
THR_NOISE = mean(ecg(1:2*Fs))*1/2; % 0.5 of the mean signal is considered to be noise
SIG_LEV   = THR_SIG;
NOISE_LEV = THR_NOISE;

peakDetected = [];
locDetected  = [];

THR_Sig_Store   = [];
THR_Noise_Store = [];

NOISE_LEV_Store = [];
SIG_LEV_Store = [];


for indPeak = 1:nbPeaks
    % current peak
    peakCurrent = pks(indPeak);
    locCurrent  = loc(indPeak);
    
    
    % Estimate if current peak is R peak or not
    if peakCurrent > THR_SIG
        peakDetected = [peakDetected peakCurrent];
        locDetected  = [locDetected locCurrent];
        
        % Update signal level
        SIG_LEV   = .125*peakCurrent + .875*SIG_LEV;
    else
        % Update noise level
        NOISE_LEV   = .125*peakCurrent + .875*NOISE_LEV;
    end
    
    % Update thresholds
    THR_SIG   = NOISE_LEV + .25*(SIG_LEV - NOISE_LEV);
    THR_NOISE = THR_SIG / 2;
    
    THR_Sig_Store   = [THR_Sig_Store THR_SIG];
    THR_Noise_Store = [THR_Noise_Store THR_NOISE];
    
    SIG_LEV_Store   = [SIG_LEV_Store SIG_LEV];
    NOISE_LEV_Store = [NOISE_LEV_Store NOISE_LEV];
end

