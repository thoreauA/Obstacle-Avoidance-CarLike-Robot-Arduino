function q_dot = diff_drive(q)
 
global b radius distc

wR = q(1);
wL = q(2);
theta = q(3); 

y1_dot = (cos(theta)*(radius/2)-b*sin(theta)*(radius/distc))*wR + (cos(theta)*(radius/2)+b*sin(theta)*(radius/distc))*wL;
y2_dot = (sin(theta)*(radius/2)+b*cos(theta)*(radius/distc))*wR + (sin(theta)*(radius/2)-b*cos(theta)*(radius/distc))*wL;
theta_dot = (radius/distc)*wR-(radius/distc)*wL;

q_dot = [y1_dot; y2_dot; theta_dot];

