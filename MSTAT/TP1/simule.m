function [y,x] = simule(u,G,T,Te,L,x1)
    A = [0 1; 0 -1/T];
    B = [0; G/T];
    C = [1 0];
    D = [0];
    [Ad,Bd,Cd,Dd] = c2dm(A,B,C,D,Te, 'zoh');
      
    x = [x1];
    for i = 1:length(u)-1
       x = [x;  (Ad*x(i,:)'+Bd*u(i))'];
       y(i) = Cd*x(i,:)'+Dd*u(i);
    end
    n = length(u);
    y(n) = Cd*x(n,:)'+Dd*u(n);
    y = round(y*L/2/pi)*2*pi/L;
end