addpath(genpath('Wavelab850'));

I = double(imread('peppers.tiff'));
I = sum(I, 3);

figure(1)
imagesc(I); colormap gray; axis square

J = 4;
N = length(I);
P = log2(N);
L = P - J;

% h = MakeONFilter('Daubechies',J);
h = MakeONFilter('Haar');
DWT_I = FWT2_PO(I,L,h);

im_dwt2(DWT_I,J);

figure(3)
hist(DWT_I(:), 5000);
xlim([-400 400])
title('Distribution des coefficients')
xlabel('Coefficient')
ylabel('Nombre d''occurences')

coeffs = sort(abs(DWT_I(:)), 'descend');

figure(4)
plot(coeffs)
title('Coefficients')
ylabel('Coefficient')

description = whos("I"); taille_I = description.bytes

taus = [1, 5, 20];
for k = 1:length(taus)
    DWT_I_filtree = DWT_I;
    coeffs_filtres = coeffs(1:round(taus(k)*length(coeffs)/100));
    for i = 1:N
        for j = 1:N
           if not(ismember(abs(DWT_I(i, j)), coeffs_filtres))
               DWT_I_filtree(i, j) = 0;
           end
        end
    end
    I_sortie = IWT2_PO(DWT_I_filtree,L,h);

    figure(4+k)
    subplot(1,2,1)
    imagesc(I_sortie); colormap gray; axis square
    title("Image reconstruite")
    title(sprintf('Image reconstruite tau=%i', taus(k)))
    subplot(1,2,2)
    imagesc(abs(I-I_sortie)); colormap gray; axis square
    title("Différence")
end
