clear all;

%% Definition parameters for potetial fields and obstacle position points
%

global radius distc previousPos xdFinalPosition ydFinalPosition
global n_obst radiusObst xcObst ycObst n_0 bt wR wL startc startl
 
radius = 3.25; % [cm]
distc = 14.5; % [cm]

%% Total simulation time
%
T=20;

%% INITIAL configuration of the unicycle
%
x_0 = 10; %10
y_0 = 40; %40
theta_0 = 0; 
previousPos = [x_0;y_0; theta_0];

%% FINAL destination point
%
xdFinalPosition = 178;
ydFinalPosition = 75; %80

%% OBSTACLES, cilindric shape
%
n_obst = 2;
radiusObst = [8, 8];
xcObst = [50, 100]; % x coordinate of the center of each obstacle
ycObst = [45, 57]; % y coordinate of the center of each obstacle
n_0 = [20, 20]; % distance after which the vortex forces are not zero

% INITIAL speed needed
w = potential([x_0 y_0 theta_0]);
wR = w(1)
wL = w(2)
startc = 1;
startl = 0;
% CONNECTION BLT
bt=serialport("/dev/rfcomm0",115200);
