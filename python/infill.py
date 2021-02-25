# import pint
# Pint Library used for units: https://pint.readthedocs.io/en/stable/

# This file contains functions needed to draw an infill

# Prints the gcode needed to go to point (x0,y0)
def writePoint(x0, y0):
    start = "G1 X{:.4f} Y{:.4f}".format(x0, y0)
    print(start)

# draw_line(0,0,1,1)
# test_tuple = (5, 6)
# writePoint(*test_tuple)

# Prints the gcode needed to make a rectangle
# Given origin (x0,y0), length, width, and 0 if clockwise, and 1 if counter-clockwise.
# The origin is at the bottom left of the rectangle

def drawRect(x0, y0, length, height, ccw):
    origin = "G1 X{:.4f} Y{:.4f}".format(x0, y0)
    top_left = "G1 X{:.4f} Y{:.4f}".format(x0, y0 + height)
    top_right = "G1 X{:.4f} Y{:.4f}".format(x0 + length, y0 + height)
    bot_right = "G1 X{:.4f} Y{:.4f}".format(x0 + length, y0)
    bot_left = origin
    if ccw == 0:
        print(origin)
        print(top_left)
        print(top_right)
        print(bot_right)
        print(bot_left)
    else:
        print(origin)
        print(bot_right)
        print(top_right)
        print(top_left)
        print(bot_left)

# drawRect(0,0,3,2,0)
# drawRect(0,0,3,2,1)

# Draws the infill for one passthrough of a hatch
# Assume square hatches where length = height
# TODO Modify to have configurable # of voxels

def drawHatch(x0, y0, length, border, ccw=0):
    # Divide up the inner border into a 6x6 grid
    inner = length - border - border
    voxel = inner/6
    if ccw == 0:

        # Draw border
        writePoint(x0, y0)
        writePoint(x0, y0+length)
        writePoint(x0+length, y0+length)
        writePoint(x0+length, y0)
        writePoint(x0+border, y0)
        print("END OF BORDER")

        # 0,0 is the border bottom left
        (x, y) = (0, 0)
        writePoint(x0+border+(x*voxel), y0+border+(y*voxel))
        
        # Draw infill zig-zag
        incr_y = True # Do we increment y or x?
        while not (x == 5 and y == 6):
            if x == 5 and y == 0:
                x += 1
                y += 1
            elif incr_y:
                y += 1
                incr_y = False
            else:
                x += 1
                incr_y = True
            
            writePoint(x0+border+(x*voxel), y0+border+(y*voxel))
            (x, y) = (y, x) # Swap
            writePoint(x0+border+(x*voxel), y0+border+(y*voxel))
        
        x += 1
        writePoint(x0+border+(x*voxel), y0+border+(y*voxel))
    if ccw == 1:

        # Draw border
        writePoint(x0, y0)
        writePoint(x0+length, y0)
        writePoint(x0+length, y0+length)
        writePoint(x0+border, y0+length)
        print("END OF BORDER")

        # 0,6 is the border top left
        (x, y) = (0, 6)
        # print( str((x, y)) )
        writePoint(x0+border+(x*voxel), y0+border+(y*voxel))

        # Draw infill zig-zag
        decr_y = True # Do we decrement y or increment x?
        while not (x == 5 and y == 0):
            if x == 5 and y == 6:
                (x, y) = (y, x) # Swap
            elif decr_y:
                y -= 1
                decr_y = False
            else:
                x += 1
                decr_y = True
            # print( str((x, y)) )
            writePoint(x0+border+(x*voxel), y0+border+(y*voxel))
            x = 6-x
            y = 6-y
            (x, y) = (y, x) # Swap
            # print( str((x, y)) )
            writePoint(x0+border+(x*voxel), y0+border+(y*voxel))
        x += 1
        # print( str((x, y)) )
        writePoint(x0+border+(x*voxel), y0+border+(y*voxel))

    print("END OF INFILL")

# Hatch starting from (0,0), Length and width of 5, border width of 0.5
# drawHatch(x0=0, y0=0, length=5, border=0.5)
drawHatch(x0=0, y0=0, length=5, border=0.5, ccw=1)