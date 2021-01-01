#include <AFMotor.h>
#include <PinChangeInt.h>
#include <PID_v1.h>

AF_DCMotor motorSXB(1);//, MOTOR12_1KHZ);
AF_DCMotor motorDXB(2);//, MOTOR12_1KHZ);
AF_DCMotor motorDXF(3);
AF_DCMotor motorSXF(4);

//ENCODERS
// motore 1
const byte Pin1NormToIntA = A2; // interrupt
const byte encoder1pinB = A3; // digital pin
// motore 2
const byte Pin2NormToIntA = A0; // interrupt
const byte encoder2pinB = A1; // digital pin
//motore 3
const byte Pin3NormToIntA = 10; // normal pin to interrupt
const byte encoder3pinB = 13; // digital pin
// motore 4
const byte encoder4pinA = 2; // interrupt
const byte encoder4pinB = 9; // digital pin
byte encoder1PinALast;
byte encoder2PinALast;
byte encoder3PinALast;
byte encoder4PinALast;
int duration1; //the number of the pulses
boolean Direction1; //the rotation direction
int duration2; //the number of the pulses
boolean Direction2; //the rotation direction
int duration3; //the number of the pulses
boolean Direction3; //the rotation direction
int duration4; //the number of the pulses
boolean Direction4; //the rotation direction

// PID
boolean result1;
boolean result2;
boolean result3;
boolean result4;
double abs_duration1, abs_duration2, abs_duration3, abs_duration4;
double SetpointL, SetpointR;
double Kp=0.6, Ki=5, Kd=0;
//motore 1
double val_output1; //Power supplied to the motor PWM value.
PID PID1(&abs_duration1, &val_output1, &SetpointL, Kp, Ki, Kd, DIRECT);
//motore 2
double val_output2; //Power supplied to the motor PWM value.
PID PID2(&abs_duration2, &val_output2, &SetpointR, Kp, Ki, Kd, DIRECT);
//motore 3
double val_output3; //Power supplied to the motor PWM value.
PID PID3(&abs_duration3, &val_output3, &SetpointR, Kp, Ki, Kd, DIRECT);
//motore 4
double val_output4;//Power supplied to the motor PWM value.
PID PID4(&abs_duration4, &val_output4, &SetpointL, Kp, Ki, Kd, DIRECT);

//counter and write logic
int i = 0;
int j = 0;
int sign3, sign4;
double newcountR = 0;
double newcountL = 0;
double counter3 = 0;
double counter4 = 0;
bool writeMatlabR = false; // write durationR after durationL
bool writeMatlabL = false; 
bool serialAvailable = false; // pulse of second encoder output after first

#define MAX_IT 5  // (MAX_IT-1)*100 = sampling time, 8 ok
int mode[2];

int input[2];
int inputPreOffset[2];

void setup() {
  Serial.begin(115200);
  EncoderInit();
  SetpointR = 0;  //Set the output value of the PID
  SetpointL = 0;  //Set the output value of the PID
  PID1.SetMode(AUTOMATIC);//PID is set to automatic mode
  PID1.SetSampleTime(100);//Set PID sampling frequency is 100ms
  PID2.SetMode(AUTOMATIC);//PID is set to automatic mode
  PID2.SetSampleTime(100);//Set PID sampling frequency is 100ms
  PID3.SetMode(AUTOMATIC);//PID is set to automatic mode
  PID3.SetSampleTime(100);//Set PID sampling frequency is 100ms
  PID4.SetMode(AUTOMATIC);//PID is set to automatic mode
  PID4.SetSampleTime(100);//Set PID sampling frequency is 100ms
}

void loop() {

  if(Serial.available() > 1){

     for(int n=0; n<2; n++){
        inputPreOffset[n] = Serial.read(); // Then: Get them

        if (inputPreOffset[n]<128){
            mode[n]=1; //go BACKWARD
        }
        else if(inputPreOffset[n]>128){
            mode[n]=2; //go FORWARD
        }
        else if (inputPreOffset[n]==128){
          mode[n]=3;
        }

        input[n] = abs((inputPreOffset[n]-128)*2); 
     }
     writeMatlabR = true; // input recieved, output can be calculated
     writeMatlabL = true;
  } 
  SetpointL = input[0];
  SetpointR = input[1];

  switch(mode[0]){
     case 1:
        advanceL();
        break;
     case 2:
        backL();
        break;
     case 3:
        stopL();
        break;
  } 

  abs_duration1=abs(duration1);
  result1=PID1.Compute();//PID conversion is complete and returns 1
  abs_duration4=abs(duration4);
  result4=PID4.Compute();//PID conversion is complete and returns 1  

  switch(mode[1]){
     case 1:
        advanceR();
        break;
     case 2:
        backR();
        break;
     case 3:
        stopR();
        break;
  }  
  
  abs_duration2=abs(duration2);
  result2=PID2.Compute();//PID conversion is complete and returns 1
  abs_duration3=abs(duration3);
  result3=PID3.Compute();//PID conversion is complete and returns 1  
  
  if((result4) && (writeMatlabL) && (j < MAX_IT) ){
    newcountL = counter4+duration4;
    counter4 = newcountL;
    j++;
  }

  if(j == MAX_IT){
    Serial.write(byte(abs(counter4/(MAX_IT-1))));
    Serial.flush();
    if(counter4 <= 0){
      sign4 = 1; 
    }
    if(counter4 > 0){
      sign4 = 0; 
    }
    Serial.write(byte(sign4));
    Serial.flush();
    j = 0;
    writeMatlabL = false;
    serialAvailable = true;
    counter4 = 0;
  }
  
  if (result4){
    duration4 = 0;
  }

  if (result1){
    duration1 = 0;
  }

  if((result3) && (writeMatlabR) && (i < MAX_IT) ){
    newcountR = counter3+duration3;
    counter3 = newcountR;
    i++;
  }

  if((i == MAX_IT) && (serialAvailable)){
    Serial.write(byte(abs(counter3/(MAX_IT-1))));
    Serial.flush();
    if(counter3 >= 0){
      sign3 = 1; 
    }
    if(counter3 < 0){
      sign3 = 0; 
    }
    Serial.write(byte(sign3));
    Serial.flush();
    i = 0;
    writeMatlabR = false;
    serialAvailable = false;
    counter3 = 0;
  }

  if (result3){
    duration3 = 0;
  }
  
  if (result2){
    duration2 = 0;
  }
}

