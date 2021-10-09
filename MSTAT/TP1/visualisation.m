x1 = -4:0.05:4;
x2 = -5:0.05:20;
F = zeros(length(x2), length(x1));
params.b = 2;
for n1 = 1:length(x1)
    for n2 = 1:length(x2)
        x = [x1(n1); x2(n2)];
        y = rosenbrock(x, params);
        F(n2, n1) = y(1);
    end
end

meshc(x1, x2, F);
L = 100;
contour(x1, x2, F, L); 