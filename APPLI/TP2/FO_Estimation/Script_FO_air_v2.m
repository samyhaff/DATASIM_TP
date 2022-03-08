if (~exist('TFO','var')|~exist('Teau_FO','var')),
    load envir_TFO
end

clear Jest2 yest2 ysim
global alfaest0 etaest0 Kair0

OK_des = 1; %  1 : tendance parabolique, 2 : tendance sinusoidale annuelle, 0 : pas de tendance
i_fin = 12*183+437+1;

TFO_ref = TFO(2:end,437:i_fin-1)';

% Définition des temps initial et final d'estimation
t_ini = 0;
t_fin = fix(TFO(1,i_fin)-TFO(1,437));

verb = 'none';

Ntraces_deb = 2; % Ntraces_deb va de 2 à 2071
Ntraces_fin = 10; % Ntraces_fin va de 2 à 2071 

for i = Ntraces_deb:Ntraces_fin,
    if (mod(i,10) == 0),
        disp(i),drawnow
    end
    % Donnée de mesure à identifier
    Tsim = TFO(i,437:i_fin);
    % Pas de temps de la mesure FO
    dt_sim = 1/12;
    % Pas de temps des mesures météo
    dt_T = 1/12;

    % Initialisation de l'optimisation
    alfaest0 = 0.5;
    etaest0 = 10;
    Kair0 = 1;

    % Itérations alternées sur les coefficients
    p_opt_1 = fminsearch(@(p) Calcul_FFT_fonc_air_2(p,t_ini,t_fin,dt_sim,dt_T,Tsim,Teau_FO,Tair_FO,OK_des),[alfaest0;Kair0],optimset('TolX',1e-5,'Display',verb,'MaxFunEvals',15000,'MaxIter',5000));
    alfaest0 = p_opt_1(1);
    Kair0 = p_opt_1(2);
    p_opt = fminsearch(@(p) Calcul_FFT_fonc_air(p,t_ini,t_fin,dt_sim,dt_T,Tsim,Teau_FO,Tair_FO,OK_des),1/etaest0,optimset('TolX',1e-5,'Display',verb,'MaxFunEvals',15000,'MaxIter',5000));
    etaest0 = 1/p_opt;
    p_opt_1 = fminsearch(@(p) Calcul_FFT_fonc_air_2(p,t_ini,t_fin,dt_sim,dt_T,Tsim,Teau_FO,Tair_FO,OK_des),[alfaest0;Kair0],optimset('TolX',1e-5,'Display',verb,'MaxFunEvals',15000,'MaxIter',5000));
    alfaest0 = p_opt_1(1);
    Kair0 = p_opt_1(2);
    p_opt = fminsearch(@(p) Calcul_FFT_fonc_air(p,t_ini,t_fin,dt_sim,dt_T,Tsim,Teau_FO,Tair_FO,OK_des),1/etaest0,optimset('TolX',1e-5,'Display',verb,'MaxFunEvals',15000,'MaxIter',5000));
    etaest0 = 1/p_opt;

    % Affectation
    alfaest(i-1,1) = alfaest0;
    Kair(i-1,1) = Kair0;
    etaest(i-1,1) = etaest0;
    
    % Calcul des réponses finales 
    [Jest2(i-1,1),yesttot,ysimtot] = Calcul_FFT_fonc_air(p_opt,t_ini,t_fin,dt_sim,dt_T,Tsim,Teau_FO,Tair_FO,OK_des);
    yest2(:,i-1) = yesttot(1:10:end,1);
    ysim(:,i-1) = ysimtot(1:10:end,1);
end

figure;
subplot(211)
plot(t_ini:1/12:t_fin,[Teau_FO(437:i_fin-1)' Tair_FO(437:i_fin-1)'])

subplot(212)
plot(t_ini:1/12:t_fin,[yest2(:,1) TFO_ref(:,2)])
xlabel('jours')
legend({'Estimation','Mesure'})


