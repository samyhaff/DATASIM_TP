close all
clear all

image = imread('camargue.jpg');
[M,N,C] = size(image);
PIR = double(image(:,:,1));
R = double(image(:,:,2));
V = double(image(:,:,3));

figure(); imagesc(image); title('Image')

figure();
subplot(1,3,1)
imagesc(PIR); colormap gray
title('Canal 1')
subplot(1,3,2)
imagesc(R); colormap gray
title('Canal 2')
subplot(1,3,3)
imagesc(V); colormap gray
title('Canal 3')

for i = 1:3
    figure()
    subplot(2,1,1)
    imagesc(image(:,:,i)); colormap gray; axis equal
    title(sprintf("canal %d", i))
    subplot(2,1,2)
    histogram(image(:,:,i), 256);
    title('Histogramme')
end

seuils = [2000 2000 1000];
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

% NDVI

DVI = abs(PIR - R);
NDVI = (PIR - R) ./ (PIR + R);
figure(); imagesc(abs(DVI)); colormap gray; title('DVI')
figure(); imagesc(abs(NDVI)); colormap gray; title('NDVI')

figure()
histogram(DVI, 256);
title('Histogramme')

figure()
seuils = [500,1000,2000,3000,5000,10000];
for i = 1:length(seuils)
    seuil = seuils(i);
    h = histcounts(DVI, 256);
    masque = zeros(M,N);
    ind = find(h(DVI + 1) <= seuil);
    masque(ind) = 255;
    subplot(2,3,i)
    imagesc(masque); colormap gray
    title(sprintf("seuil: %d", seuil))
end

% K-means

K = 4;

[image_labels, C] = imsegkmeans(image,K);

channels = zeros(size(image,1),size(image, 2),K);
figure;
for i=1:K
    channels(:,:, i) = image_labels == i;
    subplot(1, K, i);
    imagesc(channels(:, :, i)); axis equal; colormap gray;
end

dvis = zeros(K);
DVIs = C(:,1) - C(:,2);
[max_dvi, ind] = max(DVIs);

figure(); imagesc(channels(:,:,ind)); axis equal; colormap gray;

k_s = 2:7;
imgs_opti = zeros(size(image,1),size(image, 2),K);

for i=1:length(k_s)
    [image_labels, C] = imsegkmeans(image,k_s(i));
    for j=1:k_s(i)
        channels(:,:, j) = image_labels == j;
    end
    DVIs = C(:,1) - C(:,2);
    [max_dvi, ind] = max(DVIs);
    imgs_opti(:, :, i) = channels(:,:,ind);
end

sub_ind = round(length(k_s)/2);
for i=1:length(k_s)
    subplot(2, sub_ind, i);
    imagesc(imgs_opti(:, :, i)); axis equal; colormap gray
    title(sprintf("%d", k_s(i)))
end

% figure;
% for i=1:length(k_s)
%     subplot(2, sub_ind, i);
%     C = labeloverlay(image, imgs_opti(:, :, i));
%     imagesc(C); axis equal;
%     title(sprintf("%d", k_s(i)))
% end
