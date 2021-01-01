function conf = localization(u)

global y1_k0 y2_k0 theta_k0

y1_k1 = u(1);
y2_k1 = u(2);
theta_k1 = u(3);

delta_S = sqrt((y1_k0-y1_k1)^2+(y2_k0-y2_k1)^2);
delta_Th = theta_k1 - theta_k0; 


y1_k2 = y1_k1 + delta_S*cos(theta_k1+delta_Th/2);
y2_k2 = y2_k1 + delta_S*sin(theta_k1+delta_Th/2);
theta_k2 = theta_k1 + delta_Th;

y1_k0 = u(1);
y2_k0 = u(2);
theta_k0 = u(3); 


conf = [y1_k2; y2_k2; theta_k2];