close all
clear all

Delta = 0.1;
A = 0.1;
L = 512;
Te = 10^-3;
D = 1;

u = entree(D,A,Delta,Te);
t = 0:Te:D;

x1_0 = [0; 0];
P1_0 = (2*pi)^2/12;
q = 0.01;

Gexact = 50;
Gfiltre = 50;
Texact = 0.02;
Tfiltre = [0.02, 0.025];

[y,x] = simule(u,Gexact,Texact,Te,L,x1_0);

for i = 1:2
    xe = kal(y,u,Gfiltre,Tfiltre(i),Te,L,x1_0,P1_0,q);
    xe2 = kal_statique(y,u,Gfiltre,Tfiltre(i),Te,L,x1_0,P1_0,q);

    figure(i)
    subplot(2,1,1)
    plot(t,y)
    hold on
    plot(t, xe(:,1))
    plot(t, xe2(:,1))
    plot(t, x(:,1))
    title('Position')
    legend('y', 'xe (opti)', 'xe (stat)', 'x')

    subplot(2,1,2)
    plot(t, xe(:,2))
    hold on
    plot(t, xe2(:,2))
    plot(t, x(:,2))
    title('Vitesse')
    legend('xe (opti)', 'xe (stat)', 'x')
end
