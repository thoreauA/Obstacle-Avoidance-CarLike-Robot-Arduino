%% 
% Localization of the car through Runge-Kutta integration

function conf = localization(u)

	global previousPos radius distc

	x_k0 = previousPos(1);
	y_k0 = previousPos(2);
	theta_k0 = previousPos(3);
	%{
	disp(x_k0);
	disp(y_k0);
	disp(theta_k0);
	%}
	deltaPhiR = u(1);
	deltaPhiL = u(2);

	DeltaS = (radius/2)*(deltaPhiR + deltaPhiL);
	DeltaTh = (radius/(distc*2))*(deltaPhiR - deltaPhiL);

	if(u(3) == 1)
	    DeltaTh = 0;
	end

	%{
	% Euler integration
	x_k1 = x_k0 + cos(theta_k0)*DeltaS;
	y_k1 = y_k0 + sin(theta_k0)*DeltaS;
	theta_k1 = theta_k0 + DeltaTh;
	%}
	% Runge-Kutta integration
	x_k1 = x_k0 + DeltaS*cos(theta_k0+(DeltaTh/2));
	y_k1 = y_k0 + DeltaS*sin(theta_k0+(DeltaTh/2));
	theta_k1 = theta_k0 + DeltaTh;


	%{
	disp(x_k1);
	disp(y_k1);
	disp(theta_k1);
	%}
	previousPos(1) = x_k1;
	previousPos(2) = y_k1;
	previousPos(3) = theta_k1; 

conf = [x_k1; y_k1; theta_k1];