% Script tp_inverse_problem

clear;
close all;
clc;
load TP_data;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate linear mixture of source signals
Xs=G*S;

%determine maximum of the signal of interest (here an epileptic spike) to
%apply source loclization algorithms to this time point
[~,id]=max(mean(X,1));

%visualize original source distribution
figure; trisurf(mesh.f,mesh.v(:,1),mesh.v(:,2),mesh.v(:,3), S(:,id));
title('original source configuration: two source regions','FontSize',18);

%generate Gaussian random noise
Noise=randn(size(Xs));

%normalize noise
Noise=Noise/norm(Noise,'fro')*norm(Xs,'fro');

%signal to noise ratio
SNR=10;

%generate noisy data according to given SNR
X=Xs+1/sqrt(SNR)*Noise;

%visualize data (for a reduced number of sensors whose indices are
%specified by idx_electrodes)
plot_eeg(X(idx_electrodes,:),max(max(X(idx_electrodes,:))),256,channel_names);
title('noisy EEG data','FontSize',18);

%% Manual test of lambda
lambda_MAN=logspace(-7,7,500);
seuil=0.3;
for k=1:length(lambda_MAN)

    %faut calculer id sur x en vrai pas S
    Shat_MAN(:,k) = mne(X(:,id), G,lambda_MAN(k), 'pinv');

    %DLE
    idx_coupled_MAN=[];
    idx_coupled_MAN=common_indices(idx_coupled_MAN,find(abs(Shat_MAN(:,k))>seuil*max(abs(Shat_MAN(:,k)))),'add');
    DLEcur_MAN(:,k)=DLE(idx_r_grid, idx_coupled_MAN, r_grid,2);
end


plot(log(lambda_MAN), DLEcur_MAN);title('DLE en fonction de lambda pour un seuil de 0.3','FontSize',18);
xlabel("lambda")
ylabel("DLE")

[min_DLE, kmin] = min(DLEcur_MAN);
lambda_man_opti = lambda_MAN(kmin);

Shat_man_opti = mne(X(:,id), G,lambda_man_opti, 'pinv');

Sseuil = zeros(size(Shat_man_opti));
ind_seuil = find(abs(Shat_man_opti)>=seuil*max(abs(Shat_man_opti)));
Sseuil(ind_seuil) = Shat_man_opti(ind_seuil);

figure; trisurf(mesh.f,mesh.v(:,1),mesh.v(:,2),mesh.v(:,3),Sseuil);
title(sprintf("Reconstruction with MAN lambda optimization for lambda = %f",lambda_man_opti),'FontSize',18);

%% L-curve criterion+GCV
lambda_AUT=logspace(-7,7,500);

for k=1:length(lambda_AUT)
    s_2(k) = norm(Shat_MAN(:,k));
    x_gs(k) = norm(X(:,id)-G*Shat_MAN(:,k));
end

[lambda_LC,indL,curv] = lcurve(lambda_AUT,s_2,x_gs);
figure; plot(x_gs, s_2);
hold on, plot(x_gs(indL), s_2(indL), 'o')
xlabel("||s||");ylabel("||x-Gs||")
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
title('L curve')
%%L-curve


Shat_LC = mne(X(:,id), G,lambda_LC, 'pinv');

Sseuil = zeros(size(Shat_LC));
ind_seuil = find(abs(Shat_LC)>=seuil*max(abs(Shat_LC)));
Sseuil(ind_seuil) = Shat_LC(ind_seuil);
%DLE
figure; trisurf(mesh.f,mesh.v(:,1),mesh.v(:,2),mesh.v(:,3),Sseuil);
title(sprintf("Reconstruction with L curve for lambda = %f",lambda_LC),'FontSize',18);

%DLE
idx_coupled_LC=[];
idx_coupled_LC=common_indices(idx_coupled_LC,find(abs(Shat_LC)>0.3*max(abs(Shat_LC))),'add');
DLEcur_LC=DLE(idx_r_grid,idx_coupled_LC,r_grid,2);

%% discrepancy principle

idd = find(x_gs <= norm(Noise(:,id),'fro')/sqrt(SNR));
lambda_DISC = lambda_AUT(max(idd));

Shat_DISC = mne(X(:,id),G,lambda_DISC, 'pinv');

Sseuil = zeros(size(Shat_DISC));
ind_seuil = find(abs(Shat_DISC)>=seuil*max(abs(Shat_DISC)));
Sseuil(ind_seuil) = Shat_DISC(ind_seuil);

figure; trisurf(mesh.f,mesh.v(:,1),mesh.v(:,2),mesh.v(:,3),Sseuil);
title(sprintf("Reconstruction with DISC for lambda = %f",lambda_DISC),'FontSize',18);

%DLE
idx_coupled_DISC=[];
idx_coupled_DISC=common_indices(idx_coupled_DISC,find(abs(Shat_DISC)>0.3*max(abs(Shat_DISC))),'add');
DLEcur_DISC=DLE(idx_r_grid,idx_coupled_DISC,r_grid,2);

%%
%RESULT
LAMDA_END=[lambda_man_opti lambda_LC  lambda_DISC]
DLE_GLOB=[min_DLE DLEcur_LC DLEcur_DISC]
