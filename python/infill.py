# import pint
# Pint Library used for units: https://pint.readthedocs.io/en/stable/

# This file contains functions needed to draw an infill

# Prints the gcode needed to go from point (x0,y0) to (x1,y1)
def draw_line(x0, y0, x1, y1):
    start   = "G1 X{:.4f} Y{:.4f}".format(x0, y0)
    end     = "G1 X{:.4f} Y{:.4f}".format(x1, y1)
    print(start)
    print(end)

# draw_line(0,0,1,1)

# Prints the gcode needed to make a rectangle starting at the given origin (x0,y0)
# The origin is at the bottom left of the rectangle, draws 4 lines clockwise
def draw_rect(x0, y0, length, height):
    origin      = "G1 X{:.4f} Y{:.4f}".format(x0, y0)
    top_left    = "G1 X{:.4f} Y{:.4f}".format(x0, y0 + height)
    top_right   = "G1 X{:.4f} Y{:.4f}".format(x0 + length, y0 + height)
    bot_right   = "G1 X{:.4f} Y{:.4f}".format(x0 + length, y0)
    bot_left    = origin

    print(origin   )
    print(top_left )
    print(top_right)
    print(bot_right)
    print(bot_left )

# draw_rect(0,0,1,1)
# draw_rect(0,0,6,4)

# def 

    