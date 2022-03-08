load envir_optim_US2


num_trace = 100;
figure
subplot(211)
plot(H(1:4:end,250))
title('Ondelette')


subplot(212)
plot(Bscan_y(num_trace,1:4:2000)')
title('Ondelette')
title('Trace à déconvoluer')


%%% Identification en variables réelles
% Initialisation de l'optimisation
p0 = zeros(size(H(1:4:end,1:4:end),2),1);

lambda = 1e-3;
mu = 0.0001;

popt_r = fminunc(@(p) Ident_source(p,H(1:4:end,1:4:end),Bscan_y(num_trace,1:4:2000)',lambda,mu),p0,optimset('Display','Iter','GradObj','on'));

figure;
subplot(211)
plot(popt_r)
title(['Identification réelle : Solution - Lambda = ' num2str(lambda) ' mu = ' num2str(mu) ])

subplot(212)
plot([H(1:4:end,1:4:end)*popt_r,Bscan_y(num_trace,1:4:2000)'])
title('Adéquation aux données')


%%% Identification en variables complexes sur la transformée de Hilbert
p0 = zeros(2*size(H(1:4:end,1:4:end),2),1);

Hh = hilbert(H(1:4:end,1:4:end));

lambda = 1e-3
mu = 0.0001



popt_c = fminunc(@(p) Ident_source_cplx(p,Hh,Bscan_y(num_trace,1:4:2000)',lambda,mu),p0,optimset('Display','Iter','GradObj','on'));

figure;
subplot(211)
plot([popt_c(1:500,1) popt_c(501:1000,1)])
title(['Identification complexe : Solution - Lambda = ' num2str(lambda) ' mu = ' num2str(mu) ])

subplot(212)
plot([real(Hh)*popt_c(1:500,1)+imag(Hh)*popt_c(501:1000,1),Bscan_y(num_trace,1:4:2000)'])
title('Adéquation aux données')

% Comparaison des modules 
figure;
plot([abs(hilbert(popt_r)) abs(popt_c(1:500)+1i*popt_c(501:1000))])
legend({'Solution réelle','Solution complexe'})
title(['Déconvolution US 1D - Lambda = ' num2str(lambda) ' mu = ' num2str(mu) ])



