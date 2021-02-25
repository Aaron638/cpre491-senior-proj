# Slicer Program Documentation
by Aaron Martin

## Overview:
An infill is a series of interior walls for maintaining the structure of the object while it gets printed layer by layer.

![testing3.gcode](https://i.imgur.com/bpDdsWT.png)

A Slicer program usually translates a 3D model into G-Code instructions, but because our 3D printer has some unique criteria and constraints, we must write our own.

Previous senior design groups provided us with various `.gcode` files to work with. 
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
### Algorithm:

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

Because it just repeats the same instructions per-layer, the file effectively ends at line 504.

### TODO:
- Add Units
- Convert to MATLAB or have MATLAB call Python script
- Adjustable laser scan line spacing
- Adjustable Voxel count per hatch
- Other Infill patterns?
- Random Defect Function(s)

## Code:

### `infill.py`

I wrote this in Python 3 for now while I learn MATLAB. The plan is to either have MATLAB [call these scripts.](https://www.mathworks.com/help/matlab/call-python-libraries.html) 
If Dr. Bigelow prefers, we can re-write it in MATLAB later.

#### drawHatch()
drawHatch draws a square hatch infill

Parameters:

    (x0, y0): The coordinates for the relative origin at the bottom left of the hatch
    length: The hatch length 
    border: The thickness of the border
    ccw: 0 if the border is drawn clockwise, 1 if counter-clockwise

    TODO voxels: Need to look at the math involved

First we draw the clockwise border, and do the zig-zag pattern:
![cw_hatch](https://i.imgur.com/DogUVEl.png)

Adjacent hatches are drawn counter-clockwise, with a zig-zag in the opposite direction:
![ccw_hatch](https://i.imgur.com/Da4VOCt.png)

When the patterns are overlayed on top of eachother, we see the voxels:
![hatch_image](https://i.imgur.com/TBK2ZRm.png)

Say we set the corner of the internal border to be (0,0), the coordinates would look like so:
| CW |   | CCW |   | Line# |
|:--:|:-:|:---:|:-:|-------|
| x  | y | x   | y |       |
| 0  | 0 | 0   | 6 | 1     |
| 0  | 1 | 0   | 5 | 2     |
| 1  | 0 | 1   | 6 | 3     |
| 2  | 0 | 2   | 6 | 4     |
| 0  | 2 | 0   | 4 | 5     |
| 0  | 3 | 0   | 3 | 6     |
| 3  | 0 | 3   | 6 | 7     |
| 4  | 0 | 4   | 6 | 8     |
| 0  | 4 | 0   | 2 | 9     |
| 0  | 5 | 0   | 1 | 10    |
| 5  | 0 | 5   | 6 | 11    |
| 6  | 1 | 6   | 5 | 12    |
| 1  | 6 | 1   | 0 | 13    |
| 2  | 6 | 2   | 0 | 14    |
| 6  | 2 | 6   | 4 | 15    |
| 6  | 3 | 6   | 3 | 16    |
| 3  | 6 | 3   | 0 | 17    |
| 4  | 6 | 4   | 0 | 18    |
| 6  | 4 | 6   | 2 | 19    |
| 6  | 5 | 6   | 1 | 20    |
| 5  | 6 | 5   | 0 | 21    |
| 6  | 6 | 6   | 0 | 22    |


## Reference:
https://all3dp.com/2/infill-3d-printing-what-it-means-and-how-to-use-it/
https://wiki.evilmadscientist.com/Creating_filled_regions