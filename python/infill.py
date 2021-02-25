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
    origin      = "G1 X{:.4f} Y{:.4f}".format(x0, y0)
    top_left    = "G1 X{:.4f} Y{:.4f}".format(x0, y0 + height)
    top_right   = "G1 X{:.4f} Y{:.4f}".format(x0 + length, y0 + height)
    bot_right   = "G1 X{:.4f} Y{:.4f}".format(x0 + length, y0)
    bot_left    = origin
    if ccw == 0:
        print(origin   )
        print(top_left )
        print(top_right)
        print(bot_right)
        print(bot_left )
    else:
        print(origin   )
        print(bot_right)
        print(top_right)
        print(top_left )
        print(bot_left )

# drawRect(0,0,3,2,0)
# drawRect(0,0,3,2,1)

# Draws the infill for one passthrough of a hatch
# Assume square hatches where length = height
def drawHatch(x0, y0, length, border, infill, ccw=0):
    # Divide up the inner border into a 6x6 grid   
    inner_length = length - border - border
    voxel = inner_length/6 
    print(voxel)
    if ccw == 0:
        # Draw border
        writePoint(x0, y0)
        writePoint(x0, y0+length)
        writePoint(x0+length, y0+length)
        writePoint(x0+length, y0)
        writePoint(x0+border, y0)
        print("END OF BORDER")
        # Set corner of border
        (x, y) = (x0+border, y0+border)
        print( str((x0+border, y0+border)) )
        writePoint(x0+x,y0+y)
        x_inc = True #Boolean for if x was incremented, starts true
        # print( str((x-(x0+border),y-(y0+border))) )
        # writePoint(x*voxel,y*voxel)
        # Draw infill zig-zag
        for i in range (0, 10):
            if x-(x0+border) == 5 and y-(y0+border) == 0: 
                x+=1
                y+=1
            elif x_inc:
                y+=1
                x_inc = False
            else:
                x+=1
                x_inc = True
            # print( str((x-(x0+border),y-(y0+border))) )
            writePoint(x*voxel,y*voxel)
            (x,y) = (y,x)
            # print( str((x-(x0+border),y-(y0+border))) )
            writePoint(x*voxel,y*voxel)

    print("END OF INFILL")

#Hatch starting from (0,0), Length and width of 5, border width of 1, infill width of 1
drawHatch(0, 0, 5, 1, 1)




    