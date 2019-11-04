function Q = lamina_Q(E1,E2,mu21,G12)

mu12 = mu21 * E2 / E1; 
Q11 = E1/(1 - mu12*mu21);
Q22 = E2/(1 - mu12*mu21);
Q12 = (mu12*E1)/(1 - mu12*mu21);
Q66 = G12;

Q = [Q11,Q12,0;Q12,Q22,0;0,0,Q66];


end 