function x = epoch(s, rPeak, nbSampleBefore, nbSampleAfter)


% epoch      function to epoch ECG synchronized to R peak
%
% x = epoch(s, rPeak, nbSampleBefore, nbSampleAfter)
%
% Inputs:
%   _ s: ECG signal to be epoch
%   _ rPeak: sample indexes of R peak
%   _ nbSampleBefore: number of samples before the R peaks
%   _ nbSampleAfter: number of samples after the R peaks
%
% Outputs:
%   _ x: matrix of epoch data (each column is an ECG beat)

% Author: Bertrand Rivet
% Date: 17/01/2017



nbPeaks   = length(rPeak);
nbSamples = length(s);

% Avoiding first and last peaks if too large (i.e. too many samples)
indexFirstSamples    = rPeak - nbSampleBefore;
nbPeakTooRemoveBegin = length(find(indexFirstSamples<1));
if isempty(nbPeakTooRemoveBegin)
    nbPeakTooRemoveBegin = 0;
end

indexLastSamples   = rPeak + nbSampleAfter;
nbPeakTooRemoveEnd = length(find(indexLastSamples > nbSamples));
if isempty(nbPeakTooRemoveEnd)
    nbPeakTooRemoveEnd = 0;
end

nbPeaks = nbPeaks - (nbPeakTooRemoveBegin + nbPeakTooRemoveEnd);

nbSamples = nbSampleBefore + nbSampleAfter + 1;
x         = zeros(nbSamples, nbPeaks);

for ind = 1:nbPeaks
    x(:,ind) = s(rPeak(nbPeakTooRemoveBegin+ind) + (-nbSampleBefore:nbSampleAfter));
end

