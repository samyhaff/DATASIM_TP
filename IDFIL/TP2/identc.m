function modid = identc(data,ord,param,meth,niter,affich);

% Identification d'un mod?le ? temps continu par filtrage lin?aire invariant
%
%           modid = identc(data,orders,filtparam,meth,niter,affich);
%
% -- Input :
%
%   data        : donnees de l'identification sous format iddata 
%   orders      : ordre du mod?le ? estimer
%                   ORD = [ND NN NK] : [D?nominateur Num?rateur Retard]
%   filtparam   : param?tres du filtre 
%                   PARAM = [ORDRE BETA LAMBDA] 
%   meth        : type de filtre
%                   'gpmfc'  => filtre de Poisson      
%                   'gpmfn'  => filtre de regularisation {m?thode par
%                   d?faut}
%   niter       : nombre d'it?rations {NITER = 1 par d?faut}
%   affich      : mode d'affichage des r?sultats
%                   'iter'   => affichage des r?sultats int?rn?diares   
%                   'final'  => affchage des r?sultats finaux 
%                   'aucun'  => pas d'affichage {m?thode par d?faut}      
%
% -- Output 
%
%   modid : identified continuous-time model in idmodel object
%
% Voir aussi: IDENTFLTV
%

%==================================================================================
echo off;

switch nargin
    case 3
        meth    = [];
        niter   = 1;
        affich  = 'aucun';
    case 4
        niter   = 1;
        affich  = 'aucun';
    case 5
        affich  = 'aucun';
    case 6
    otherwise 
        error(' Nombre d''arguments d''entr?e incorrect');
end
%
sigin = data.u;
sigout = data.y;
Te = data.Ts;

if isempty(meth), meth='gpmfn'; end
if isempty(niter), niterb = 1;
end
nsys  = length(ord);
switch nsys
    case 1
        nd = ord(1); nn = 0; nk = 0;
    case 2
        nd = ord(1); nn = ord(2); nk = 0;
    case 3
        nd = ord(1); nn = ord(2); nk = ord(3);
    otherwise
        error(' Les parametres du systeme sont incoh?rents');
end
if nd < nn
    error(' L''ordre du num?rateur doit etre inferieur ? celui du denominateur ');
end
nfilt = length(param);
switch nfilt
    case 2
        ngpmf = param(1); betta = param(2); lamda = betta;
    case 3
        ngpmf = param(1); betta = param(2); lamda = param(3);
    otherwise
        error(' Les param?tres du filtre sont incoh?rents');
end
if ngpmf < nd
    error(' L''ordre des filtres doit ?tre superieur ou ?gal ? l''ordre du mod?le');
end

% Traitements
if size(sigin,1) > size(sigin,2)
    sigin = sigin.';
end
if size(sigout,1) > size(sigout,2)
    sigin = sigin.';
end
%
sigin  = sigin(1:end-nk);
sigout = sigout(nk+1:end);
N      = min(length(sigin),length(sigout));
sigin  = sigin(1:N);
sigout = sigout(1:N);
t      = 0:Te:(N-1)*Te;
freq   = (-N/2:(N-1)/2)./Te./N;
nmar   = floor(3*(ngpmf+1)/lamda/ Te);
if (~isequal(meth,'gpmfc'))&(~isequal(meth,'gpmfn'));
    error('la m?thode de filtrage n''est pas bien sp?cifi?e'); end

