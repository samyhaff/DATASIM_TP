addpath(genpath('Wavelab850'));

N = 1024;
J = 6;
P = 10;
L = P-J;

DWT = zeros(1,N);
% DWT(N*(1/(2^J)+1/(2^(J+1)))) = 5;
DWT(N/(2^(J+1))-1) = 2;

h1 = MakeONFilter('Haar');
h2 = MakeONFilter('Daubechies',4);

x = IWT_PO(DWT,L,h1);
% plot_dwt(x,DWT,J);
