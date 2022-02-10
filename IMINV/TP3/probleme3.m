function [J, gradJ] = probleme3(x, param)

    z_data = param.z_data;
    z = z_data(:);
    R = param.R;
    lambda = param.lambda;
    width = param.width;
    height = param.height;
    x_image = reshape(x, height, width);
    eps = param.eps;
    x_pad = padarray(x_image, [1,1], 0, 'post');
    somme = 0;
    
    grad_mc = 2*R'*R*x - 2*R'*z;    
    mc = norm(z_image - R*x)^2;
    
    for i = 1:height
        for j = 1:width
            somme = somme + sqrt((x_pad(i,j)-x_pad(i,j+1))^2 + eps^2) + sqrt((x_pad(i,j)-x_pad(i+1,j))^2+eps^2);
        end
    end
    J = mc + lambda * somme;
    grad2 = [];
    x_pad = padarray(x_image,[1,1],0);
    for i=2:height+1
        for j=2:width+1
            somme = (x_pad(i,j)-x_pad(i,j+1))/sqrt(eps^2 + (x_pad(i,j)-x_pad(i,j+1))^2) + ...
            (x_pad(i,j)- x_pad(i,j-1))./sqrt(eps^2 +(x_pad(i,j)- x_pad(i,j-1))^2) + ...
            (x_pad(i,j) - x_pad(i+1,j))./sqrt(eps^2 + (x_pad(i,j) - x_pad(i+1,j))^2) + ...
            (x_pad(i,j) - x_pad(i-1,j))./sqrt(eps^2 + (x_pad(i,j) - x_pad(i-1,j))^2);
            grad2 = [grad2; somme];
        end
    end
    gradJ = grad_mc + grad2;
end