function [bool]=isstable(th)
%	tests if the model defined in a continuous-time theta format or from the transfer function
%	denominator is stable
%
%	usage:  	[bool]=isstable(th)
%				[bool]=isstable(den)
%
%	parameters : 
%	th	:	continuous-time theta format
%	den :	transfer function	denominator in descending power
%
%	bool	:	result is true if the model is stable		

%	authors  : Eric Huselstein - Hugues Garnier
%	date     : 22 Dec 1999
%  name     : isstable.m
%
%	CRAN - Research Center in Automatic Control of Nancy
%	e-mail : hugues.garnier@cran.u-nancy.fr


% 	Test of the stability of a continuous-time model

[nr,nc]=size(th); 
bool=1;

if (nr==1),				% 	test of the stability of den
   bool=all([real(roots(th))]<0);
else   
   [A,B,C,D,F]=thc2poly(th);
   [nr,nc]=size(F); 
   for i=1:nr
         bool=(bool)&(all([real(roots(F(i,:)))]<0));
   end
   [nr,nc]=size(A); 
   for i=1:nr
         bool=(bool)&(all([real(roots(A(i,:)))]<0));
   end
end  