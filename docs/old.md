# A Quick Rundown of the Powder Bed Metal Printer C# Code
By Aaron Martin

Written near the start of Spring 2021.
<hr></hr>

## Overview
  The primary goal of this project is to print stainless steel cubes in our custom powder bed system.  Prior groups have done a lot of the work, but the software needs to be reworked and the control of the melt laser needs to beincorporated.  Being able to print any 3D object would be a secondary goal.

![image](https://i.imgur.com/XoYcLUI.png)

Given certain dimensions of an object, `CubeGenerator` will generate a set of instructions for the 3D printer in a `gcode` file. 

`PrinterControl` decodes the `gcode` file into commands that are sent to the Velmex Step control motors and the Laser.

`Sensors` connected to an Arduino provide additional information of the conditions of the 3D printing chamber. Certain temperature, pressure, and oxygen levels must be satisfied before any printing is done.


### CubeGenerator
The entire software flow starts with the `CubeGenerator.cs` which generates a `.gcode` file. 

- From what I understand, their C# application uses this library to read `.stl` files: https://github.com/QuantumConcepts/STLdotNET

- Heres a useful tool that can read gcode and draw the path: https://nraynaud.github.io/webgcode/
  
  - `bigelow1.gcode` looks like this: 
    ![https://i.imgur.com/4UBtV9R.png](https://i.imgur.com/4UBtV9R.png)

  - By selecting lines of the G-Code text, you can visualize the path that the laser will take:   
    ![https://i.imgur.com/P0c9kMD.gif](https://i.imgur.com/P0c9kMD.gif)

- Thickness of layers are set in millimeters. Taking in the `height` and `layerThickness` parameters set by the user, they round to the nearest integer number of layers `numLayers`.

- Every layer needs a supportive structure called an **infill**. 
  
  - The infills are split up into square-shaped **voxels**.

  - Note that the previous groups used a diagonal raster scans like the one on the right, but Dr. Bigelow has asked us to do a horizontal raster scan instead:
    ![https://i.imgur.com/kAlSHld.png](https://i.imgur.com/kAlSHld.png)

  - When drawing and filling in voxels, their orientation needs to alternate in a checkerboard-like pattern. (Need more details on this)
  
- `drawInfillSquare` writes instructions to the `.gcode` file.
  The values use nanometer measurements here (I think).

  - The first line always describes the width and height of the object to be drawn: `Width: {w} Height: {h}`

  - G1 tells the motor to move at a constant speed to the given (x,y) coordinates: `G1 X:{x} Y:{y}`
  
  - They define custom M functions within the gcode to control the laser:
  ```cs
    // In GCodeParser.cs
    // Custom defined M codes for our 3D printer: 
    // M200: Execute layer change
    // M201: Laser on
    // M202: Laser off
  ```


### PrinterControl
The goal of this file is to read in the `.gcode` file, and map each line to a series of actions that the printer has to do.

`GCodeParser.cs` acts like a ["god object,"](https://en.wikipedia.org/wiki/God_object) because it ends up doing way too much: 
- Initializes the printer's home position given a length and width.
- Parses a line of `gcode` and extracts the relevant data
- Handles the control flow of what action to do per line of `gcode`
- Does the math for converting the nanometers into motor steps
- It writes the string to be sent through the COM ports connecting the VXM motor controllers

The `PrinterAction` object is used for adding strings to the queue of instructions to send through the COM ports. There are 5 possible actions for controlling the motors and laser:
```cs
  // In PrinterAction.cs
  // Each possible action for the printer motor is assigned a specific integer
  public const int ACTION_TYPE_VELMEX_MOVE = 1;
  public const int ACTION_TYPE_LASER_ON = 2;
  public const int ACTION_TYPE_LASER_OFF = 3;
  public const int ACTION_TYPE_LAYER_CHANGE = 4;
  public const int ACTION_TYPE_LAYER_CHANGE_2 = 5;
```

`GcodeParser.xaml.cs` defines a UI window component for gcode parsing, as well as conducting a write to the COM ports with the strings of printer actions.

`PrinterControl` pretty much performs all of the crucial actions of the printer, but it gets very hard to follow the logic and structure if you don't understand C# project layouts like me.

A student added a lot of comments here documenting what it all does, so I strongly suggest you dig into the source code if you need to know more.


### Sensor_System
The Sensor_System controls the temperature, pressure, and oxygen sensors that go inside of the printing chamber. They are interfaced with using an Arduino which is connected to the PC running the C# application. 

If any environmental conditions aren't met, we need to be able to stop the motors, so this program probably has to run **asynchronously**, independent of the sequential steps executed by our "main" function.

The version of their codebase we have access to seems to be missing a lot, as it only comprises of one file: `Sensor_System.ino`.

  - The headers of the file hint at various libraries that are necessary for interacting with the sensors.
    ![https://i.imgur.com/InB445V.png](https://i.imgur.com/InB445V.png)
    - [HP20x_dev.h for controlling Barometer](https://github.com/Seeed-Studio/Grove_Barometer_HP20x/blob/master/HP20x_dev.h)
    - Arduino.h Standard Library for Arduinos (I think)
    - [Wire.h for communicating with I2C devices connected to the Arduino](https://www.arduino.cc/en/Reference/Wire)
    - [KalmanFilter.h](https://en.wikipedia.org/wiki/Kalman_filter)

In the Cybox folder, theres an excel file describing pins along with some other documentation. If your goal is to try to reverse engineer this, maybe check that, however theres so little there that you might be better off re-writing it all from scratch, and reading the sensor and arduino documentation instead.


### File Types:

- `.stl`
  - CAD File which represents a 3D object
- `.gcode`
  - Instructions for CNC motors, tells the motors where to move the laser
- `.cs`
  - C# code
- `.m`
  - Matlab Script or Function File
- `.xaml.cs`
  - C# Code for creating a UI