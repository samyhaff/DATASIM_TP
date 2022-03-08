function [J,gradJ] = Ident_source(p,H,y,lambda,mu)

J = sum((H*p-y).^2)+lambda*sum(sqrt(mu^2+p.^2));
gradJ = 2*H'*(H*p-y)+lambda*p./(sqrt(mu^2+p.^2));

