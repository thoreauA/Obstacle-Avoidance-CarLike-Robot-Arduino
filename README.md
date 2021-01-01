# Obstacle-Avoidance-CarLike-Robot
Simulation and implementation of an Autonomous Differential Drive robot which follows automatically an online computed reference in a known site with known fixed 
obstacles by only receiving as external input the desired position in terms of x and y coordinates.

## CarLike robot

The implementation is done by using the following main components:
1. Arduino Uno microcontroller;
2. Ada-fruit Motor Shield;
3. Four motors each of which has an incremental encoder;
4. HC-06 Arduino Bluetooth module for communications;

<img src="https://github.com/thoreauA/Obstacle-Avoidance-CarLike-Robot/raw/main/carFigure.png" width="500" height="350">

The robot used has 4 actuated motors as in a Car-like model, but there is no possibility to turn the wheels to obtain a steering
angle so the robot has been modeled as a Differential Drive mobile robot.

## Motion planning

The car able to decide the path to follow, once it has information about the workspace.
The method which will be described and used is the so called artificial potential field, which is suitable for online
motion planning in the case of known workspace with known fixed obstacles.
The forces created by defined artificial potential fields are used as generalized velocities. Then the postiion of the car is estimated
using a Runge-Kutta method and again the forces are calculated based on the position reached.

## Usage

### Simulations
In the directory **Simulations**, it is available a simulation in Simulink of the controlled system. To use it in Matlab:

```
  open_system('diff_drive_pot_fields_sim')
  In the simulation: 
    Double click on Initialization
    Run the simulation
    Double click on Plot
```
### Real implementation
For the real implementation Arduino and Matlab are used. All the codes are in the directory **Code**. First the code `carRobot.ino` 
has to be uploaded on the Arduino microcontroller. Then after having established a bluetooth communication channel between the
computer and the car, run on Matlab the codes in the following order:

```
   init.m
   startRunning.m
```
Video examples:

[![Video car robot avoiding obstacles]()](https://github.com/thoreauA/Obstacle-Avoidance-CarLike-Robot/raw/main/videos/videoOstacoli.mp4)

[![Video car robot w/o obstacles]()](hhttps://github.com/thoreauA/Obstacle-Avoidance-CarLike-Robot/raw/main/videos/videoSenzaOst.mp4)

**Arduino libraries used** 

- AFMotor.h
- PinChangeInt.h
- PID_v1.h
