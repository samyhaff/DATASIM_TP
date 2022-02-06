clear all
close all

load('dataSAFT_exp.mat')

[N_t, N_el] = size(A);

t = linspace(0,(N_t-1)/Fs, N_t);
u = linspace(0, (N_el-1)*d, N_el);

figure()
imagesc(u,t,A)

figure()
plot(t, A(:,1))

%N_x = [64, 128, 256, 512, 1024, 2048];
N_x = [ 128];
tps_matlab = zeros(length(N_x),1);
tps_c = zeros(length(N_x),1);
x_min = u(1); x_max = u(end);
dz = c/(2*Fs);
z_min = t(1); z_max = (N_t-1)*dz;
z = z_min:dz:z_max;
N_z = length(z);

%%

for l =1:length(N_x)
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
    tps_matlab(l) = toc
    
    tic
    O = MEX_SAFT(c, Fs, N_t, N_el, u, N_x(l), N_z, x, z, A);
    tps_c(l) = toc
    
    
end

plot(N_x,tps_c);
hold on
plot(N_x,tps_matlab);


%%
O = abs(hilbert(O));
O = O/max(O(:));
figure()
imagesc(x,z,O); axis equal; xlim([0 round(x(end))]);

figure()
O = reshape(O,[N_z,N_x]);
O = abs(hilbert(O));
O = O/max(O(:));
imagesc(x,z,O); axis equal; xlim([0 round(x(end))]);


