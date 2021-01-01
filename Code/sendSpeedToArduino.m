%% 
% This function sends velocity input control command to the arduino controller and receives the 
% values of the actual speed of the motors 

function realSpeed = sendSpeedToArduino(u)

    global bt startc startl
    
    stop = 0;
    Ts = 0.4; %+0.03
    TsArd = 0.1;
    itArduino = Ts/(0.1); %MAX_IT = itArduino+1
    
    wrControl = u(1); %input velocities of the controller
    wlControl = u(2);
	
    if((u(1) == 0) && (u(2) == 0))
        stop = 1;
    end
    
    if(startc == 1) % used  for few milliseconds at the beginning of the motion, to avoid too noise  
        stop=1;
        %startc = 0;
    end
    
    signR = sign(wrControl);
    signL = sign(wlControl);

    RPMr = (wrControl/(2*pi))*60;
    RPMl = (wlControl/(2*pi))*60;

    pulseRdes = uint8(round(((RPMr/60)*TsArd*1920)/2 + 128)) ;
    pulseLdes = uint8(round(((RPMl/60)*TsArd*1920)/2 + 128)) ;

    write(bt,[pulseLdes pulseRdes],"uint8");

    while(bt.NumBytesAvailable < 3)
    end

    pulseLreal = (read(bt,1,"uint8"));
    signL = (read(bt,1,"uint8"));
    pulseRreal = (read(bt,1,"uint8"));
    signR = (read(bt,1,"uint8"));
    %realwL = signL*((pulseLreal/(Ts*1920))*6.28);
    %realwR = signR*((pulseRreal/(Ts*1920))*6.28);

    if(signL == 0)
        signL=-1;
    end
    
    if(signR == 0)
        signR=-1;
    end
   
    deltaPhiL = signL*((pulseLreal*itArduino)/1920)*2*pi;
    deltaPhiR = signR*((pulseRreal*itArduino)/1920)*2*pi;
    
    %disp(deltaPhiR);
    %disp(deltaPhiL);
    
    if(startl)
        deltaPhiR = 0;
        deltaPhiL = 0;
        startl = 0;
    end
    
realSpeed = [deltaPhiR; deltaPhiL; stop];
