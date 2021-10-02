% Patch S. Bourguignon (Apr. 2020): 
% x as a column vector, no need to input time axis t
% no other output than the TFR
% output and frequency axis restricted on [0,0.5[
% excludes for compatibility with WV functions

function [tfrx,t,f] = tftb_spectrogram(x,Nf,h)

x = x(:);
N = length(x);
t = 0:N-1;
tfrx_full = tfrsp(x,t,Nf,h);

tfrx = tfrx_full(1:Nf/2,:);
f = (0:Nf/2-1)/Nf;
