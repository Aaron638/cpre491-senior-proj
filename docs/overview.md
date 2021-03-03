# Understanding C# Code written by previous Senior Design Groups
By Aaron Martin
<hr></hr>

## Overview
![image](https://i.imgur.com/XoYcLUI.png)

Given certain dimensions of an object, the software will generate a set of instructions for the 3D printer in a text file. 

These instructions are decoded into serial instructions for the Velmex Step control motors and the Laser.

Sensors connected to an Arduino provide additional information of the conditions of the 3D printing chamber. Certain temperature, pressure, and oxygen levels must be satisfied before any printing is done.

### CubeGenerator
The software flow starts with the `CubeGenerator.cs` which generates a `.gcode` file. 
`gcode` files have instructions for the motors of the printer. https://en.wikipedia.org/wiki/G-code

- Thickness of layers are set in millimeters. Taking the `height` and `layerThickness` defined by the user, they round to the nearest integer number of layers `numLayers`.
- Every layer is comprised out of a series of squares shaped "Infills".
  - `drawInfillSquare` writes instructions to the `.gcode` file.
  The values use nanometer measurements here
  - Need to get a list of specific criteria from Bigelow on how these infill squares are made. 
  Previous team's documentation may also be helpful.
  - They use custom M functions within the gcode to control the laser:
  ```cs
    // In GCodeParser.cs
    // Custom defined M codes for our 3D printer: 
    // M200: Execute layer change
    // M201: Laser on
    // M202: Laser off
  ```
  - Heres a cool tool that can be used to simulate the path of CNC motors
  https://nraynaud.github.io/webgcode/
    `bigelow1.gcode` looks like this: ![https://i.imgur.com/4UBtV9R.png](https://i.imgur.com/4UBtV9R.png)
    By selecting lines of the G-Code text, you can visualize the alternating pattern that Bigelow mentioned: ![https://i.imgur.com/P0c9kMD.gif](https://i.imgur.com/P0c9kMD.gif)

The goal here would be to make a Matlab script that prints the gcode file. We'll also have to check if certain dimensions or instructions are even valid.

Ideally we would also want to create some tool that converts a `.stl` into a valid `.gcode` file for our printer.

From what I see they implement a C# application using this library to read `.stl` files: https://github.com/QuantumConcepts/STLdotNET

### PrinterControl
From what I understand, `GCodeParser.cs` is the closest thing to a "Main() function" within this mishmash of object obfuscation. A student added a lot of comments here documenting what it does step by step, so see the file if you want to know more.

PrinterControl has a running list of `PrinterAction` objects. There are 5 possible actions for controlling the motor and laser:
```cs
  // In PrinterAction.cs
  // Each possible action for the printer motor is assigned a specific integer
  public const int ACTION_TYPE_VELMEX_MOVE = 1;
  public const int ACTION_TYPE_LASER_ON = 2;
  public const int ACTION_TYPE_LASER_OFF = 3;
  public const int ACTION_TYPE_LAYER_CHANGE = 4;
  public const int ACTION_TYPE_LAYER_CHANGE_2 = 5;
```
I don't really understand why it has to be an object here, but Each action in the list has a `string` for sending to the Velmex motor controllers. See the Velmex motor controller docs for more.

Theres still more to write about here but I need to take some time to read more of the comments.

Converting this, or writing it from scratch will be the main task for those assigned to this part of the project.

### Sensor_System
- Sensor_System.ino controls the Arduino, currently the libraries it refers to need to be downloaded
  -  In the Cybox folder, theres an excel file describing pins along with some other documentation
  - ![https://i.imgur.com/InB445V.png](https://i.imgur.com/InB445V.png)
  - [HP20x_dev.h for controlling Barometer](https://github.com/Seeed-Studio/Grove_Barometer_HP20x/blob/master/HP20x_dev.h)
  - Arduino.h Standard Library for Arduinos
  - [Wire.h for communicating with I2C devices connected to the Arduino](https://www.arduino.cc/en/Reference/Wire)
  - [KalmanFilter.h](https://en.wikipedia.org/wiki/Kalman_filter)

The goal here would be to have the Arduino interface with the motor controllers through some Matlab script. 

If any environmental conditions aren't met, we need to be able to stop the motors, so this program probably has to run **asynchronously**, independent of the sequential steps executed by our "main" function.

### Glossary:

- `.stl`
  - CAD File from Solidworks or other
- `.gcode`
  - Instructions for CNC motors, tells the motors where to move the laser
- `.cs`
  - C# code
- `.m`
  - Matlab Script or Function File
- I2C
- ADC
- [infill](https://3dprinting.com/tips-tricks/how-to-choose-an-infill-for-your-3d-prints/)
- RS-232


