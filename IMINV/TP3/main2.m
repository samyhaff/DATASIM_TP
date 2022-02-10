clear all
close all 

load('exemple3.mat')
[height, width] = size(z_data);
[h_height, h_width] = size(R);

param.R = R;
param.z_data = z_data;
param.lambda = 10;
param.height = height;
param.width = width;
param.eps=0.01;

x0 = ones(h_width,1);

[J, gradJ] = probleme3(x0, param);
[f, trace] = minimisation_nl('probleme3',param,x0);

image=reshape(f,height + h_height - 1,width + h_width -1);
figure(1)
imagesc(z_data);colormap gray
figure(2)
imagesc(image);colormap gray