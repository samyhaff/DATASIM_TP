function [J,gradJ] = Ident_source_cplx(p,Hh,y,lambda,mu)
H = real(Hh);
G = imag(Hh);

pr = p(1:fix(length(p)/2));
pi = p((1:fix(length(p)/2))+fix(length(p)/2));

J = sum((H*pr+G*pi-y).^2)+lambda*sum(sqrt(mu^2+pr.^2+pi.^2));
gradJ = [2*H'*(H*pr+G*pi-y)+lambda*pr./(sqrt(mu^2+pr.^2+pi.^2));...
    2*G'*(H*pr+G*pi-y)+lambda*pi./(sqrt(mu^2+pr.^2+pi.^2))];

