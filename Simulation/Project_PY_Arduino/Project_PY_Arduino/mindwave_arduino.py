
import mindwave, time
#import matplotlib.pyplot as plt
#import matplotlib.animation as animation
import numpy as np
import serial

BLINK_THRESHOLD = 275
ser = serial.Serial("/dev/rfcomm0",11520) # Establish the connection on a specific port
# Definition time, blink, left and right velocity lists

i = 0
clk = 0
t = list()
blink = list()
att = list()
thres_attention = list()
thres_p_blink = list()
thres_n_blink = list()
#################################### FUNCTION DEFINITION ####################################
#bluetooth.BluetoothSocket(bluetooth.RFCOMM)
def HeadSet_Connect():
    try:
        global headset
        headset = mindwave.Headset("/dev/rfcomm0",'3D86') #'/dev/tty.MindWaveMobile-DevA', '3D86'
        time.sleep(2)
        headset.connect()
        print("Connecting...")

        # Check connection    
        while headset.status != 'connected':
            time.sleep(0.5)
            if headset.status == 'standby':
                headset.connect()
                print ("Retrying connect...")
        print ("Neurosky Mindwave mobile connected!")
        return True
    except:
        print ("No connection with the headset!")
        return False
    
def Filter(list_values,signal):
    if len(list_values) >= 3:
        list_values.pop()
    list_values.append(signal)
    vector = np.asarray(list_values)
    mean = np.mean(vector)
    return mean

def checkBlink(mean):
    if(abs(mean) > BLINK_THRESHOLD):
        return True
    return False

def checkAtt(mean,threshold):
    if(abs(mean) > threshold):
        return True
    return False



def list_update(clk,mean_blink,attention,mean_att):
    # Time update     
    t.append(clk)
    # Blink update
    blink.append(mean_blink)
    # Attention update
    att.append(attention)
    # Threshold attention update
    thres_attention.append(mean_att)
    # Threshold blink update
    thres_p_blink.append(BLINK_THRESHOLD)
    thres_n_blink.append(-BLINK_THRESHOLD)
    
def getAT(attention):
    vector = np.asarray(attention)
    mean = np.mean(vector)
    if (int(mean)+20 > 100):
        return int(mean)
    return int(mean)+20
    
#################################### END FUNCTION DEFINITION ####################################

if(HeadSet_Connect()):
    
    print('Press Enter to Start Simulation\n')


    ## Get initial configuration_________________________________________________
    
    ## Main Loop
    print('Simulation Started')
    values_blink = []
    mean_blink = 0
    
    # Initialization time, blink, left and right velocity lists
    t.append(0)
    blink.append(0)
    att.append(0)
    thres_attention.append(0)
    thres_p_blink.append(BLINK_THRESHOLD)
    thres_n_blink.append(-BLINK_THRESHOLD)
    status = "STOP"
    while True:
        try:
            if(i == 0):
                time.sleep(10)
                i=1
            
            time.sleep(0.05)
            
            ## Raw_value Filter & attention Filter
            mean_blink = Filter(values_blink,headset.raw_value)
            print("\nATTENTION",headset.attention,"THRESHOLD",getAT(att))
            print("BLINK",int(mean_blink),"THRESHOLD",BLINK_THRESHOLD, "\n")
            list_update(clk, mean_blink, headset.attention, getAT(att))
            
            if(checkBlink(mean_blink)):
                print("BLINK DETECTED")
                if(status == "STOP"):
                    print("TURN")
                    status = ("RIGHT")
                    #ser.write('R')
                else:
                    print("STOP")
                    status = "STOP"
                    #ser.write('S')
                time.sleep(0.5)
            elif(checkAtt(headset.attention,getAT(att)) and (status == "STOP")):
                print ("MOVE")
                status = "FORWARD"
                #ser.write('F')
        except:
            print("\n\n..Done!")
            status = "STOP"
            #ser.write('S')
            break
        
    # Reset all wheels Velocity after the simulation
    #ser.write('S')
    
    print('Simulation Finished\n')
 #   PLOT()
else:
    print('Try to restart!')

print('Program ended\n')



