//*** 1- Documentation
//This program is used to control a robot car using a app that communicates with Arduino trough a bluetooth module

#include <AFMotor.h>

//creates two objects to control the terminal 3 and 4 of motor shield 
AF_DCMotor motor1(3);  //avanti dx
AF_DCMotor motor2(4);  //avanti sx
AF_DCMotor motor3(2);  //dietro dx
AF_DCMotor motor4(1);  //dietro sx

char x; 

void setup() 
{       
  Serial.begin(115200);  //Set the baud rate to your Bluetooth module.
}

void loop(){
  if(Serial.available() > 0){ 
    x = Serial.read(); 
    Stop(); //initialize with motors stoped
    //Change pin mode only if new command is different from previous.   
    Serial.println(x);
    switch(x){
    case 'F':  
      forward();
      break;
    case 'B':  
       back();
      break;
    case 'L':  
      left();
      break;
    case 'R':
      right();
      break;
    case 'S':
      Stop();
      break;
    }
  } 
}

void forward()
{
  motor1.setSpeed(150); //Define maximum velocity
  motor1.run(FORWARD); //rotate the motor clockwise
  motor2.setSpeed(150); //Define maximum velocity
  motor2.run(FORWARD);//rotate the motor clockwise
  motor3.setSpeed(150); //Define maximum velocity
  motor3.run(FORWARD);
  motor4.setSpeed(150); //Define maximum velocity
  motor4.run(FORWARD);
}

void back()
{
  motor1.setSpeed(150); 
  motor1.run(BACKWARD); //rotate the motor counterclockwise
  motor2.setSpeed(150); 
  motor2.run(BACKWARD); //rotate the motor counterclockwise
  motor3.setSpeed(150); 
  motor3.run(BACKWARD);
  motor4.setSpeed(150); 
  motor4.run(BACKWARD);
}

void left()
{
  motor1.setSpeed(150); //Define maximum velocity
  motor1.run(FORWARD); //rotate the motor clockwise
  motor2.setSpeed(150);
  motor2.run(BACKWARD); //turn motor2 off
  motor3.setSpeed(150); //Define maximum velocity
  motor3.run(FORWARD); //rotate the motor clockwise
  motor4.setSpeed(150);
  motor4.run(BACKWARD);
  
}

void right()
{
  motor1.setSpeed(150);
  motor1.run(BACKWARD); //turn motor1 off
  motor2.setSpeed(150); //Define maximum velocity
  motor2.run(FORWARD); //rotate the motor clockwise
  motor3.setSpeed(150);
  motor3.run(BACKWARD); //turn motor1 off
  motor4.setSpeed(150); //Define maximum velocity
  motor4.run(FORWARD);
}

void Stop()
{
  motor1.setSpeed(0);
  motor2.run(RELEASE); //turn motor1 off
  motor2.setSpeed(0);
  motor2.run(RELEASE); //turn motor2 off
  motor3.setSpeed(0);
  motor3.run(RELEASE); //turn motor1 off
  motor4.setSpeed(0);
  motor4.run(RELEASE);
}

/*
char x;   // for incoming serial data

void setup() {
        Serial.begin(115200);     // opens serial port, sets data rate to 9600 bps
}

void loop() {

        // send data only when you receive data:
        if (Serial.available() > 0) {
                // read the incoming byte:
                x = Serial.read();

                // say what you got:
                Serial.print(x);       // print as an ASCII-encoded decimal - same as "DEC"
        }
}*/
