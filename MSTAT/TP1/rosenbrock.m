function [y, g, h, j] = rosenbrock(x, params)
    x1 = x(1);
    x2 = x(2);
    b = params.b;
    
    y = b * (x2 - x1 ^ 2) ^ 2 + (1 - x1) ^ 2;
    g = [-4 * x1 * b * (x2 - x1 ^ 2) - 2 * (1 - x1); 2 * b * (x2 - x1 ^ 2)];
    h = [-4 * b * (x2 - x1 ^ 2) + 8 * b * x1 ^ 2 + 2, -4 * b * x1; -4 * b * x1, 2 * b];
    j = [-2 * x1 * sqrt(2 * b), sqrt(2 * b); -sqrt(2), 0]; 
end