pas = 0.01;
alpha = 0:pas:2;
beta = 0:pas:4;
params = 0;

F = zeros(length(beta), length(alpha));
for n1 = 1:length(alpha)
    for n2 = 1:length(beta)
        x = [alpha(n1); beta(n2)];
        y = capteur(x, params);
        F(n2, n1) = y(1);
    end
end

subplot(2,1,1);
meshc(alpha, beta, F)
L = 100;
subplot(2,1,2);
contour(alpha, beta, log(F), L)
colorbar