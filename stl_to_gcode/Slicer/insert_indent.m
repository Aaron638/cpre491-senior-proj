function [gcode] = insert_indent(gcode_file, x_start_indent, y_start_indent, z_start_indent, x_size, y_size, z_size, cube_length, cube_width, cube_height)

    %Check for illegal arguments
    if x_start_indent == 0 || y_start_indent == 0 || z_start_indent == 0
        disp("Illegal Argument in inser_indent(), indent cannot start at 0 for any coordinate");
        return;
    end
    if (x_start_indent + x_size) >= cube_width
        disp("Illegal Argument in insert_indent(), width of indent cannot be at or extend pass the bounds of cube");
        return;
    end
    if (y_start_indent + y_size) >= cube_length
        disp("Illegal Argument in insert_indent(), length of indent cannot be at or extend pass the bounds of cube");
        return;
    end
    if(z_start_indent + z_size) >= cube_height
        disp("Illegal Argument in insert_indent(), height of indent cannot be at or extend pass the bounds of cube");
        return;
    end

    

    
