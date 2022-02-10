function [th]=mkstable(th)
%   stabilizes either a MONIC polynomial, a continuous-time theta format or a state matrix 
%   i.e. roots whose real parts are greater than zero are reflected 
%   into the stability domain (the real parts becomes negative).  The result is either a monic
%   polynomial, a continuous-time theta format or state matrix.
%
%	usage:  	th=mkstable(th)
%				den=mkstable(den)
%				A=mkstable(A)
%
%	parameters : 
%
%	th	:	continuous-time theta format
%	den :	continuous-time transfer function denominator in descending power (den must be monic)
%   A   :   continuous-time state matrix

%	authors  : Eric Huselstein - Hugues Garnier
%	date     : 22 Dec 1999
%	rev	 : 05 Dec 2000 (MM) + 11 Feb 2002 (HG)
%  	name     : mkstable.m
%
%	CRAN - Research Center in Automatic Control of Nancy
%	e-mail : hugues.garnier@cran.uhp-nancy.fr


% 	Test of the stability of a continuous-time model
[nr,nc]	=	size(th); 
if (nr==1),	% th=denominator polynomial			 
	zero_found=1;
    i=0;
	while (zero_found==1),
		if th(1)==0,
			th=th(2:length(th));
            i=i+1;
		else
			zero_found=0;
		end
	end
   v = roots(th);
   j=find(real(v)>0);
   if(~isempty(j)), 
    v(j)=-conj(v(j));
   	th =  poly(v)*th(1); 
   end
   th = [zeros(1,i) th];
elseif (nr~=nc) % theta format  
   [A,B,C,D,F,P,nk,Ts,J,Ve,method]=thc2poly(th);
   [nr,nc]=size(F);
   for i=1:nr
	    F(i,:) = mkstable(F(i,:));
   end
    A=mkstable(A);

    thtemp=poly2thc(A,B,C,D,F,nk,Ts,P,J,Ve,method);
    param=thc2par(thtemp);

    [nl_param,nc_param]=size(param);
    %    Test for Matlab6 compatibility --------
    if nl_param>1 
        param=param';
    end
    [nl_param,nc_param]=size(param);
    % ---------------------------------------

    th(3 , 1 : nc_param )=param;
elseif (nr==nc) % th=A state matrix 
[V,D]=eig(th);
    if cond(V)>10^8, [V,D]=schur(th);[V,D]=rsf2csf(V,D);end
    if max(real(diag(D)))<0,return,end
    for kk=1:nr
        if real(D(kk,kk))>0,D(kk,kk)=-conj(D(kk,kk));end
    end
    th=real(V*D*inv(V));
end