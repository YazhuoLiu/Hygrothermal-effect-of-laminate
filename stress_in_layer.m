function stress = stress_in_layer(load,thetadt,Qcell)
% using SI units: Pa / Degrees Celsius / degrees / meters
% input a 3*1 matrix is [Nx ; Ny ; Nxy]
%% define the engineering constants
alpha1 = 6.3e-6; alpha2 = 20.5e-6;
T0 = 132; T_work = 21;
h_ply = 0.001;
%% compute Qbar and A

Qbar = cell(1,length(thetadt));

for i = 1 : length(thetadt)
    Q = Qcell{1,i};
    T = Coordinate_transformation_matrix(thetadt(i));
    Qbar{1,i} = (T^(-1)) * Q * (T^(-1))' ;
end
clear Q
[A,B,D] = Composite_material_stiffness_matrix(Qcell, thetadt, h_ply);
A

%% Coefficient of thermal expansion for xy coordinate
alpha = cell(1,length(thetadt));
for i = 1 : length(thetadt)
    T = Coordinate_transformation_matrix(thetadt(i));
    alpha{1,i} = T' * [alpha1; alpha2; 0];
end

%% compute thermal internal force
deltaT = T0 - T_work;
Nx = 0; Ny = 0; Nxy = 0;
NT = [Nx, Ny, Nxy]';
for i = 1 : length(thetadt)
    NT = NT + (Qbar{1,i} * alpha{1,i}) * (deltaT * h_ply);
end
clear Nx Ny Nz
%% Determine the strain in mid-plane
strain0 = A^(-1) * (load + NT);

%% determine the stress in each layer xy-direction
stress = cell(1,length(thetadt));
for i = 1 : length(thetadt)
    stress{1,i} = Qbar{1,i} * (strain0 - alpha{1,i} * deltaT);
end

end

