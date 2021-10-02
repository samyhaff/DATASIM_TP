% Patch S. Bourguignon (Apr. 2020): 
% x as a column vector, no need to input time axis t
% applies the WVD to the analytic signal, implications on the frequency
% axis!
% no other output than the TFR


function [tfrx,t,f] = tftb_pwvd(x,Nf,h)

x = x(:);
t = 0:length(x)-1;
xa = hilbert(x);
tfrx = tfrpwv(xa,t,Nf/2,h);
f = (0:Nf/2-1)/Nf;