function inputs = potential(q)

global xdFinalPosition ydFinalPosition radius distc
global n_obst xcObst ycObst n_0 radiusObst startc startl

% distance after which attractive force changes
ro = 1; %1
% gains
Ka = 10; %10
Kb = ro*Ka; 
Kr = 60000; %60000
Ktheta = 5; %5

% configurations
theta = q(3);
qp = [q(1); q(2)];
qg = [xdFinalPosition; ydFinalPosition];

% check stop condition
error = 10;
if  (qg(1)-error<qp(1)) && (qp(1)<qg(1)+error)
    if (qg(2)-error<qp(2)) && (qp(2)<qg(2)+error)
        qp = qg;
    end
end

% error in position
e = qg-qp;
e_n = norm(e);

% repulsive force 

% obstacles forces
%initialization
fvx_tot = [0];
fvy_tot = [0];
fvx = [0];
fvy = [0];
n_q = [0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:n_obst
    qCloserObst = [xcObst(i); ycObst(i)]+((qp-[xcObst(i); ycObst(i)])/norm(qp-[xcObst(i); ycObst(i)]) )*radiusObst(i);
    n_q(i) = norm(qp-qCloserObst);
    if n_q(i) <= n_0(i) && e_n ~= 0
        K_f = (Kr/(n_q(i))^2)*(1/(n_q(i)) - 1/n_0(i));
        fvx(i) = K_f*( (qp(2)-qCloserObst(2))/(n_q(i)) );
        fvy(i) = -K_f*( (qp(1)-qCloserObst(1))/(n_q(i)) );    
    elseif n_q(i) > n_0(i) || e_n == 0
        fvx(i) = 0;
        fvy(i) = 0;
    end
    fvx_tot = fvx_tot + fvx(i);
    fvy_tot = fvy_tot + fvy(i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% total force
fv = [fvx_tot; fvy_tot];

% attractive force
if e_n <= ro 
    fa = Ka*e;
elseif e_n > ro
    fa = Kb*(e/e_n);
end


ft = fa + fv;
% force components
fx = ft(1);
fy = ft(2);
fth = Ktheta*(atan2(fy, fx) - q(3));

v = fx*cos(theta)+fy*sin(theta);
omega = fth;

wR = (v/radius)+(distc/(2*radius))*omega;
wL = (v/radius)-(distc/(2*radius))*omega;

maxvel=5.8;
if (wR > maxvel) 
    wR=maxvel;
end

if (wR < -maxvel)
    wR=-maxvel;
end

if (wL > maxvel) 
    wL=maxvel;
end

if (wL < -maxvel)
    wL=-maxvel;
end

if (wR > 0 && wR < 1) 
    wR=1;
end

if (wR < 0 && wR > -1)
    wR=-1;
end


if (wL > 0 && wL < 1) 
    wL = 1;
end

if (wL < 0 && wL > -1)
    wL = -1;
end

if(startc == 1)
        wR = 3;
        wL = 3;
        startl = 1;
        startc = 0;
end

if  (qg(1)-error<qp(1)) && (qp(1)<qg(1)+error)
    if (qg(2)-error<qp(2)) && (qp(2)<qg(2)+error)
        wR=0;
        wL=0;
        sendSpeedToArduino([0 0]);
    end
end

inputs = [wR; wL];