function [gcode] = gen_voxel(x_origin, y_origin, length, width, height, has_defect, total_vertical_bars)
%This function generates the voxel pattern. In this case, we are generating
%a 0 degree pattern. Here is an illustration of the pattern this function 
%is generating, it is the top left diagram:
%https://ars.els-cdn.com/content/image/1-s2.0-S2238785419301905-gr2.jpg
%Inputs:
%x_origin (float) - start of the x coordinate for infill pattern
%y_origin (float) - start of the y coordinate for infill pattern
%length (float) - this is the total length from the start of the infill pattern to
%the bottom of the infill pattern (note this does NOT start and end at the 
%borders of the pattern, the square in the diagram)
%width (float) - this is the width of the infill pattern, just like the length it
%does not start and end at the border of the infill pattern, but starts at
%the beginning of the infill pattern and ends at the point the pattern
%starts to move downwards
%height (float) - height of the cube (may not need this input)
%has_defect (boolean) - boolean varaible to see if there are any defects in this
%voxel
%total_vertical_bars (int) - total amount of vertical bars you want in this voxel
%needs to be odd value and at least 3
%(default should be set to 11)
%Outputs:
%gcode - gcode string that draws the infill pattern
    
    %checks for illegal input arguments
    if length <= 0
        disp("Illegal Argument for length in gen_voxel(), length must be > 0");
        return;
    end
    if width <= 0
        disp("Illegal Argument for width in gen_voxel(), width must be > 0");
        return;
    end
    if height <= 0
        disp("Illegal Argument for height in gen_voxel(), height must be > 0");
        return;
    end
    if total_vertical_bars < 3
        disp("Illegal Argument for total_vertical_bars in gen_voxel(), must be >= 3");
        return;
    end
    if mod(total_vertical_bars,2) == 0
        disp("Illegal Argument for total_vertical_bars in gen_voxel(), must be odd value");
        return;
    end
    if total_vertical_bars ~= floor(total_vertical_bars)
        disp("Illegal Argument for total_vertical_bars in gen_voxel(), must be integer value");
        return;
    end
    
    gcode = "M201\n"; %turn on laser
    %number_of_bars = 11; %at the moment, there are 11 bars for each voxel
    bar_heights = length/total_vertical_bars; %height of the downward portions
    number_of_right_up_left_up_patterns = fix(total_vertical_bars/2);
    i = 0;
    x_value = x_origin; %current x coord value
    y_value = y_origin; %current y coord value
    
    gcode = gcode + "G01 X" + x_origin + " Y" + y_origin + "\n";
    
    while(i < number_of_right_up_left_up_patterns) %the pattern right-up-left-up is repeated 5 times
        
        [right_gcode, x] = rightward(x_value, y_value, width);
        gcode = gcode + right_gcode;
        x_value = x;
        
        [up_gcode, y] = upward(x_value, y_value, bar_heights);
        gcode = gcode + up_gcode;
        y_value = y;
        
        [left_gcode, x] = leftward(x_value, y_value, width);
        gcode = gcode + left_gcode;
        x_value = x;
        
        [up_gcode, y] = upward(x_value, y_value, bar_heights);
        gcode = gcode + up_gcode;
        y_value = y;
        
        
        
        i = i+1;
    end
    
    %pattern right-up-left finishes the infill pattern
    [right_gcode, x] = rightward(x_value, y_value, width);
    gcode = gcode + right_gcode;
    x_value = x;
        
    [up_gcode, y] = upward(x_value, y_value, bar_heights);
    gcode = gcode + up_gcode;
    y_value = y;
        
    [left_gcode, x] = leftward(x_value, y_value, width);
    gcode = gcode + left_gcode;
    x_value = x;
    
    gcode = gcode + "M202"; %turn off laser
    
    %Function returns rightward sweep gcode in infill pattern and updated x
    %coord value
    function [rightward_gcode, x_coord] = rightward(x_start, y_start, width)
        rightward_gcode = "";
        x_coord = x_start + width;
        rightward_gcode = "G01 X" + x_coord + " Y" + y_start + "\n";  
    end
    
    %Function returns downward sweep gcod in infill pattern and updated y
    %coord value
    function [upward_gcode, y_coord] = upward(x_start, y_start, bar_heights)
        upward_gcode = "";
        y_coord = y_start + bar_heights;
        upward_gcode = "G01 X" + x_start + " Y" + y_coord + "\n";
    end

    %Function returns leftward sweep gcode in infill pattern and updated x
    %coord value
    function [leftward_gcode, x_coord] = leftward(x_start, y_start, width)
        leftward_gcode = "";
        x_coord = x_start - width;
        leftward_gcode = "G01 X" + x_coord + " Y" + y_start + "\n";
    end

end
