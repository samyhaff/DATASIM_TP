addpath(genpath('tftb-0.2'));

[x, Fs] = audioread('furElise_court.wav');

N = length(x);
t = 0:1/Fs:(N-1)/Fs;

subplot(2,1,1);
plot(t,x);
title('Allure temporelle')
xlabel('temps (s)')
xlim([0 t(N)])
ylabel('Amplitude')

Nh = 513;
Nf = 8*2^nextpow2(Nh);
h = hamming(Nh);
[tfrx,T,F] = tftb_spectrogram(x',Nf,h);

subplot(2, 1, 2);
imagesc(T,F,log(tfrx)); axis xy;
colorbar;
title('Spectrogramme en échelle logarithmique')
xlabel('n')
ylabel('Fréquence normalisée')

tau = 10;
seuil = 0.1;
I = zeros(1, N - 2 * tau);
for t = tau+1:N-tau
    R1 = tfrx(:,t-tau:t);
    R1 = R1 / sum(abs(R1));
    R2 = tfrx(:,t:t+tau);
    R2 = R2 / sum(abs(R2));
    
    I(t) = sum(abs(R1 - R2));
end

[maxima, ruptures] = findpeaks(I,'MinPeakHeight',0.04,'MinPeakProminence',0.003);
Nf=2^nextpow2(N);
axe_freq=linspace(0,Fs-Fs/Nf,Nf);

notes = [];
durees = [];
val=0;
for i = 1:length(ruptures)-1
    x_plage = x(ruptures(i):ruptures(i+1));
    TF = fft(x_plage,Nf);
    TF = abs(TF).^2;
    [maxima, lambda] = max(TF);
    f = axe_freq(lambda);
    ecart = tab_freq_valeurs - f;
    [minimum, indice] = min(abs(ecart));
    notes = [notes; tab_freq_noms(indice,:)];
    nb_points = ruptures(i+1)-ruptures(i);
    durees = [durees; nb_points/Fs];
end

s = genere_morceau(notes,durees,Fs);
audiowrite('sortie.wav', s, Fs);
