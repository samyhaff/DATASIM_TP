function [xh,result,xval] = optimdescent(critfun,params,options,x0)
    %
    % critfun : nom du fichier .m ?valuant la fonction objectif, son gradient et hessien
    % params : param?tres pour l'?valuation de la fonction objectif
    % options : options n?cessaires pour la mise en oeuvre des algorithmes
    %    options.method : 'gradient', 'gradient conjuge', 'Newton', 'Quasi-Newton', ...
    %    options.pas : 'fixe', 'variable'
    %    options.const : constante d'armijo
    %    options.beta : taux de rebroussement
    %    options.tolX, options.tolF, options.tolG, options.maxiter
    %    options.pasInit, valeur du pas initial
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

    k = 1;
    x = x0;
    stop = 0;
    fval = [];
    gval = [];
    xval = [];

    while not(stop)
        [y, g, h, j] = feval(critfun, x, params);
        if options.method == 'gradient'
            d = -g / norm(g);
        else
            error("Methode non reconnue")
        end
        if options.pas == "fixe"
           alpha = options.pasInit;
        else
            alpha = 
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
    result.temps = 0;
    xh = x;
end

function alpha = pas(critfun, beta, d, c, x]

end