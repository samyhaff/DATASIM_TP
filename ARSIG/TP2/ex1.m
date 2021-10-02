addpath(genpath('tftb-0.2'));

N = 256;
n = 0:N-1;

phi1 = 0.25 * n + 5 * cos(2 * pi * n / N);
phi2 = 0.25 * n + 0.1 * n.^2/N;

f1 = 0.25 - 5 * 2 * pi / N * sin(2 * pi * n / N);
f2 = 0.25 + 0.2 * n / N;

x1 = cos(2 * pi * phi1);
x2 = cos(2 * pi * phi2);

figure(1);
subplot(2, 3, 1);
plot(x1);
subplot(2, 3, 2);
plot(phi1);
subplot(2, 3, 3);
plot(f1);
subplot(2, 3, 4);
plot(x2);
subplot(2, 3, 5);
plot(phi2);
subplot(2, 3, 6);
plot(f2);

figure(2);
T1 = 15; 
T2 = 85; 
T3 = 180;
Nh = 51; 
th = (0:Nh-1); 
h = gausswin(Nh)';
x3 = zeros(1,N);
x3(T1:T1+Nh-1) = h.*cos(2*pi*0.25*th);
x3(T2:T2+Nh-1) = h.*cos(2*pi*0.15*th);
x3(T2:T2+Nh-1) = x3(T2:T2+Nh-1) + h.*cos(2*pi*0.35*th);
x3(T3:T3+Nh-1) = h.*cos(2*pi*0.3*th);
plot(x3);

x1_bruit = ajoute_bruit(x1,10);
x2_bruit = ajoute_bruit(x2,10);
x3_bruit = ajoute_bruit(x3,10);

figure(3);
subplot(1, 3, 1);
plot(x1_bruit);
subplot(1, 3, 2);
plot(x2_bruit);
subplot(1, 3, 3);
plot(x3_bruit);

x = [x1; x2; x3; x1_bruit; x2_bruit; x3_bruit]; 
for j = 1:6
    figure(3 + j);
    Nh = [17 33 65 129];
    for i = 1:4
        h = hamming(Nh(i));
        [tfrx,T,F] = tftb_spectrogram(x(j, :)',N,h);
        subplot(2, 4, i);
        imagesc(T,F,tfrx); axis xy
    end
    
    Nh = 63;
    h = kaiser(Nh);
    [tfrx,T,F] = tftb_wvd(x(j, :)',N);
    subplot(2, 4, 5);
    imagesc(T,F,tfrx); axis xy
    
    Ng = [33, 15];
    for k = 1:2
        h = kaiser(Nh);
        g = kaiser(Ng(k));
        [tfrx,T,F] = tftb_spwvd(x(j, :)',N, g, h);
        subplot(2, 4, 5 + k);
        imagesc(T,F,tfrx); axis xy
    end
end