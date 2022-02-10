clear all
close all 

load('exemple2.mat')

[height, width] = size(z_image);
[h_height, h_width] = size(noyau);
%100 et 0.1 pour pb1
param.noyau = noyau;
param.z_image = z_image;
param.crit = 4;
param.lambda = 10;
param.height = height + h_height - 1;
param.width = width + h_width -1;
param.eps=0.01;
x0 = ones(param.height*param.width,1);

[J, gradJ] = probleme1(x0, param);

[f, trace] = minimisation_nl('probleme1',param,x0);

image=reshape(f,height + h_height - 1,width + h_width -1);
figure(1)
imagesc(z_image);colormap gray
figure(2)
imagesc(image);colormap gray