function [xh,result,xval] = optimdescent(critfun,params,options,x0)
    %
    % critfun : nom du fichier .m ?valuant la fonction objectif, son gradient et hessien
    % params : param?tres pour l'?valuation de la fonction objectif
    % options : options n?cessaires pour la mise en oeuvre des algorithmes
    %    options.method : 'gradient', 'gradient conjugue', 'newton', 'Quasi-Newton', ...
    %    options.pas : 'fixe', 'variable'
    %    options.const : constante d'armijo
    %    options.beta : taux de rebroussement
    %    options.tolX, options.tolF, options.tolG, options.maxiter
    %    options.pasInit, valeur du pas initial
    %    options.lambda, valeur de lambda pour la methode de levenberg-marquardt
    % x0 : point initial
    % xh : point final
    % result : structure contenant les r?sultats
    %    result.iter : nombre d'iterations r?alis?es
    %    result.crit : valeur du crit?re par iteration
    %    result.grad : norm du gradient par iteration 
    %    result.temp : temps de calcul
    %    result.stop : condition d'arret ('TolX', 'TolG', 'TolF', 'Maxiter')
    % xval : valeurs des it?r?es
    %
    tic
    
    k = 1;
    x = x0;
    stop = 0;
    fval = [];
    gval = [];
    xval = [];

    while not(stop)
        [y, g, h, j] = feval(critfun, x, params);
        if strcmp(options.method, 'gradient')
            d = -g / norm(g);
        elseif strcmp(options.method, 'gradient_conjugue')
            if k > 1
                x_old = xval(:,length(xval)-1);
                x_new = x;
                [y, g_old, h, j] = feval(critfun, x_old, params);
                [y, g_new, h, j] = feval(critfun, x_new, params);
                beta = (norm(g_new)/norm(g_old))^2;
                d = -g_new+beta*d;
            else
               d = -g; 
            end
        elseif strcmp(options.method, 'newton')
            d=-inv(h)*g;
        elseif strcmp(options.method, 'BFGS')
            if k>1
                x_old=xval(:,length(xval)-1);
                x_new=x;
                [y1, g_old, h, j] = feval(critfun, x_old, params);
                [y2, g_new, h, j] = feval(critfun, x_new, params);
                s=x_new-x_old;
                y3=g_new-g_old;
                B=B-(B*s*s'*B)/(s'*B*s)+(y3*y3')/(y3'*s);
                d=-inv(B)*g_new;
            else
                B=norm(g)*eye(length(x));
                d=-inv(B)*g;
            end
        elseif strcmp(options.method, 'gauss-newton')
            d = -(j'*j)^-1*g;
        elseif strcmp(options.method, 'levenberg-marquardt')
            A = j'*j;
            d = -(A+options.lambda*[A(1,1) 0; 0 A(2,2)])^-1*g;
        else
            error("Methode non reconnue")
        end
        if d'*g>0
            d=-d;
        end
        if strcmp(options.pas, "fixe")
           alpha = options.pasInit;
        elseif strcmp(options.pas, "variable")
            alpha = pas(critfun, options.beta, d, options.const, x, options,params);
        else
            error("Methode de choix du pas non reconnue")
        end
        xval = [xval, x];
        fval = [fval, y];
        gval = [gval, norm(g)];
        x = x + alpha * d;
        nb_col = size(xval);
        nb_col = nb_col(2);
        if k > options.maxiter
            stop = 1;
            result.stop = "Maxiter";
        elseif norm(g) < options.tolG
            stop = 1;
            result.stop = "TolG";
        elseif length(fval) > 1 && abs(y - fval(k - 1)) / abs(fval(k - 1)) < options.tolF
            stop = 1;
            result.stop = 'TolF';
        elseif nb_col > 1 && norm(x - xval(:,k - 1)) / norm(xval(:,k - 1)) < options.tolX
            stop = 1;
            result.stop = 'TolX';
        end
        k = k + 1;
    end
    
    result.iter = k;
    result.crit = fval;
    result.grad = gval;
    xh = x;
    result.temps = toc;
end

function alpha = pas(critfun, beta, d, c, x, options,params)
    alpha=options.pasInit;
    [y, g, h, j] = feval(critfun, x, params);
    [y1, g, h, j] = feval(critfun, x+alpha*d, params);
    while y1>y+c*alpha*g'*d
        alpha=beta*alpha;
        [y1, g, h, j] = feval(critfun, x+alpha*d, params);
    end
end
