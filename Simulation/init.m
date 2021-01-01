clear all;

global b radius distc y1_k0 y2_k0 xdFinalPosition ydFinalPosition
global n_obst radiusObst xcObst ycObst n_0 
 
radius = 3.25; %3.25 cm
distc = 14.5; %14.5 cm
b = 1;

% total simulation time
T=20;

% INITIAL configuration of the unicycle
x_0 = 10;
y_0 = 40;
theta_0 = 0; 
%previousPos = [x_0;y_0];

% FINAL destination point
xdFinalPosition = 170;
ydFinalPosition = 80;

y1_k0 = x_0 + b*cos(theta_0);
y2_k0 = y_0 + b*sin(theta_0);

% OBSTACLES
n_obst = 2;
radiusObst = [10, 10];
xcObst = [50, 100]; 
ycObst = [40, 60];
n_0 = [20, 20]; % distance after which the vortex forces are not zero
