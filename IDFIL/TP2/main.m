close all
clear all

load("tergane20.mat")

P = 2.91;
fe = 1000;
Te = 1/fe;

% modèle oe
nf = 3;
nb = 3;

dat = iddata(z(:), yc(:), Te);
figure; plot(dat)
figure; plot(fft(dat))

modoe_d = oe(dat,  [nb,nf,0]);
 
validation(dat, modoe_d);

modoe_c = d2c(modoe_d, "zoh");

t1t2=modoe_c.f(2)/modoe_c.f(3);
T_a = (t1t2+sqrt(t1t2^2-4/modoe_c.f(3)))/2;
T_b = (t1t2-sqrt(t1t2^2-4/modoe_c.f(3)))/2;
T1 = min(T_a, T_b); T2 = max(T_a, T_b);
Ky = modoe_c.f(4) / (P * modoe_c.f(3));
Kz = modoe_c.b(3) / (P * modoe_c.f(3));

% méthode directe
modid = identc(dat, [3 1 0], [5 50], 'gpmfc', 10, 'final');
validation(dat, modid);

% modèle d'état
params={'T1',0.001;
        'T2',0.001;
        'Ky',0;
        'Kz',0};
  
modsys = idgrey('moteur',params,'c');
sys = pem(dat, modsys);
compare(dat, sys);