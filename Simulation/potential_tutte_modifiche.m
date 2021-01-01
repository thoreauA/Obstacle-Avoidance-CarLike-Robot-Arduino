function inputs = potential(q)

global b xdFinalPosition ydFinalPosition
global n_obst xcObst ycObst n_0 PsradiusObst
persistent ang a
%global angObst previousPos
% distance after which attractive force changes
ro = 5;
% gains
Ka = 5;
Kb = ro*Ka; 
Kr = 12;
Ktheta = 5;

% configurations
theta = q(3);
qp = [q(1); q(2)];
qg = [xdFinalPosition+b*cos(theta); ydFinalPosition+b*sin(theta)];

% check stop condition
error = 0.05;
if  (qg(1)-error<qp(1)) && (qp(1)<qg(1)+error)
    if (qg(2)-error<qp(2)) && (qp(2)<qg(2)+error)
        qp = qg;
    end
end

% error in position
e = qg-qp;
e_n = norm(e);

% attractive force
if e_n <= ro 
    fa = Ka*e;
elseif e_n > ro
    fa = Kb*(e/e_n);
end

% repulsive force 
gamma = 2;

% obstacles forces
%initialization
fvx_tot = [0];
fvy_tot = [0];
%K_f = 0;
fvx = [0];
fvy = [0];
n_q = [0];
threshold = 0.01;
%displacement = norm([qp(1)-previousPos(1);qp(2)-previousPos(2)]); 

for i = 1:n_obst
    %n_q(i) = norm([qp(1)-(xcObst(i)); qp(2)-(ycObst(i))]);
    %if n_q(i)<n_0(i) && displacement>threshold    
     %   Y=sym(qp(2)-ycObst(i));
      %  X=sym(qp(1)-xcObst(i));
       % angObst(i)=atan2(Y,X);
        %n_q(i) = norm([qp(1)-(xcObst(i)+radiusObst(i)*cos(angObst(i))); qp(2)-(ycObst(i)+radiusObst(i)*sin(angObst(i)))]);  % clearance
        %previousPos = qp;
    %end
    %ang = pi + theta;
    if qp(2)<ycObst(i)-threshold && e_n ~= 0
        ang = -pi/2;
        a=-1;
    elseif qp(2) <= ycObst(i)+threshold && qp(2) >= ycObst(i)-threshold && e_n ~= 0
       if qp(1)<xcObst(i)
            ang=pi;
            a=+1;
       else
            ang=0;
            a=+1;
       end
    elseif qp(2)>ycObst(i)+threshold && e_n ~= 0
         ang=(pi)/2;
         a=+1;
    end
    n_q(i) = norm([qp(1)-(xcObst(i)+PsradiusObst(i)*cos(ang)); qp(2)-(ycObst(i)+PsradiusObst(i)*sin(ang))]);  % clearance
    %n_q(i) = norm([qp(1)-(xcObst(i)); qp(2)-(ycObst(i))]);
    if n_q(i) <= n_0(i) && e_n ~= 0
        K_f = a*(Kr/((n_q(i))^2))*(1/n_q(i) - 1/n_0(i));
        fvx(i) = K_f*( (qp(2) - (ycObst(i)+PsradiusObst(i)*sin(ang)))/ n_q(i));
        fvy(i) = -K_f*( (qp(1) - (xcObst(i)+PsradiusObst(i)*cos(ang)))/ n_q(i));      
    elseif n_q(i) > n_0(i) || e_n == 0
        fvx(i) = 0;
        fvy(i) = 0;
    end
    fvx_tot = fvx_tot + fvx(i);
    fvy_tot = fvy_tot + fvy(i);
end

% total force
fv = [fvx_tot; fvy_tot];
ft = fa + fv;

% force components
fx = ft(1);
fy = ft(2);
fth = Ktheta*(atan2(fy, fx) - q(3));


inputs = [fx; fy; fth; theta];