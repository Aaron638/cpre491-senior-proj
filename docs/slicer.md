# Slicer Program Documentation

## Overview:
An infill is a series of interior walls for maintaining the structure of the object while it gets printed layer by layer.

A Slicer program usually translates a 3D model into G-Code instructions, but because our 3D printer has some unique criteria and constraints, we must write our own.

Previous senior design groups provided us with various `.gcode` files to work with, but they all use diagonal scanlines, while Dr. Bigelow has asked us to do rasterization:

![Raster vs Diagonal](https://ars.els-cdn.com/content/image/1-s2.0-S2238785419301905-gr2.jpg)

This website: https://nraynaud.github.io/webgcode/ lets us visualize where the motors are moving the laser step by step.

`GCodeParser.cs` shows us that they used 3 custom defined `M` codes:
```c
// Custom defined M codes for our 3D printer: 
// M200: Execute layer change
// M201: Laser on
// M202: Laser off
```
The primary gcode type they use is the `G1` code, which tells the motors to move the laser at a constant velocity to the coordinates. 

For example, this `.gcode` starts the laser at (0,0), turns it on, draws a line to (0,1), then turns it off.

```gcode
    G1 X0.0000 Y0.0000
    M201
    G1 X0.0000 Y1.0000
    M202
```

## Reference:
https://www.sciencedirect.com/science/article/pii/S2238785419301905
https://all3dp.com/2/infill-3d-printing-what-it-means-and-how-to-use-it/
https://wiki.evilmadscientist.com/Creating_filled_regions