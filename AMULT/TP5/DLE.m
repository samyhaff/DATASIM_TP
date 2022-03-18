function D=DLE(idx_r_grid,idx_est,r_grid,type)
%distance of localization error
%
%D=DLE(idx_r_grid,idx_est,r_grid,type)
%
%computes the distance of localization error (DLE), that permits to
%evaluate the accuary of an estimated source distribution.
%
%INPUT: idx_r_grid - indices of all active dipoles of the original source
%                    configuration
%       idx_est - indices of all active dipoles of the estimated source
%                 configuration
%       r_grid - 3 x D matrix specifying the positions of the D dipoles of
%                the source space
%       type - set to 2
%
%OUTPUT: D - distance of localization error

if nargin<4
    type=1;
end
if iscell(idx_r_grid)
    idx_com=idx_r_grid{1};
    for k=2:length(idx_r_grid)
        idx_com=common_indices(idx_com,idx_r_grid{k},'add');
    end
    idx_r_grid=idx_com;
end
switch type
    case 1
        D=0;
        N=0;
        for k=1:length(idx_r_grid)
            if iscell(idx_r_grid)
                N=N+length(idx_r_grid{k});
                for n=1:length(idx_r_grid{k})
                    Dnk=normm((r_grid(:,idx_r_grid{k}(n))*ones(1,length(idx_est))-r_grid(:,idx_est)).');
                    D=D+min(Dnk);
                end
            else
                Dnk=normm((r_grid(:,idx_r_grid(k))*ones(1,length(idx_est))-r_grid(:,idx_est)).');
                D=D+min(Dnk);
                N=length(idx_r_grid);
            end
        end
        D=D/N;

    case 2
        D=0;
        for k=1:length(idx_r_grid)
            Dnk=normm((r_grid(:,idx_r_grid(k))*ones(1,length(idx_est))-r_grid(:,idx_est)).');
            D=D+min(Dnk)/length(idx_r_grid);
        end
        for k=1:length(idx_est)
            Dnk=normm((r_grid(:,idx_r_grid)-r_grid(:,idx_est(k))*ones(1,length(idx_r_grid))).');
            D=D+min(Dnk)/length(idx_est);
        end
        D=D/2;
end