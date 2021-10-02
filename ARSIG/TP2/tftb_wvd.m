% Patch S. Bourguignon (Apr. 2020): 
% x as a column vector, no need to input time axis t
% applies the WVD to the analytic signal, implications on the frequency
% axis!
% no other output than the TFR

function [tfrx,t,f] = tftb_wvd(x,Nf)

x = x(:);
t = 0:length(x)-1;
xa = hilbert(x);
[tfrx,~,f] = tfrwv(xa,t,Nf/2);
f = (0:Nf/2-1)/Nf;
