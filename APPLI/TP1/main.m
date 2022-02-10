clear all
close all

load('dataSAFT_exp.mat')

[N_t, N_el] = size(A);

t = linspace(0,(N_t-1)/Fs, N_t);
u = linspace(0, (N_el-1)*d, N_el);

% figure()
% imagesc(u,t,A)

% figure()
% plot(t, A(:,1))
% xlabel('Temps')
% ylabel('a(t,1)')

N_x = [64, 128, 256, 512, 1024, 2048];
x_min = u(1); x_max = u(end);
dz = c/(2*Fs);
z_min = t(1); z_max = (N_t-1)*dz;
z = z_min:dz:z_max;
N_z = length(z);

tps_matlab = zeros(length(N_x),1);
tps_c = zeros(length(N_x),1);

for l = 1:length(N_x)
    x = linspace(x_min,x_max,N_x(l));
    O = zeros(N_z,N_x(l));

    tic
    for i = 1:N_x(l)
        for j = 1:N_z
            s = 0;
            for k = 1:N_el
                tau = (2/c)*sqrt((x(i)-u(k))^2+z(j)^2);
                if round(Fs*tau)+1<N_t
                    s = s +  A(round(Fs*tau)+1, k);
                end
            end
            O(j, i) = s;
        end
    end
    tps_matlab(l) = toc;
    
    O = abs(hilbert(O));
    O = O/max(O(:));
    
    tic
    O_c = MEX_SAFT(c, Fs, N_t, N_el, u, N_x(l), N_z, x, z, A);
    tps_c(l) = toc;
    
    O_c = reshape(O,[N_z,N_x(l)]);
    O_c = abs(hilbert(O));
    O_c = O/max(O_c(:));
    
    figure()
    subplot(1,2,1)
    imagesc(x,z,O); axis equal; xlim([0 round(x(end))])
    title('Matlab')
    
    subplot(1,2,2)
    imagesc(x,z,O_c); axis equal; xlim([0 round(x(end))])
    title('C')
end

figure()
plot(N_x,tps_c, 'x-');
hold on
plot(N_x,tps_matlab, 'x-');
legend('C', 'Matlab')
xlabel('N_x')
ylabel('temps de calcul (s)')

z_ind = 478;
figure()
plot(x,O(z_ind,:))
hold on
plot(x,O_c(z_ind,:))
legend('Matlab', 'C')
xlabel('x')
ylabel('O(x,z=30)')

figure()
plot(x, abs(O(z_ind,:) - O_c(z_ind,:)))
xlabel('x')
ylabel('Différence')