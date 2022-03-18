function y=normm(x)
%returns a vector with the norms of the lines of matrix x

y=zeros(size(x,1),1);
for k=1:size(x,1)
    y(k)=norm(x(k,:),'fro');
end