//Functions

void EncoderInit()
{
  Direction1 = true; //default -> Forward
  pinMode(encoder1pinB, INPUT);
  attachPinChangeInterrupt(Pin1NormToIntA, wheelSpeed1, CHANGE);

  Direction2 = true; //default -> Forward
  pinMode(encoder2pinB, INPUT);
  attachPinChangeInterrupt(Pin2NormToIntA, wheelSpeed2, CHANGE);

  Direction3 = true; //default -> Forward
  pinMode(encoder3pinB,INPUT);
  attachPinChangeInterrupt(Pin3NormToIntA, wheelSpeed3, CHANGE);

  Direction4 = true; //default -> Forward
  pinMode(encoder4pinB, INPUT);
  attachInterrupt(digitalPinToInterrupt(encoder4pinA), wheelSpeed4, CHANGE);
}

void wheelSpeed1()
{
  int Lstate = digitalRead(Pin1NormToIntA);
  if((encoder1PinALast == LOW) && Lstate==HIGH)
  {
    int val = digitalRead(encoder1pinB);
    if(val == LOW && Direction1)
    {
      Direction1 = false; //Reverse
    }
    else if(val == HIGH && !Direction1)
    {
      Direction1 = true;  //Forward
    }
  }
  encoder1PinALast = Lstate;

  if(!Direction1)  duration1++;
  else  duration1--;
}

void wheelSpeed2()
{
  int Lstate = digitalRead(Pin2NormToIntA);
  if((encoder2PinALast == LOW) && Lstate==HIGH)
  {
    int val = digitalRead(encoder2pinB);
    if(val == LOW && Direction2)
    {
      Direction2 = false; //Reverse
    }
    else if(val == HIGH && !Direction2)
    {
      Direction2 = true;  //Forward
    }
  }
  encoder2PinALast = Lstate;

  if(!Direction2)  duration2++;
  else  duration2--;
}

void wheelSpeed3()
{
  int Lstate = digitalRead(Pin3NormToIntA);
  if((encoder3PinALast == LOW) && Lstate==HIGH)
  {
    int val = digitalRead(encoder3pinB);
    if(val == LOW && Direction3)
    {
      Direction3 = false; //Reverse
    }
    else if(val == HIGH && !Direction3)
    {
      Direction3 = true;  //Forward
    }
  }
  encoder3PinALast = Lstate;

  if(!Direction3)  duration3++;
  else  duration3--;
}

void wheelSpeed4()
{
  int Lstate = digitalRead(encoder4pinA);
  if((encoder4PinALast == LOW) && Lstate==HIGH)
  {
    int val = digitalRead(encoder4pinB);
    if(val == LOW && Direction4)
    {
      Direction4 = false; //Reverse
    }
    else if(val == HIGH && !Direction4)
    {
      Direction4 = true;  //Forward
    }
  }
  encoder4PinALast = Lstate;

  if(!Direction4)  duration4++;
  else  duration4--;
}
void advanceR()//Motor Forward
{
   motorDXB.setSpeed(val_output2);
   motorDXB.run(FORWARD);
   motorDXF.setSpeed(val_output3);
   motorDXF.run(FORWARD); 
}

void backR()//Motor reverse
{
   motorDXB.setSpeed(val_output2);
   motorDXB.run(BACKWARD);
   motorDXF.setSpeed(val_output3);
   motorDXF.run(BACKWARD);
}

void advanceL()//Motor Forward
{
   motorSXB.setSpeed(val_output1);
   motorSXB.run(FORWARD);
   motorSXF.setSpeed(val_output4);
   motorSXF.run(FORWARD);
}

void backL()//Motor reverse
{ 
   motorSXB.setSpeed(val_output1);
   motorSXB.run(BACKWARD);
   motorSXF.setSpeed(val_output4);
   motorSXF.run(BACKWARD);
}

void stopR()//Motor stops
{
     motorDXF.run(RELEASE);
     motorDXB.run(RELEASE);
}

void stopL()//Motor stops
{
     motorSXF.run(RELEASE);
     motorSXB.run(RELEASE);
}
