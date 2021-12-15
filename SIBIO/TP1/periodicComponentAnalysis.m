function [y, W, A] = periodicComponentAnalysis(x, rPeak)


% periodicComponentAnalysis      function to estimate components by
% periodic component analysis [1]
%
% [y, W, A] = periodicComponentAnalysis(x, rPeak)
%
% Inputs:
%   _ x: maxtix of ECG signals each column is a channel
%   _ rPeak: sample indexes of R peak
%
% Outputs:
%   _ y: matrix of components (each column is a component)
%   _ W: matrix of spatial filter (each row is a filter)
%   _ A: mixing matrix (each column is the contribution of the related
%   component)
%
% [1] R. Sameni, C. Jutten, and M. B. Shamsollahi, ?Multichannel electrocardiogram 
%     decomposition using periodic component analysis,? IEEE Transactions 
%     on Biomedical Engineering, vol. 55, no. 8, pp. 1935?1940, Aug 2008.

% Author: Bertrand Rivet
% Date: 17/01/2017

addpath('oset')

nbSamples = size(x,1);

peak_R = zeros(nbSamples,1);
peak_R(rPeak) = 1;

[y, W, A] = PiCA(x.', peak_R);



