function [s,w] = simspec(T,K)

%   [s,w] = simspec(T,K)
%
%   T : nombre de points par source
%   K : nombre de modes
%

%
% -------------------------------------------------------------------------
echo off
ni = nargin;
if ni==2
    K = 10; V = 2;
elseif ni==3
    V = 2;
end
%
verbose = 0;
w         = 1/T:1/T:1;
typemotif = 'voigt';
%
V         = V/100;

% Paramètres
if verbose, fprintf(' \\mu & \\gamma & \\alpha \\\\ \n \\hline \n'); end
for k=1:K
    Mu(k)    = rand;
    A(k)     = abs(randn);
    Sigma(k) = V*max(rand,0.1*V);
    %
    if verbose, fprintf(' %1.3f & %1.3f & %1.3f \\\\ \n \\hline \n',T*Mu(k),T*Sigma(k),A(k)); end
end

% Sources
S = zeros(1,T);
for k=1:K,
    F(k,:) = motif(w,Mu(k),Sigma(k),typemotif);
end
s  = A*F;
s = s - min(s);
s = diag(1./std(s'))*s;
w = w*T;

% *************************************************************************
function y = motif(x,mu,sigma,typemotif)

switch typemotif
    % motif lorentzien
    case 'lorentzian'
        K = 1/sqrt(2*pi)/sigma;
        y = sigma.^2./(sigma.^2 + (x-mu).^2);
        % motif gaussien
    case 'gaussian'
        K = 1/(pi*sigma);
        y = exp(-((x-mu).^2)/sigma.^2/2);
    case 'voigt'
        u = rand(1);
        nu = ((x-mu)/sigma).^2;
        y = u/pi*(1./(1+nu)) + (1-u)/sqrt(pi)*exp(-nu/2);
end




