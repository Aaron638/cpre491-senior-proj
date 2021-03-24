function [gcode] = gen_voxel_90_degrees(x_origin, y_origin, length, width, height, has_defect, total_horizontal_bars)
%This function generates the voxel pattern. In this case, we are generating
%a 90 degree rasterization pattern. Here is an illustration of the pattern this function 
%is generating, it is the bottom left diagram:
%https://ars.els-cdn.com/content/image/1-s2.0-S2238785419301905-gr2.jpg
%Inputs:
%x_origin (float) - start of the x coordinate for infill pattern
%y_origin (float) - start of the y coordinate for infill pattern
%length (float) - this is the total length from the start of the infill pattern to
%the bottom of the infill pattern (note this does NOT start and end at the 
%borders of the pattern, the square in the diagram)
%width (float) - this is the width of the infill pattern, just like the length it
%does not start and end at the border of the infill pattern, but starts at
%the beginning of the infill pattern and ends at the y coordniate of where
%the pattern ends
%height (float) - height of the cube (may not need this input)
%has_defect (boolean) - boolean varaible to see if there are any defects in this
%voxel
%total_horizontal_bars (int) - total amount of horizontal bars you want in this voxel
%needs to be an even value and at least 2
%(default should be set to 28)
%Outputs:
%gcode - gcode string that draws the infill pattern

    %checks for illegal input arguments
    if length <= 0
        disp("Illegal Argument for length in gen_voxel_90_degrees(), length must be > 0");
        return;
    end
    if width <= 0
        disp("Illegal Argument for width in gen_voxel_90_degrees(), width must be > 0");
        return;
    end
    if height <= 0
        disp("Illegal Argument for height in gen_voxel_90_degrees(), height must be > 0");
        return;
    end
    if total_horizontal_bars < 2
        disp("Illegal Argument for total_horizontal_bars in gen_voxel_90_degrees(), must be >= 2");
        return;
    end
    if mod(total_horizontal_bars,2) == 1
        disp("Illegal Argument for total_horizontal_bars in gen_voxel_90_degrees(), must be an even value");
        return;
    end
    if total_horizontal_bars ~= floor(total_horizontal_bars)
        disp("Illegal Argument for total_horizontal_bars in gen_voxel_90_degrees(), must be integer value");
        return;
    end
    
    gcode = "M201\n"; %turn on laser
    bar_heights = width/total_horizontal_bars; %height of the horizontal portions
    number_of_up_left_down_left_patterns = fix(total_horizontal_bars/2);
    i = 0;
    x_value = x_origin; %current x coord value
    y_value = y_origin; %current y coord value
    gcode = gcode + "G01 X" + sprintf('%.4f',x_origin) + " Y" + sprintf('%.4f',y_origin) + "\n";
    
    while(i < number_of_up_left_down_left_patterns) %the pattern right-up-left-up is repeated 5 times
        

        [up_gcode, y] = upward(x_value, y_value, length);
        gcode = gcode + up_gcode;
        y_value = y;
        
        [left_gcode, x] = leftward(x_value, y_value, bar_heights);
        gcode = gcode + left_gcode;
        x_value = x;
        
        [down_gcode, y] = downward(x_value, y_value, length);
        gcode = gcode + down_gcode;
        y_value = y;
        
        [left_gcode, x] = leftward(x_value, y_value, bar_heights);
        gcode = gcode + left_gcode;
        x_value = x;
        
        i = i+1;
    end
    
    %Go up one more time to complete infill pattern
    [up_gcode, y] = upward(x_value, y_value, length);
    gcode = gcode + up_gcode;
    y_value = y;
    
    gcode = gcode + "M202";
    
    %Function returns upward sweep gcode in infill pattern and updated y
    %coord value
    function [upward_gcode, y_coord] = upward(x_start, y_start, length)
        upward_gcode = "";
        y_coord = y_start + length;
        upward_gcode = "G01 X" + sprintf('%.4f',x_start) + " Y" + sprintf('%.4f',y_coord) + "\n";
    end

    %Function returns leftward sweep gcode in infill pattern and updated x
    %coord value
    function [leftward_gcode, x_coord] = leftward(x_start, y_start, bar_heights)
        leftward_gcode = "";
        x_coord = x_start - bar_heights;
        leftward_gcode = "G01 X" + sprintf('%.4f',x_coord) + " Y" + sprintf('%.4f',y_start) + "\n";
    end

    %Function returns downward sweep gcode in infill pattern and updated y
    %coord value
    function [downward_gcode, y_coord] = downward(x_start, y_start, length)
        downward_gcode = "";
        y_coord = y_start - length;
        downward_gcode = "G01 X" + sprintf('%.4f',x_start) + " Y" + sprintf('%.4f',y_coord) + "\n";
    end

end
 