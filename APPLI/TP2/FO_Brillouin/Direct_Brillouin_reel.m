% Paramètres Spectre élémentaire
load Spectre_Chatou
vec_nu = Spectre_Chatou.freq;
sig = 0.03*3;

% Calcul de la matrice de spectres
Lz = 15.5;
dz = 0.41;

% Vecteur des fréquences sur un intervalle
w = 1;
dx = 0.05;
vec_x = (0:dx:1)';

% Vecteur des positions d'acquisition
vec_z = w/2:dz:Lz-w/2-w/20;
vec_z_t = 0:dz:Lz;

Nz = length(vec_z); % Nombre de points de calcul

% Vecteur des positions pour estimation
vec_x_tot = (0:dx:Lz)';
Nx = length(vec_x_tot);

S = Spectre_Chatou.S(:,1:36); 

figure;
colormap(jet)
imagesc(S)
title('données Brutes')
ylabel('ind. fréquences')
xlabel('ind. position z')
% Calcul de la matrice de transfert H entre l'entrée et l'observation
% Pour une fréquence donnée
Helem = sparse(Nz,length(vec_x_tot));
for jj = 1:length(vec_z),
    ind = find((vec_x_tot>=vec_z(jj)-w/2)&(vec_x_tot<vec_z(jj)+w/2));
    vec_x_jj = vec_x_tot(ind);
    dxeff = w/length(vec_x_jj);    
    Helem(jj,ind) = dxeff;
end

figure;
spy(Helem)
axis normal;
ylabel('pas en z : 36*0.41=14.76m')
xlabel('pas en x : 310*0.05=15.5m')
title('matrice pour une fréquence')

% Agrégation pour toutes les fréquences
H = sparse(size(S,1)*Nz,size(S,1)*length(vec_x_tot));
for kk = 1:length(vec_nu),
    H(kk:length(vec_nu):kk+(length(vec_nu)-1)*Nz,kk:length(vec_nu):kk+length(vec_nu)*(size(Helem,2)-1)) = Helem;
end

figure;
spy(H);
axis normal;
title('matrice H')
xlabel('Nx x Nv')
ylabel('Nv x Nz')

% Procédure de calcul par pseudo-inverse
HHp = H*H';
xrp = H'*(HHp\S(:));

figure;
colormap(jet)
imagesc(reshape(xrp,size(S,1),length(vec_x_tot)))
title('Solution rétropropagée')
ylabel('ind. fréquences')
xlabel('ind. position x')


% Procédure par régularisation sur la dérivée de l'entrée 
lambda = 0.001; % Paramètre de régularisation
Mat_d2 = spdiags(ones(size(H,2),1)*[-1 2 -1],[-length(vec_nu) 0 length(vec_nu)],size(H,2),size(H,2));
xreg = (H'*H+lambda*Mat_d2)\(H'*S(:));

figure;
colormap(jet)
imagesc(reshape(xreg,size(S,1),length(vec_x_tot)))
title(['solution régularisée - Lambda = ' num2str(lambda)])
ylabel('ind. fréquences')
xlabel('ind. position x')



