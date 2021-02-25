# Infill algorithms for 3D Powderbed Metal Printer
by Aaron Martin

## Overview
Previous senior design groups provided us with various `.gcode` files to work with. 
This website: https://nraynaud.github.io/webgcode/ lets us visualize where the motors are moving the laser step by step.

`GCodeParser.cs` shows us that they used 3 custom defined `M` codes:
```c
// Custom defined M codes for our 3D printer: 
// M200: Execute layer change
// M201: Laser on
// M202: Laser off
```
The other gcode type they use is the `G1` code, which tells the motors to move the laser at a constant velocity to the coordinates. 

For example, this `.gcode` starts the laser at (0,0), turns it on, draws a line to (0,1), then turns it off.
```gcode
G1 X0.0000 Y0.0000
M201
G1 X0.0000 Y1.0000
M202
```

Looking at `testing3.gcode`, we can generalize the functionality like so:
1. Draw the border of the object
2. Draw a hatch
    a. Draw the border (**clockwise**)
    b. Draw a "zig-zag" pattern from **bottom-left** to **top-right** of the infill box.
3. Draw the adjacent hatch to the right
    a. Draw the border (**counter-clockwise**)
    b. Draw a "zig-zag" pattern from **top-left** to **bottom-right** of the infill box.
4. Alternate between steps 2 and 3 until the whole border is filled.
5. Do another passthrough, but this time using the opposite directions
6. Re-draw the hatch in the opposite direction
    a. Draw the border (**counter-clockwise**)
    b. Draw a "zig-zag" pattern from **top-left** to **bottom-right** of the infill box.
7. Re-draw an adjacent hatch in the opposite direction
    a. Draw the border (**clockwise**)
    b. Draw a "zig-zag" pattern from **bottom-left** to **top-right** of the infill box.
8. Increment the layer by 0.1 units, and repeat steps 1 through 7

Because it just repeats the same instructions, the file effectively ends at line 504.

## 

Lines 4 through 8 draw the border of the object we're trying to create
```gcode
G1 X-0.1000 Y-0.1000
G1 X-0.1000 Y3.3000
G1 X3.3000 Y3.3000
G1 X3.3000 Y-0.1000
G1 X-0.1000 Y-0.1000
```

https://wiki.evilmadscientist.com/Creating_filled_regions