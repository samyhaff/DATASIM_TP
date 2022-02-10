function [A, B, C, D, K, X_0] = moteur(T1, T2, Ky, Kz, Ts)
    P = 2.91;
    A = [-(T2+T1)/(T1*T2) -1/(T1*T2) P*Ky/(T1*T2); 1 0 0; 0 1 0];
    B = [1; 0; 0];
    C = [0 Kz*P/(T1*T2) 0];
    D = [0];
    K=[0;0;0];
    X_0=[0;0;0];
end