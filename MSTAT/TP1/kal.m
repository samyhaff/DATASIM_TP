function xe = kal(y,u,G,T,Te,L,x1_0,P1_0,q)
    A = [0 1; 0 -1/T];
    B = [0; G/T];
    C = [1 0];
    D = [0];
    [Ad,Bd,Cd,Dd] = c2dm(A,B,C,D,Te, 'zoh');

    r = (2*pi/L)^2/12;
    xe = zeros(2,length(u));
    
    for i=1:length(u)
       y1_0 = Cd*x1_0;
       Cxy = P1_0*Cd';
       Cyy = Cd*P1_0*Cd'+r;
       x1_0 = x1_0+Cxy*Cyy^-1*(y(i)-y1_0);
       xe(:,i) = x1_0;
       P1_0 = P1_0-Cxy*Cyy^-1*Cxy';
       x1_0 = Ad*x1_0+ Bd*u(i);
       P1_0 = Ad*P1_0*Ad'+Bd*q*Bd';
    end
    
    xe = xe';
 end