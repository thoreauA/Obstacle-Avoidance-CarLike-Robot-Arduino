%% 
% This script starts the motion of the car

global wR wL

tic 

a = [0 0 0];

while ((wR~=0 && wL~=0))
    b = localization(a)
    w = potential (b);
    wR = w(1)
    wL = w(2)
    if(toc>30)
        wR=0;
        wL=0;
        sendSpeedToArduino([wR wL]);
    end
     a = sendSpeedToArduino([wR wL])
end
