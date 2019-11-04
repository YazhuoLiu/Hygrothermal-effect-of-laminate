function Q_dradation = Which_kind_of_failure(stress_xy,T,x,Nx_min)
% this function gives you the kind of lanina failure, 1 means fail. (1,1)
% means 1-direction fail, (1,2) means 2-direction fail, (1,3) means shear
% fail.
%% define the Tsi_Hill_limit
Xt = 1.05e9; Xc = 1.05e9; Yt = 2.8e7; Yc = 14e7; S = 4.2e7;
Q_dradation = zeros(1,3);
%% find normal stress and shear stress
stress = T * stress_xy;
sigma1 = stress(1,1);
sigma2 = stress(2,1);
tore12 = stress(3,1);
%% find stresses
        sigma1_double = double(subs(sigma1,x,Nx_min))
        sigma2_double = double(subs(sigma2,x,Nx_min))
        tore12_double = double(subs(tore12,x,Nx_min))
%% Which_kind_of_failure
        if sigma1_double >= 0
                if sigma1_double - Xt >0 || abs(sigma1_double - Xt) <= 0.1 * Xt
                    Q_dradation(1,1) = 1;
                end
        else
                if sigma1_double - Xc >0 || abs(sigma1_double - Xc) <= 0.1 * Xc 
                    Q_dradation(1,1) = 1;
                end
        end
        
        if sigma2_double >= 0
                if sigma2_double - Yt >0 || abs(sigma2_double - Yt) <= 0.1 * Yt 
                    Q_dradation(1,2) = 1;
                end
        else
                if sigma2_double - Yc >0 || abs(sigma2_double - Yc) <= 0.1 * Yc 
                    Q_dradation(1,2) = 1;
                end
        end
        
        if tore12_double - S > 0||abs(tore12_double - S) <= 0.1 * S  
            Q_dradation(1,3) = 1;
        end
        Q_dradation
end