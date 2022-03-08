close all
clear all



load('TFO_oraison.mat')
%
Mat = TFO_oraison(2:end,2:end);
Jours=TFO_oraison(1,2:end);
L=TFO_oraison(2:end,1);

figure;
colormap(jet)
imagesc(Jours,L,Mat)
set(gca, 'xtick', TFO_oraison(1,2):1:TFO_oraison(1,end))
datetick('x', 'dd', 'keepticks')
%imagesc(Mat);
colorbar
title('Température brute')
xlabel('jours')
ylabel('m')


% Suppression de la moyenne
Mat_c = Mat-ones(size(Mat,1),1)*mean(Mat);

figure;
colormap(jet)
imagesc(Jours,L,Mat_c);
set(gca, 'xtick', TFO_oraison(1,2):1:TFO_oraison(1,end))
datetick('x', 'dd', 'keepticks')
xlabel('jours')
ylabel('m')
colorbar
title('Température centrée')


% Analyse en composantes principales
[U,S,V] = svd(Mat_c);

figure;
plot(diag(S),'*-.')
title('Valeurs propres ACP')
figure;
subplot(211)
plot(L,U(:,1))
title('Premier Vecteur Propre')
subplot(212)
plot(L,U(:,2:6))
title('Vecteurs Propres de 2 à 6')
xlabel('m')

% Retrait de la première composante principale
dMat_c = Mat_c-U(:,1)*S(1,1)*V(:,1)';

figure
colormap(jet)
imagesc(Jours,L,dMat_c)
title('Résidu ACP (première composante principale)')
set(gca, 'xtick', TFO_oraison(1,2):1:TFO_oraison(1,end))
datetick('x', 'dd', 'keepticks')
xlabel('jours')
ylabel('m')
colorbar


% 3 méthodes d'Analyse en composantes indépendantes
nb_sources = 1; % Le paramètre à changer
Bj = MatlabjadeR(U(:,2:6)',nb_sources);
Bs = MatlabshibbsR(U(:,2:6)',nb_sources);

addpath('FastICA')
[Bf,~] = fastica(U(:,2:6)','numOfIC',nb_sources);

% Retrait de la première composante principale
dMat_c = Mat_c-U(:,1)*S(1,1)*V(:,1)';

% Sources
Uj_aci = (Bj*U(:,2:6)')';
pj_aci = Uj_aci\dMat_c;

Us_aci = (Bs*U(:,2:6)')';
ps_aci = Us_aci\dMat_c;

Uf_aci = (Bf'*U(:,2:6)')';
pf_aci = Uf_aci\dMat_c;

Rec_j_ACI = Uj_aci*pj_aci;
Rec_s_ACI = Us_aci*ps_aci;
Rec_f_ACI = Uf_aci*pf_aci;

figure;
subplot(311)
plot(Uj_aci)
title(['Sources Jade - N = ' num2str(nb_sources)] )

subplot(312)
plot(Us_aci)
title(['Sources Shibbs - N = ' num2str(nb_sources)])

subplot(313)
plot(Uf_aci)
title(['Sources FastICA - N = ' num2str(nb_sources)])


figure;
colormap(jet)
subplot(221)
imagesc(dMat_c-Rec_j_ACI)
title(['Résidu Jade - N = ' num2str(nb_sources)] )
colorbar

subplot(222)
imagesc(dMat_c-Rec_s_ACI)
title(['Résidu Shibbs - N = ' num2str(nb_sources)])
colorbar
subplot(223)
imagesc(dMat_c-Rec_f_ACI)
title(['Résidu FastICA - N = ' num2str(nb_sources)])
colorbar

