% Ajoute un bruit blanc gaussien à un signal x, de puissance définie pour atteindre un rapport signal sur bruit donné

function [y,var_bruit] = ajoute_bruit(x,RSB)

N = length(x);

% Energie du signal x 
E_signal = sum(x.^2);


% variance du bruit sigma2 telle que RSB = 10 log10(E_x/E_bruit)
var_bruit = E_signal*10^(-RSB/10)/N;

% ajout d'une réalisation aléatoire d'un vecteur de bruit gaussien iid, de
% variance var_bruit
y = x + sqrt(var_bruit)*randn(size(x));