function f = MAPL1(Vt,D,lbd)
% IRLS type method to minimize
% J(f) = sum_m ||D(v_m-f)||_1 + lbd ||f||_2^2
% with lbd: regularization parameter
% Vt = (v_m) (juxtaposition of column vectors)
% D: matrix

[N M] = size(Vt);
f = zeros(N,1);
theta = .9;
cour = ones(N-1,M);
dV = D*Vt;

for n=1:20,
  new = abs(dV-repmat(D*f,1,M));
  cour = cour + theta*(new-cour);
  ell = .5./cour;
  L = spdiags(sum(ell,2),0,N-1,N-1);
  dVmoy = sum(dV.*ell,2);
  f = (D'*L*D+lbd*speye(N))\(D'*dVmoy);
end