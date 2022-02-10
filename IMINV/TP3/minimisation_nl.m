function [f, trace] = minimisation_nl(cg, par, f0)
% 
% Fonction permettant de trouver num�riquement la valeur de f qui minimise
% un crit�re J
% Interface avec la bo�te � outils Problano v 1.1
%
%    Copyright (C) 2013  Yves Goussard
%
% Param�tres d'entr�e
%   cg : nom d'une fonction (cha�ne de caract�res) qui, pour toute valeur
%        de f, retourne la valeurdu crit�re J et de son gradient g en 
%        fonction de param�tres contenus dans la structure par.
%        forme de la fonction : [J, g] = cg(f, par)
%   par : deuxi�me argument (structure) de la fonction cg
%   f0 : valeur initiale de f
%
% Param�tres de sortie
%   f : r�sultat de la minimisation
%   trace : structure contenent divers indices relatifs au d�roulement de
%           la proc�dure d'optimisation
%

addpath('poblano_toolbox_1.1')

optim = @lbfgs;

RelTol = 1e-05;

eval(['cg_l = @(f) ' cg, '(f, par);'])
[J0, g0] = cg_l(zeros(size(f0)));
StopTol = norm(g0) / length(g0) * RelTol;
M = 10;

params = optim('defaults');
params.StopTol = StopTol;
params.RelFuncTol = 1e-10;
params.TraceFunc = true;
params.TraceGradNorm = true;
if isfield(params, 'M')
    params.M = M;
end

OUT = optim(cg_l, f0, params);
f = OUT.X;
trace = OUT;
trace = rmfield(trace, 'X');
trace.StopTol = params.StopTol;
trace.RelFuncTol = params.RelFuncTol;

return