%
switch meth;
    case 'gpmfc'
        M      = max(N-nmar,50);
        nmar   = N-M; 
               
        % Simulation des GPMFs
        a = [1 lamda];
        b = betta;
        c = a;
        d = [1 0];
        for k=1:ngpmf
            a = conv(a,c); b = b.*betta;
        end
        bf = b;
        af = a;
        switch affich
            case 'iter'
                fprintf('\n It?ration     Num?rateur      ');
                for k = 1:nn
                    fprintf('             ');
                end
                fprintf('D?nominateur\n\n');
        end
        for iter = 1:niter
            b = bf;
            for k = 0:nn
                momin(k+1,1:N) = lsim(tf(b,a),sigin,t).';
                b = conv(b,d);
            end
            b = bf;
            %
            for k = 0:nd
                momout(k+1,1:N) = lsim(tf(b,a),sigout,t).';
                b = conv(b,d);
            end
            
            % Moindres carr?s
            Y = zeros(1,M);
            H = zeros(M,nn+nd+1);
            Y(:) = momout(nd+1,nmar+1:nmar+M);
            for j=1:nd
                H(:,j) = - momout(nd+1-j,nmar+1:nmar+M).';
            end
            for j=0:nn
                H(:,nd+1+j) = momin(nn+1-j,nmar+1:nmar+M).';
            end
            x = pinv(H)*Y.';
            Ncls(1:nn+1) = x(nd+1:nd+nn+1);
            Dcls(1:nd+1) = [1 x(1:nd).'];
            
            % Variable instrumentale
            test = isstable(Dcls);
            if test==0, Dcls = mkstable(Dcls);test=1;test = isstable(Dcls);end
            switch test
                case 1
                    sigaux  = lsim(tf(Ncls,Dcls),sigin,t);
                    b = bf;
                    %
                    for k = 0:nd
                        momaux(k+1,1:N) = lsim(tf(b,a),sigaux,t).';
                        b = conv(b,d);
                    end
                    
                    % Construction du regresseur lin?aire instrumental
                    for j=1:nd
                        V(1:M,j) = - momaux(nd+1-j,nmar+1:nmar+M).';
                    end
                    for j=0:nn
                        V(1:M,nd+1+j) = momin(nn+1-j,nmar+1:nmar+M).';
                    end
                    % Solution de la variable instrumentale
                    x            = inv(V.'*H)*V.'*Y.';
                    Nciv(1:nn+1) = x(nd+1:nd+nn+1);
                    Dciv(1:nd+1) = [1 x(1:nd).'];
                    switch affich
                        case 'iter'
                            fprintf('   %2.0f   ',iter);
                            fprintf('    %4.4f',Nciv(1:nn));
                            fprintf('    %4.4f     ',Nciv(nn+1))
                            fprintf('    %4.4f',Dciv(1:nd));
                            fprintf('    %4.4f\n',Dciv(nd+1))        
                    end
                case 0            
                    fprintf('Warning !!! Le mod?le estim? par moindres carr?s est instable \n')           
                    Nciv(1:nn+1) = 0;
                    Dciv(1:nd+1) = 0;
                    eqm          = 100;
                    return;
            end
            test = isstable(Dciv);
            if test==0, Dciv = mkstable(Dciv);test=1;end
            if (isstable(Dciv) & Dciv(1:nd+1)~=0)
                af  = conv(Dciv,Dciv);
                bf  = Dciv(nd+1).^2;
                d   = [1 0];
                a   = af;
            else
                fprintf('Warning !!! Le mod?le estim? par variable instrumentale est instable \n')           
                Nciv(1:nn+1) = 0;
                Dciv(1:nd+1) = 0;
                b  = betta.^(ngpmf+1);
                d  = [1 0];
                bf = b;
            end
            Tr = settime(Dciv);
            nr = ceil(Tr/Te);
            M      = N - nr;
           if M < 50;
              %  warning(' Le nombre d''?chantillons des signaux est devenu trops petit');
                M      = N - nmar;
            else
                nmar = nr;
            end
            clear H V
        end
        %********************************************************************************************************
        % M?thode de r?gularisation
        %********************************************************************************************************
    case 'gpmfn' 
        M    = max(N - 2*nmar,50);
        nmar = floor((N-M)/2);
        
        % Construction du filtre
        a   = [1 lamda];
        ain = [1 100];
        b   = betta;
        bin = [100];
        c   = a;
        cin = ain;
        d   = [1 0];
        for k = 1:ngpmf
            a = conv(a,c);
            b = b.*betta;
        end
        bf  = b;
        switch affich
            case 'iter'
                fprintf('\n It?ration     Num?rateur    ');
                for k = 1:nn
                    fprintf('              ');
                end
                fprintf('D?nominateur\n\n');
        end
        for iter = 1:niter
            
            % Calcul des d?riv?es du signal d'entr?e
            b = bf;
            for k = 0:nn
                mom               = lsim(tf(b,a),sigin,t).';
                momin(k+1,N:-1:1) = lsim(tf(bf,a),mom(N:-1:1),t).';
                b = conv(b,d);
            end
            
            % Calcul des d?riv?es  du signal de sortie
            b = bf;
            %
            for k = 0:nd
                mom                = lsim(tf(b,a),sigout,t).';
                momout(k+1,N:-1:1) = lsim(tf(bf,a),mom(N:-1:1),t).';
                b = conv(b,d);
            end
            
            % Construction du regresseur lin?aire y = H x
            Y = zeros(1,M);
            H = zeros(M,nn+nd+1);
            Y(:) = momout(nd+1,nmar+1:nmar+M);
            for j=1:nd
                H(1:M,j) = - momout(nd+1-j,nmar+1:nmar+M).';
            end
            for j=0:nn
                H(1:M,nd+1+j) = momin(nn+1-j,nmar+1:nmar+M).';
            end
            
            % Estimateur des moindres carr?s :
            x = H\Y';
            Ncls(1:nn+1) = x(nd+1:nd+nn+1);
            Dcls(1:nd+1) = [1 x(1:nd).'];
            
            % M?thode de variable instrumentale it?rative       
            test = isstable(Dcls);
            if test==0, Dcls = mkstable(Dcls);test=1;end
            switch test
                case 1
                    % Calcul des d?riv?es filtr?es du signal auxiliare
                    sigaux  = lsim(tf(Ncls,Dcls),sigin,t);
                    b = bf;
                    %
                    for k = 0:nd
                        mom                = lsim(tf(b,a),sigaux,t).';
                        momaux(k+1,N:-1:1) = lsim(tf(bf,a),mom(N:-1:1),t).';
                        b = conv(b,d);
                    end
                   
                    % Construction du regresseur lin?aire instrumental
                    for j=1:nd
                        V(1:M,j)      = - momaux(nd+1-j,nmar+1:nmar+M).';
                    end
                    for j=0:nn
                        V(1:M,nd+1+j) = momin(nn+1-j,nmar+1:nmar+M).';
                    end
                    
                    % Solution de la variable instrumentale it?rative
                    x            = inv(V.'*H)*(Y*V).';
                    Nciv(1:nn+1) = x(nd+1:nd+nn+1);
                    Dciv(1:nd+1) = [1 x(1:nd).'];
                    switch affich
                        case 'iter'
                            fprintf('   %2.0f   ',iter);
                            fprintf('    %4.4f',Nciv(1:nn));
                            fprintf('    %4.4f     ',Nciv(nn+1))
                            fprintf('    %4.4f',Dciv(1:nd));
                            fprintf('    %4.4f\n',Dciv(nd+1)),
                    end
                    calc = 'ok';  
            end
            
            test = isstable(Dciv);
            if test==0,
                Dciv = mkstable(Dciv);
                Nciv(end:-2:1)=-Nciv(end:-2:1);
                test=1;
            end

            isstable(Dciv);
            if (isstable(Dciv) & Dciv(1:nd+1)~=0)
                % Construction du nouveau filtre
                bf = 1;           
                af = Dciv;
                d  = [1 0];
                a  = af;
            else
                fprintf(' Warning !!! Le mod?le estim? par variables instrumentale est instable');
                Nciv(1:nn+1) = 0;
                Dciv(1:nd+1) = 0;
                bf  = betta.^(ngpmf+1);
                d  = [1 0];
                return;
            end
            Tr  = settime(Dciv);
            nr  = ceil(Tr/Te);
            M   = N - 2*nr;
            if M < 50;
          %      warning(' Le nombre d''?chantillons des signaux est devenu insuffisant');
                M      = N - 2*nmar;
            else
                nmar = nr;
            end
            clear H V
        end
end
switch affich
    case 'final'
        fprintf('\n It?ration     Num?rateur    ');
        for k = 1:nn
            fprintf('              ');
        end
        fprintf('D?nominateur\n\n');
        fprintf('   %2.0f   ',iter);
        fprintf('    %4.4f',Nciv(1:nn));
        fprintf('    %4.4f     ',Nciv(nn+1))
        fprintf('    %4.4f',Dciv(1:nd));
        fprintf('    %4.4f\n',Dciv(nd+1)),
end

%%
modid = idpoly(1,Nciv,1,1,Dciv,...
    'Ts',0,...
    'InputName',data.InputName,...
    'OutputName',data.OutputName,...
    'InputUnit',data.InputUnit,...
    'OutputUnit',data.OutputUnit,...
    'TimeUnit',data.TimeUnit);