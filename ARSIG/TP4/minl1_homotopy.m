%% Homotopy continuation method for the minimization of 
% ||y-Ax||^2 + lambda ||x||_1

% Beware, A should have unit-norm columns


function x_def = minl1_homotopy(y,A,lambda)

for k = 1:size(A,2)
  A(:,k) = A(:,k)/norm(A(:,k));
end

verb = 0;

z = 2*A'*y;
lambda_max = max(abs(z));

lambda_current = lambda_max+1;
x = zeros(size(A,2),1);


ind_NZ = find(x~=0);
ind_Z = find(x==0);
u = zeros(size(x));
u_NZ = sign(x(ind_NZ));
num_iter = 0;
stop = 0;

while ~stop
    
    num_iter = num_iter + 1;
    
    A_NZ_A_2 = 2*A(:,ind_NZ)'*A;
    Phi = A_NZ_A_2(:,ind_NZ);
      
    z_Z = z(ind_Z);
    z_NZ = z(ind_NZ);
    
    Phi_inv_z_u_NZ  = Phi\[z_NZ,u_NZ];
    Phi_inv_z_NZ = Phi_inv_z_u_NZ(:,1);
    Phi_inv_u_NZ = Phi_inv_z_u_NZ(:,2);
    
    Psi_dag_Phi_inv_z_u_NZ = A_NZ_A_2(:,ind_Z)'*Phi_inv_z_u_NZ;
    Psi_dag_Phi_inv_z_NZ = Psi_dag_Phi_inv_z_u_NZ(:,1);
    Psi_dag_Phi_inv_u_NZ = Psi_dag_Phi_inv_z_u_NZ(:,2);
    

    % on ne garde que les lambda plus petits que le precedent, avec une tolerance numerique pres
    
    % lambda candidats pour faire passer une composante a 0 (cas 1)
    lambda_cand_1 = Phi_inv_z_NZ./Phi_inv_u_NZ;
    lambda_1 = lambda_cand_1(lambda_cand_1 <lambda_current - 1e-6);
    
    % lambda candidats pour faire passer une composante de 0 a ~=0 (cas 2)
    lambda_cand_2_1 = (z_Z - Psi_dag_Phi_inv_z_NZ )./(1-Psi_dag_Phi_inv_u_NZ);
    lambda_cand_2_2 = (z_Z - Psi_dag_Phi_inv_z_NZ )./(-1-Psi_dag_Phi_inv_u_NZ);
    
    lambda_2_1 = lambda_cand_2_1(lambda_cand_2_1 <lambda_current - 1e-6 );
    lambda_2_2 = lambda_cand_2_2(lambda_cand_2_2 <lambda_current - 1e-6 );
    
    lambda_new = max([lambda_1;lambda_2_1;lambda_2_2]);
    
    if lambda_new>0
        if verb
            fprintf('Iteration %g, lambda = %g, # NZ = %g...',num_iter,lambda_new,sum(u~=0));
        end
        
        %  si on est dans le cas 1: un devient nul
        if lambda_new == max(lambda_1)
            % je recupere l'indice
            ind = find(lambda_cand_1 == lambda_new);
            u(ind_NZ(ind)) = 0;
            if verb
                fprintf(' retrait composante %g\n',ind_NZ(ind));
            end
            
            ind_Z = sort([ind_Z(:);ind_NZ(ind)]);
            ind_NZ = [ind_NZ(1:ind-1);ind_NZ(ind+1:end)];
            
        elseif lambda_new == max(lambda_2_1)    % un devient positif
            % on recupere l'indice
            ind = find(lambda_cand_2_1 == lambda_new);
            ind_nouveau = ind_Z(ind); %ind_nouveau = ind_nouveau(1);
                                                      
            ind_NZ = sort([ind_NZ(:);ind_nouveau]);
            ind_Z = [ind_Z(1:ind-1);ind_Z(ind+1:end)];
            
            % trouver la position du nouveau        
            ind_ind_NZ_new = (ind_NZ == ind_nouveau);
            u(ind_NZ(ind_ind_NZ_new)) = +1;
            if verb
                fprintf(' ajout composante positive %g\n',ind_NZ(ind_ind_NZ_new));
            end
            
        elseif lambda_new == max(lambda_2_2)        % un devient negatif
            % je recupere l'indice
            ind = find(lambda_cand_2_2 == lambda_new);
            ind_nouveau = ind_Z(ind);
            ind_NZ = sort([ind_NZ(:);ind_nouveau]);
            ind_Z = [ind_Z(1:ind-1);ind_Z(ind+1:end)];
            
            % trouver la position du nouveau
            ind_ind_NZ_new = (ind_NZ == ind_nouveau);
            u(ind_NZ(ind_ind_NZ_new)) = -1;
            if verb
                fprintf(' ajout composante negative %g\n',ind_NZ(ind_ind_NZ_new));
            end
        end
        u_NZ = u(u~=0);
        u_tab(num_iter,:) = u;
    end
    
    lambda_tab(num_iter) = lambda_new;
%     lambda_old = lambda_current;
    lambda_current = lambda_new;
    stop = (lambda_new <= lambda);
end


% Ensuite on reprend la forme analytique de cet intervalle
ind_lambda_sup = (lambda_tab(1:end-1)>=lambda & lambda_tab(2:end)<= lambda);

u_lambda = u_tab(ind_lambda_sup,:);
ind_NZ = find(u_lambda~=0);
u_NZ = u_lambda(ind_NZ);

% et on enlève le biais en amplitude
x_NZ = Phi\(z_NZ);
x_def = zeros(size(A,2),1);
x_def(ind_NZ) = x_NZ;
