clear all
close all

load("TP1_Exemple")

[M N] = size(Z)
W = repmat(gth',size(Z,1),1).*Z;
V = log(W);
Y = log(Z); 
f = log(gth);

figure(1)
imagesc(Z); colormap gray
title('Z')
figure(2)
imagesc(W); colormap gray
title('W')

figure(3)
imagesc(abs(W-Z)); colormap gray
title('W-Z')

% Methode 0
err = 1/sqrt(N)*norm(f)

% Methode 1
f_1 = mean(V)';
f_centree = f-mean(f);
err = 1/sqrt(M)*norm(f_centree-f_1)

figure(4)
plot(f, f_1, 'o')
title("Gains methode 1 en fonction des vraies valeurs")
xlabel('f')
ylabel('f_1')

figure(5)
plot(f_1-f)
title('Erreur d''estimation')
xlabel('n')
ylabel('Erreur')

figure(6)
nb_f = 8*2^nextpow2(length(f));
freq = linspace(0,1,nb_f);
plot(freq,abs(fft(f_1-f,nb_f)))
xlim([0 0.5])
title('Module de la transformee de Fourrier de l''erreur')
xlabel('freq')
ylabel('|F|')

figure(7)
plot(f_1-mean(f_1))
hold on
plot(f_centree)
xlabel('n')
title('Valeurs des gains')
legend('gains estimes','gains reels')

% m&thode 2
dV = diff(V')';
df = zeros(N-1,1);
f_2 = zeros(N,1);
for n = 1:N-1
    df(n) = median(dV(:,n));
end
for n = 1:N
    f_2(n) = sum(df(1:n-1));
end

figure(11)
plot(f_2 - mean(f_2))
hold on
plot(f_centree)
xlabel('n')
title('Valeurs des gains')
legend('gains estimes methode 2','gains reels')

%methode 3
lbds = linspace(0,1.5,100);  
err = zeros(length(lbds),1);
e = ones(N,1);
D = spdiags([-e e], 0:1, N-1, N);
s = sum(V) / M;
for i = 1:length(lbds)
    f_3 = (D'*D+lbds(i)*speye(N)) \ D'*D*s';
    err(i) = sum((f-f_3).^2);
end

[err_min1, ind_opti] = min(err);
lbds(ind_opti)
f_3 = (D'*D+lbds(ind_opti)*speye(N)) \ D'*D*s';

figure(8)
plot(lbds,err)
title('Erreur en fonction de la valeur de lbd')
xlabel("lbd")
ylabel("Erreur")

% methode 4
lbds = linspace(0,3000,100);  
f_4 = zeros(N,1);
for i = 1:length(lbds)
    f_4 = MAPL1(V',D,lbds(i));
    err(i) = sum((f-f_4).^2);
end

[err_min, ind_opti] = min(err);
f_4=MAPL1(V',D,lbds(ind_opti));
lbds(ind_opti)
figure(9)
plot(lbds,err)
title('Erreur de la methode 4 en fonction de la valeur de lbd')
xlabel("lbd")
ylabel("Erreur")

% affichage resultats
figure(10)
plot(f_centree)
hold on
plot(f_1 - mean(f_1))
plot(f_2 - mean(f_2))
plot(f_3 - mean(f_3))
plot(f_4 - mean(f_4))
xlabel('n')
ylabel('gain')
title('Valeurs des gains')
legend('coeff ideal','methode 1','methode 2','methode 3', 'methode 4')

figure(12)
plot(f_centree)
hold on
plot(f_3 - mean(f_3))
plot(f_4 - mean(f_4))
xlabel('n')
ylabel('gain')
title('Valeurs des gains')
legend('coeff ideal','methode 3','methode 4')
