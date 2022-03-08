function [J, Trec, Tsim_p, f_h, f_h1] = Calcul_FFT_fonc_air(p,t_ini,t_fin,dt_sim,dt_T,Tsim,Teau,Tair,OK_des)
% Fonction-coût de détermination de la constante de temps eta en maintenant les paramètres
% alfa et Kair fixes
global alfaest0 Kair0
alfa = alfaest0;
Kair = Kair0;
eta = 1/p(1); 

% Calcul des paramètres du modèle IRFA 2 pour l'eau
sigma = eta*sqrt(1-alfa^4)/(sqrt(10)/2*(1-alfa^2));
rho = (sigma/eta)^2;

% Calcul des paramètres du modèle IRFA 2 pour l'air
alfa1 = 1-alfa;
eta1 = eta*(1-alfa1^2)/(1-alfa^2);
sigma1 = sigma*sqrt(abs((1-alfa1^4)/(1-alfa^4)));
rho1 = (sigma1/eta1)^2;

% Définition des paramètres de simulation de la température 
dt =  1/12/10;
t = (t_ini:dt:t_fin)';

% Calcul des transformées de Fourier
clear i;
% Définition du vecteur des pulsations
vec_om = 2*pi*(0:1/(t_fin-t_ini):1/(2*dt))';
% Fonction de transfert de l'eau
f_h = alfa*exp(-1/rho*(sqrt(1+2*rho*eta*i*vec_om)-1));
if mod(length(vec_om),2)==0,    
    f_h = [f_h;f_h(end);flipud(conj(f_h(2:end)))];
else
    f_h = [f_h;flipud(conj(f_h(2:end)))];
end
% Fonction de transfert de l'air
f_h1 = Kair*alfa1*exp(-1/rho1*(sqrt(1+2*rho1*eta1*i*vec_om)-1));
if mod(length(vec_om),2)==0,    
    f_h1 = [f_h1;f_h1(end);flipud(conj(f_h1(2:end)))];
else
    f_h1 = [f_h1;flipud(conj(f_h1(2:end)))];
end

% Interpolation aux points de mesure de la simulation des données entrée -
% sortie
Teau_p = interp1(t_ini:dt_T:t_ini+dt_T*(length(Teau)-1),Teau,t,'linear','extrap');
Tair_p = interp1(t_ini:dt_T:t_ini+dt_T*(length(Tair)-1),Tair,t,'linear','extrap');
Tsim_p = interp1(t_ini:dt_sim:t_ini+dt_sim*(length(Tsim)-1),Tsim,t,'linear','extrap');
if OK_des == 2,
    u_cs = [cos(2*pi*t) sin(2*pi*t) ones(size(Teau_p))]; %cos(2*pi/365*t) sin(2*pi/365*t)
else
    u_cs = [t.^2 t ones(size(Teau_p))];
end

% Calcul des tendances qui vont être enlevées pour identifier
Teau_tend = (OK_des>=1)*u_cs*(u_cs\Teau_p);
Tair_tend = (OK_des>=1)*u_cs*(u_cs\Tair_p);
Tsim_tend = (OK_des>=1)*u_cs*(u_cs\Tsim_p);

% Calcul des convolutions par les réponses impulsionnelles
vecsol = real(ifft(f_h.*fft(Teau_p-Teau_tend)));
vecsol1 = real(ifft(f_h1.*fft(Tair_p-Tair_tend)));
% Température reconstruite
Trec = vecsol+vecsol1+Tsim_tend;

% Adéquation aux données par mesure de la variance
Jadeq = sum(detrend(Tsim_p-Trec,0).^2);
% Ajout des termes de pénalisation
J = Jadeq+1e6*min(alfa,0)^2+1e6*min(eta,0)^2+...
    1e6*min(alfa1,0)^2+1e6*(eta*sqrt(1-alfa^4)-sqrt(10)/2*(1-alfa^2)*sigma).^2+...
    1e6*min(1-alfa,0)^2+1e6*min(300-eta,0)^2+1e6*min(200-sigma,0)^2+...
    1e6*min(300-eta1,0)^2+1e6*min(200-sigma1,0)^2+1e6*min(rho-0.01,0)^2;






