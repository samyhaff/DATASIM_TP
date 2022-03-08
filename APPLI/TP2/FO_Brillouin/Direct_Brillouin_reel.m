% Param�tres Spectre �l�mentaire
load Spectre_Chatou
vec_nu = Spectre_Chatou.freq;
sig = 0.03*3;

% Calcul de la matrice de spectres
Lz = 15.5;
dz = 0.41;

% Vecteur des fr�quences sur un intervalle
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
title('donn�es Brutes')
ylabel('ind. fr�quences')
xlabel('ind. position z')
% Calcul de la matrice de transfert H entre l'entr�e et l'observation
% Pour une fr�quence donn�e
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
title('matrice pour une fr�quence')

% Agr�gation pour toutes les fr�quences
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

% Proc�dure de calcul par pseudo-inverse
HHp = H*H';
xrp = H'*(HHp\S(:));

figure;
colormap(jet)
imagesc(reshape(xrp,size(S,1),length(vec_x_tot)))
title('Solution r�tropropag�e')
ylabel('ind. fr�quences')
xlabel('ind. position x')


% Proc�dure par r�gularisation sur la d�riv�e de l'entr�e 
lambda = 0.001; % Param�tre de r�gularisation
Mat_d2 = spdiags(ones(size(H,2),1)*[-1 2 -1],[-length(vec_nu) 0 length(vec_nu)],size(H,2),size(H,2));
xreg = (H'*H+lambda*Mat_d2)\(H'*S(:));

figure;
colormap(jet)
imagesc(reshape(xreg,size(S,1),length(vec_x_tot)))
title(['solution r�gularis�e - Lambda = ' num2str(lambda)])
ylabel('ind. fr�quences')
xlabel('ind. position x')



