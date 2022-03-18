function id=common_indices(id1,id2,type)
%determines common indices of two index vectors, removes common indices
%from first index vector of adds indices while ensuring that the same index
%does not occur twice
%
%id=common_indices(id1,id2,type)
%returns different output index vectors according to the specified type:
% - for the type 'common', the common indices of both index vectors id1 and
%   id2 are returned
% - for the type 'add', the indices of vectors id1 and id2 are while
%   ensuring that no index is contained more than 1 time
% - for the type 'remove', the common indices of the two index vectors are
%   removed from the index vector id1
%
%INPUT: id1, id2 - index vectors
%       optional:
%       type - 'common', 'add' or 'remove'. Specifies which indices shall 
%               be returned. Default is 'common'.
%
%OUTPUT: id - output index vector
%
% Hanna Becker, February 2010

if nargin<3
    type='common';
end

%convert index vectors to row vectors 
if size(id1,1)>size(id1,2)
    id1=id1.';
end
if size(id2,1)>size(id2,2)
    id2=id2.';
end

if strcmp(type,'add')
    id=id1;
    if isempty(id2);
        return;
    end
else
    id=[];
end
%sort both index vectors
id1=sort(id1);
id2=sort(id2);

%initialization of the number of common dipoles
n_com=0;

%compare sorted index vectors and remove already considered elements
while isempty(id1)==0&&isempty(id2)==0
    %if inidices of second index vector are smaller then the currently
    %examined index of the first vector, they can be...
    while isempty(id2)==0&&id2(1)<id1(1)
        %...added in the case of adding the indices
        if strcmp(type, 'add')
            id=[id,id2(1)];
        end
        
        %removed in the other cases because of no interest
        id2=id2(2:end);
    end

    %if inidices are equal, they are...
    if isempty(id2)==0&&id1(1)==id2(1)
        %remove the index from the second index vector
        id2=id2(2:end);
        
        %...stored if common indices are searched for
        if strcmp(type,'common')
            %increase number of common dipoles
            n_com=n_com+1;
            %stored common index
            id(n_com)=id1(1);
            
        %...removed from the first index vector if the type is 'remove'    
        elseif strcmp(type,'remove' )
            id1=id1(2:end);
            continue;
        end

    end

    %if the first index of index vector 1 has not been remove because equal
    %to an index of vector id2, keep it in the case of type 'remove'
    if strcmp(type,'remove')
        id=[id,id1(1)];
    end
    
    %remove the index from the first index vector
    id1=id1(2:end);
end

%prepare output vectors
if strcmp(type,'remove')
    id=[id,id1];
elseif strcmp(type,'add')
    id=[id,id2];
end
end