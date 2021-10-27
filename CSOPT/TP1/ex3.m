close all
clear all

n = 1000;

x = simsignal(n, 'spectre');

E = std(x)^2;
variance = E / 100;
b = sqrt(variance)*randn([1, n]);

y = x + b;

plot(y, 'r');
hold on
plot(x, 'b');   

lambda = 0.5;
D = diag(ones(n, 1)) - diag(ones(n-1,1),-1);
K=eye(size(y));
Sfinal=(inv((1-lambda)*K'*K+lambda*D'*D))*(1-lambda)*K'.*y';
plot(Sfinal);
err=[];
pas = 0.01;
for lambda=0:pas:1
    S=inv((1-lambda)*K'*K+lambda*D'*D)*(1-lambda)*K'.*y';
    err = [err;norm(S-x)];
end
lambda=0:pas:1;
figure;
plot(lambda,err);