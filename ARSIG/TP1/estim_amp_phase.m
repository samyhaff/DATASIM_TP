% Least-squares estimation of the amplitude and phase parameters of a 
% sine wave with given frequency
% Input paramters:
% signal: the vector containing the data points
% t: the vector containing the corresponding time samples
% f_est : the frequency of the sine wave
% Output parameters:
% amp_est : the amplitude of the sine wave
% phi_est : the phase of the sine wave, 
% in a model amp_est*sin(2*pi*f_est+phi_est).



function [amp_est,phi_est] = estim_amp_phase(signal,t,f_est)

ind_NZ = find(signal~=0);
t_NZ = t(ind_NZ); t_NZ = t_NZ(:);
signal = signal(ind_NZ); signal = signal(:);

R = [cos(2*pi*f_est*t_NZ), sin(2*pi*f_est*t_NZ)];
amp_cossin = (R'*R)\(R'*signal);

if amp_cossin(2)>=0
    phi_est = atan(amp_cossin(1)/amp_cossin(2));
else
    phi_est = atan(amp_cossin(1)/amp_cossin(2)) + pi;
end

amp_est = norm(amp_cossin);

