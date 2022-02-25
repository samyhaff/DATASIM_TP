close all
clear all

image = imread('camargue.jpg');
image = double(image);
[M,N,C] = size(image);
PIR = image(:,:,1);
R = image(:,:,2);
V = image(:,:,3);

figure(); imagesc(image); colorbar; title('Image')

for i = 1:3
    figure()
    subplot(2,1,1)
    imagesc(image(:,:,i)); colormap gray; axis equal
    title(sprintf("canal %d", i))
    subplot(2,1,2)
    histogram(image(:,:,i), 256); 
    title('Histogramme')
end

seuils = [4000 3000 4000];
for i = 1:3
    seuil = seuils(i);
    h = histcounts(image(:,:,i), 256); 
    canal = image(:,:,i);
    masque = zeros(M,N);
    ind = find(h(canal + 1) <= seuil); % valeurs à passer à 1
    masque(ind) = 255;
    figure(); imagesc(masque); colormap gray
    title(sprintf("masque %d", i))
end

DVI = PIR - R;
figure(); imagesc(abs(DVI)); colormap gray; title('DVI')





















