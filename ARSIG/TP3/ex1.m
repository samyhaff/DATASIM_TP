addpath(genpath('Wavelab850'));

N = 1024;
J = 6;
P = 10;
L = P-J;

DWT = zeros(1,N);
DWT(N*(1/(2^J)+1/(2^(J+1)))) = 1;

h1 = MakeONFilter('Haar');
h2 = MakeONFilter('Daubechies',4);
h3 = MakeONFilter('Daubechies',8);

x1 = IWT_PO(DWT,L,h1);
figure(1)
plot_dwt(x1,DWT,J);

x2 = IWT_PO(DWT,L,h2);
figure(2)
plot_dwt(x2,DWT,J);

x3 = IWT_PO(DWT,L,h3);
figure(3)
plot_dwt(x3,DWT,J);
