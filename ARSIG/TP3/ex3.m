addpath(genpath('WaveLab802'));

I = double(imread('peppers.tiff'));
I = sum(I, 3);
% imagesc(I); colormap gray; axis square

J = 2;
N = length(I);
P = log2(N);
L = P - J;

h = MakeONFilter('Daubechies',4);
DWT_I = FWT2_PO(I,L,h);

im_dwt2(DWT_I,J);
% hist(DWT_I(:), 500);

liste_coeffs = sort(abs(DWT_I(:)), 'descend');
% plot(liste_coeffs)

tau = 15;
coeffs_filtres = liste_coeffs(1:round(tau*length(liste_coeffs)/100));
for i = 1:N
    for j = 1:N
       if not(ismember(abs(DWT_I(i, j)), coeffs_filtres))
           DWT_I(i, j) = 0;
       end
    end
end

im_dwt2(DWT_I, J);

I_sortie = IWT2_PO(DWT_I,L,h);
imagesc(I_sortie); colormap gray; axis square