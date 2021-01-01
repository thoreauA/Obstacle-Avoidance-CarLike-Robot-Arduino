
close all
hold off
clf

global n_obst radiusObst xcObst ycObst
x=configuration.signals.values(:,1);
y=configuration.signals.values(:,2);
theta=configuration.signals.values(:,3);
t=configuration.time;
v=inputs.signals.values(1,:);
omega=inputs.signals.values(2,:);

%{
figure(1);
%subplot(2,2,1)
hold on;
axis equal;
set(gca,'fontname','Times','fontsize',12,'fontweight','normal');box on;
%}
% setup unicycle shape

unicycle_size=10;
vertices_unicycle_shape=unicycle_size*[[-0.25;-0.5;1/unicycle_size],...
    [0.7;0;1/unicycle_size],[-0.25;0.5;1/unicycle_size]];
faces_unicycle_shape=[1 2 3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

resolution = 50;
width = 200;
height = 100;
h = resolution*height;
w = resolution*width;
r = [ones(40,1); zeros((h-2*2*20),1); ones(40,1)];
matrix_occ = [ones(h,40), repmat(r,1,w-2*2*20), ones(h,40)];

% empty map
map = binaryOccupancyMap(matrix_occ, resolution);
figure(1)
show(map)
hold all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% plot unicycle initial configuration

M=[cos(theta_0) -sin(theta_0) x_0; sin(theta_0) cos(theta_0)  y_0;0 0 1]; 
vertices_unicycle_shape_0=(M*vertices_unicycle_shape)';
vertices_unicycle_shape_0=vertices_unicycle_shape_0(:,1:2);
patch('Faces',faces_unicycle_shape,'Vertices',vertices_unicycle_shape_0,...
    'FaceColor','none','EdgeColor','k','EraseMode','none');

% plot unicycle final configuration

x=configuration.signals.values(:,1);
y=configuration.signals.values(:,2);
theta=configuration.signals.values(:,3);
x_f=x(length(x));
y_f=y(length(x));
theta_f=theta(length(x));

M=[cos(theta_f) -sin(theta_f) x_f; sin(theta_f) cos(theta_f)  y_f;0 0 1];
vertices_unicycle_shape_f=(M*vertices_unicycle_shape)';
vertices_unicycle_shape_f=vertices_unicycle_shape_f(:,1:2);
patch('Faces',faces_unicycle_shape,'Vertices',vertices_unicycle_shape_f,...
    'FaceColor','none','EdgeColor','k','EraseMode','none');

% plot trajectory

plot(x,y,'k')

xlabel('[cm]');ylabel('[cm]');
ang=0:0.01:2*pi;

for i = 1:n_obst 
   xp = radiusObst(i)*cos(ang);
   yp = radiusObst(i)*sin(ang);
   plot(xcObst(i)+xp,ycObst(i)+yp);
end

% QUI

%{
% plot velocity inputs

figure(2);
%subplot(4,2,1); hold on;
subplot(2,1,1); hold on;
plot(t,v,'k')
set(gca,'fontname','Times','fontsize',12,'fontweight','normal');
ylabel('[m/s]');
xlabel('[s]');
title('driving velocity')
box on;
range=axis;
incr=0.05;
range(4)=range(4)+(range(4)-range(3))*incr;
axis(range);

%subplot(4,2,3); hold on;
subplot(2,1,2); hold on;
plot(t,omega,'k')
set(gca,'fontname','Times','fontsize',12,'fontweight','normal');
ylabel('[rad/s]');
xlabel('[s]');
title('steering velocity')
box on;
range=axis;
incr=0.05;
range(4)=range(4)+(range(4)-range(3))*incr;
axis(range);
%}
