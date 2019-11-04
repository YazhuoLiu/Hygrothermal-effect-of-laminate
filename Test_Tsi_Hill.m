%% define material parameters
E1 = 5.4e10; E2 = 1.8E10; mu21 = 0.25; G12 = 0.88e10;
thetadt = [45, -45, -45, 45];

%% compute Q in each layer
Q_lamina = lamina_Q(E1,E2,mu21,G12);
Qcell = cell(1,length(thetadt));

for i = 1 : length(thetadt)
   Qcell{1,i} = Q_lamina;
end
%% define critical Nx
critical_Nx = [];
p = 1;
failure_layer = zeros(1,length(thetadt));
all_one_row = zeros(1,length(thetadt));
all_one_row(1,:)=1;
%% find every critical Nx
while true
% solve Nx 
syms x
Load = [x;0;0];
stresses = stress_in_layer(Load,thetadt,Qcell);
solutions = zeros(2 ,length(thetadt));
% the first row of 'sulution' is negative value
for i = 1 : length(thetadt)
     T = Coordinate_transformation_matrix(thetadt(i));
     stress = stresses{1,i};
     a = Tsi_Hill(stress,T,x);
     haha = double(solve(a == 1,x));
     if isempty(haha)
         solutions(:,i) = NaN;
     else
         solutions(:,i) = solve(a == 1,x);
     end
     
end

% find the layer number which is failure
% solution(1,:) = []; % clear the negative value of 'solution'
solution = max(solutions);


[Nx_min,index] = min(solution,[],'omitnan');
critical_Nx(1,p) = Nx_min; % storage the Nx_min
p = p+1;

for i = 1:length(solution)
        if (solution(1,i) - Nx_min) <= eps
            failure_layer(1,i) = 1;
        end
end
% refresh Qcell
for i = 1:length(Qcell)
    if failure_layer(1,i) == 1
        T = Coordinate_transformation_matrix(thetadt(i));
        stress = stresses{1,i};
        Q_dradation = Which_kind_of_failure(stress,T,x,Nx_min);
        if Q_dradation(1,1) == 1
            Qcell{1,i}(1,:) = 0;
            Qcell{1,i}(:,1) = 0;
            Qcell{1,i}(3,3) = 0;
        end
        if Q_dradation(1,2) == 1
            Qcell{1,i}(2,:) = 0;
            Qcell{1,i}(:,2) = 0;
            Qcell{1,i}(3,3) = 0;
        end
        if Q_dradation(1,3) == 1
            Qcell{1,i}(3,3) = 0;
        end
        Qcell{1,i}
        (T^(-1)) * Qcell{1,i} * (T^(-1))'
    end
end
Nx_min
failure_layer
if failure_layer == all_one_row
    break
end

end
