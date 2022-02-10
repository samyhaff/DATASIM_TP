function [J, gradJ] = probleme1(x, param)
    z_image = param.z_image;
    z = z_image(:);
    crit = param.crit;
    h = param.noyau;
    lambda = param.lambda;
    width = param.width;
    height = param.height;
    x_image = reshape(x, height, width);
    
    grad_mc = 2*conv2(conv2(x_image, h, "valid"), flipud(fliplr(h)), "full") - ...
        2*conv2(z_image, flipud(fliplr(h)), 'full');
    grad_mc = grad_mc(:);
    e=z_image - conv2(x_image, h, "valid");
    mc = norm(e(:))^2;
    
    switch crit
        case 1
            J = mc + lambda * norm(x)^2;
            gradJ = grad_mc + 2 * lambda * x;
        case 2
            eps = param.eps;
            J = mc + sum(sqrt(x.^2+eps^2));
            gradJ = grad_mc + lambda * (x ./ sqrt(x.^2 + eps^2));
        case 3
            x_pad = padarray(x_image, [1,1], 0, 'post');
            somme = 0;
            for i = 1:height
                for j = 1:width
                    somme = somme + (x_pad(i,j)-x_pad(i,j+1))^2 + (x_pad(i,j)-x_pad(i+1,j))^2;
                end
            end
            J = mc + lambda * somme;
            grad2 = [];
            x_pad = padarray(x_image,[1,1],0);
            for i=2:height+1
                for j=2:width+1
                    somme = (x_pad(i,j)-x_pad(i,j+1)) + (x_pad(i,j)- x_pad(i,j-1)) + ...
                    (x_pad(i,j) - x_pad(i+1,j)) + (x_pad(i,j) - x_pad(i-1,j));
                    grad2 = [grad2; 2*somme];
                end
            end
            gradJ = grad_mc + grad2;
            
        case 4
            eps = param.eps;
            x_pad = padarray(x_image, [1,1], 0, 'post');
            somme = 0;
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
end