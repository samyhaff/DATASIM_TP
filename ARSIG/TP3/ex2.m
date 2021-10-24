addpath(genpath('Wavelab850'));

N = 1024;
P = log2(N);
J = 7;
L = P-J;

h = MakeONFilter('Haar');
% h = MakeONFilter('Daubechies',4);

DWT = zeros(1,N);
DWT(N/(2^J)+1) = 2;
DWT(N/(2^J)+5) = 0.5;
DWT(N/(2^J)+65) = 4;
DWT(N/(2^J)+503) = 3.5;
x = IWT_PO(DWT,L,h);

figure(10)
plot(x)
title("Signal")
ylabel("Amplitude")

[y,sigma] = ajoute_bruit(x,10);
DWTbruit = FWT_PO(y,L,h);
% figure(1)
% plot_dwt(x,DWT,J);
% figure(2)
% plot_dwt(y,DWTbruit,J);

figure(11)
plot(y)
title("Signal bruité")
ylabel("Amplitude")

K = 100;
erreurs = zeros(1,K);
seuils = zeros(1,K);

for k = 1:K
    DWTseuil = DWTbruit;

    alpha = 0.01 * k;
    seuils(k) = alpha;

    DWTseuil(DWTbruit < alpha) = 0;

    xdebruite = IWT_PO(DWTseuil,L,h);

    erreur = sum((xdebruite-x).^2);
    erreurs(k) = erreur;
end

alphaOpti = sqrt(sigma*2*log(N));
DWTseuil = DWTbruit;
DWTseuil(DWTbruit < alphaOpti) = 0;
xdebruite = IWT_PO(DWTseuil,L,h);
erreurOpti = sum((xdebruite-x).^2);

% figure(3)
% plot(seuils,erreurs)
% title("Erreur de reconstruction en fonction de alpha")
% xlabel("alpha")
% ylabel("Erreur de reconstruction")
% xlim([0 K*0.01])
% hold on
% plot(alphaOpti,erreurOpti,'x')

xB = MakeSignal('Blocks',N);
xD = MakeSignal('Doppler',N);

figure(8)
plot(xB)
title("Signal Blocks")
ylabel("Amplitude")

figure(9)
plot(xD)
title("Signal Doppler")
ylabel("Amplitude")

DWTB = FWT_PO(xB,L,h);
DWTD = FWT_PO(xD,L,h);

% figure(4)
% plot_dwt(xB,DWTB,J);
% figure(5)
% plot_dwt(xD,DWTB,J);

[yB,sigmaB] = ajoute_bruit(xB,20);
[yD,sigmaD] = ajoute_bruit(xD,20);

DWTBbruit=FWT_PO(yB,L,h);
DWTDbruit=FWT_PO(yD,L,h);

erreursB = zeros(1,K);
erreursD = zeros(1,K);

for k = 1:K
    DWTBseuil = DWTBbruit;
    DWTDseuil = DWTDbruit;

    alpha = 0.01 * k;

    DWTBseuil(DWTBbruit < alpha) = 0;
    DWTDseuil(DWTDbruit < alpha) = 0;

    xBdebruite = IWT_PO(DWTBseuil,L,h);
    xDdebruite = IWT_PO(DWTDseuil,L,h);

    erreurB = sum((xBdebruite-xB).^2);
    erreurD = sum((xDdebruite-xD).^2);
    erreursB(k) = erreurB;
    erreursD(k) = erreurD;
end

alphaBOpti = sqrt(sigmaB*2*log(N));
alphaDOpti = sqrt(sigmaD*2*log(N));
DWTBseuil = DWTBbruit;
DWTDseuil = DWTDbruit;
DWTBseuil(DWTBbruit < alphaBOpti) = 0;
DWTDseuil(DWTDbruit < alphaDOpti) = 0;
xBdebruite = IWT_PO(DWTBseuil,L,h);
xDdebruite = IWT_PO(DWTDseuil,L,h);
erreurBOpti = sum((xBdebruite-xB).^2);
erreurDOpti = sum((xDdebruite-xD).^2);

% figure(6)
% plot(seuils,erreursB)
% title("Erreur de reconstruction en fonction de alpha")
% xlabel("alpha")
% ylabel("Erreur de reconstruction")
% xlim([0 K*0.01])
% hold on
% plot(alphaBOpti,erreurBOpti,'x')

% figure(7)
% plot(seuils,erreursD)
% title("Erreur de reconstruction en fonction de alpha")
% xlabel("alpha")
% ylabel("Erreur de reconstruction")
% xlim([0 K*0.01])
% hold on
% plot(alphaDOpti,erreurDOpti,'x')
