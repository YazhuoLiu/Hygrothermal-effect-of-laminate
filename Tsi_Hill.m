function a = Tsi_Hill(stress_xy,T,x)
%% define the Tsi_Hill_limit
Xt = 1.05e9; Xc = 1.05e9; Yt = 2.8e7; Yc = 14e7; S = 4.2e7;
%% find normal stress and shear stress
stress = T * stress_xy;
sigma1 = stress(1,1);
sigma2 = stress(2,1);
tore12 = stress(3,1);
%% find limit to use
        sigma1_double = double(subs(sigma1,x,1));
        sigma2_double = double(subs(sigma2,x,1));

if sigma1_double >= 0
    X = Xt;
else
    X = Xc;
end

if sigma2_double >= 0
    Y = Yt;
else
    Y = Yc;
end

%% compute a
        a = (sigma1^2)/(X^2) - (sigma1*sigma2)/(X^2) + (sigma2^2)/(Y^2) + (tore12^2)/(S^2);
end