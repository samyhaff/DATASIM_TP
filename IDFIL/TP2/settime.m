function [Tr]	=	SetTime(A,rate)
%	Settling Time at rate % of the denominator A or of the theta 
%   form th (see help theta)
%	Use :	
%	[Tr]	=	SetTime(A,rate)
%	[Tr]	=	SetTime(th,rate)
%
%	Example : rate = 95 gives the 95% response-time of the model (default)

%	author	: H. Garnier, E. Huselstein 
%	date   	 : 20 novenber  2001
%	name     : SetTime.m
if(nargin<2), rate = 95; end 
[nl,nc]=size(A);
if(nl==1)
if(nc==1), Tr=0; return; end;    
[w0,z]	=	damp(A);

Tr	=	zeros(length(z),1);
Td	=	zeros(length(z),1);
D1	=	zeros(length(z),1);

%	first depassement
k	=	find(z~=1);
D1(k)	=	exp( - pi .* z(k) ./ sqrt(1 - z(k).^2 ) );

%	Real poles or weak overshot

k	=	find(D1<=(100-rate)/100)';
Tr(k)	=	- log(1-rate/100) ./ w0(k);

%	Complex poles with strong overshot
k	=	find(D1>(100-rate)/100);
Td(k) 	= 	pi ./ w0(k) ./ sqrt( 1.- z(k).^2 )  +  (log(100)-log(100-rate) ) ./ w0(k) ./ z(k);

Tr	= 	sum(Tr) + sum(Td) / 2  ;
else
    [A,B,C,D,F]=thc2poly(A);
    Tr=SetTime(A);
    [nu,nc]=size(F);
    for(i=1:nu)
    Tr= max(Tr, SetTime(F(i,:)));
    end;
end    

%step(1,A)
